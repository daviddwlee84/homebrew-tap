#!/usr/bin/env python3
"""Validate stable release assets and update this tap, one tool at a time."""

import argparse
import hashlib
import json
import os
import platform
import re
import struct
import subprocess
import sys
import tarfile
import tempfile
import time
import urllib.error
import urllib.request
from pathlib import Path, PurePosixPath

ROOT = Path(__file__).resolve().parents[1]
TARGETS = ("darwin_arm64", "darwin_amd64", "linux_arm64", "linux_amd64")
TAG = re.compile(r"^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$")
SHA256 = re.compile(r"^[0-9a-f]{64}$")


def fetch(url):
    headers = {"User-Agent": "homebrew-tap-release-sync"}
    if url.startswith("https://api.github.com/"):
        headers["Accept"] = "application/vnd.github+json"
        token = os.environ.get("GH_TOKEN") or os.environ.get("GITHUB_TOKEN")
        if token:
            headers["Authorization"] = "Bearer " + token
    for attempt in range(3):
        try:
            with urllib.request.urlopen(urllib.request.Request(url, headers=headers), timeout=90) as response:
                return response.read()
        except (urllib.error.URLError, TimeoutError):
            if attempt == 2:
                raise
            time.sleep(2 * (attempt + 1))


def checksum_map(text):
    result = {}
    for line in text.splitlines():
        if not line.strip():
            continue
        fields = line.split()
        if len(fields) != 2 or not SHA256.fullmatch(fields[0]):
            raise ValueError("invalid checksum line")
        name = fields[1].removeprefix("*")
        if name in result:
            raise ValueError("duplicate checksum: " + name)
        result[name] = fields[0]
    return result


def release_plan(tool, release, checksums):
    tag = release.get("tag_name", "")
    if not TAG.fullmatch(tag) or release.get("draft") or release.get("prerelease"):
        raise ValueError("latest release is not a stable vMAJOR.MINOR.PATCH release")
    assets = {}
    for asset in release.get("assets", []):
        if asset["name"] in assets:
            raise ValueError("duplicate release asset: " + asset["name"])
        assets[asset["name"]] = asset
    selected = {}
    sums = checksum_map(checksums)
    for target in TARGETS:
        system, arch = target.split("_")
        name = tool["archive"].format(tag=tag, version=tag[1:], os=system, arch=arch)
        if name not in assets or name not in sums:
            raise ValueError("missing release asset or checksum: " + name)
        asset = assets[name]
        expected_url = f'https://github.com/{tool["repo"]}/releases/download/{tag}/{name}'
        if asset.get("browser_download_url") != expected_url:
            raise ValueError("unexpected asset URL: " + name)
        digest = asset.get("digest")
        if digest and digest != "sha256:" + sums[name]:
            raise ValueError("API digest and checksum disagree: " + name)
        selected[target] = {"name": name, "url": expected_url, "sha256": sums[name],
                            "asset_id": asset["id"], "size": asset["size"]}
    return {"version": tag[1:], "tag": tag, "release_id": release["id"], "assets": selected}


def guard_previous(previous, plan):
    if not previous:
        return False
    old_version = tuple(map(int, previous["version"].split(".")))
    new_version = tuple(map(int, plan["version"].split(".")))
    if new_version < old_version:
        raise ValueError("refusing release downgrade")
    if new_version == old_version:
        if previous != plan:
            raise ValueError("same-tag release assets changed; publish a new immutable version")
        return True
    return False


def formula_class(name):
    return "".join(word.capitalize() for word in name.split("-"))


def render_formula(tool, plan):
    binary = tool["binary"]
    lines = [f'class {formula_class(tool["formula"])} < Formula',
             f'  desc {json.dumps(tool["description"])}',
             f'  homepage "https://github.com/{tool["repo"]}"',
             f'  version "{plan["version"]}"', f'  license "{tool["license"]}"', ""]
    for system, block in (("darwin", "on_macos"), ("linux", "on_linux")):
        lines.append(f"  {block} do")
        for arch, selector in (("arm64", "on_arm"), ("amd64", "on_intel")):
            asset = plan["assets"][system + "_" + arch]
            lines += [f"    {selector} do", f'      url "{asset["url"]}"',
                      f'      sha256 "{asset["sha256"]}"', "    end"]
        lines += ["  end", ""]
    if tool["head"]:
        lines += ["  head do", f'    url "https://github.com/{tool["repo"]}.git", branch: "main"',
                  '    depends_on "go" => :build', "  end", ""]
    lines += ["  def install"]
    if tool["head"]:
        lines += ["    if build.head?"]
        if binary == "dev":
            lines += ['      ldflags = "-s -w -X github.com/daviddwlee84/dev-cli/internal/cli.Version=HEAD"',
                      '      system "go", "build", *std_go_args(output: bin/"dev", ldflags: ldflags), "./cmd/dev"']
        else:
            lines += ['      system "go", "build", *std_go_args(ldflags: "-s -w")']
        lines += [f'      generate_completions_from_executable(bin/"{binary}", shell_parameter_format: :cobra)', "    else"]
    indent = "      " if tool["head"] else "    "
    lines += [f'{indent}bin.install "{binary}"']
    if tool["bundled_completions"]:
        lines += [f'{indent}bash_completion.install "completions/{binary}.bash" => "{binary}"',
                  f'{indent}zsh_completion.install "completions/{binary}.zsh" => "_{binary}"']
    else:
        lines += [f'{indent}generate_completions_from_executable(bin/"{binary}", shell_parameter_format: :cobra)']
    if tool["head"]:
        lines += ["    end"]
    lines += ["  end", "", "  test do", f'    assert_match version.to_s, shell_output("#{{bin}}/{binary} --version")',
              f'    assert_match "Usage:", shell_output("#{{bin}}/{binary} --help")', "  end", "end", ""]
    return "\n".join(lines)


def unpack_verified(tool, archive, destination):
    required = [tool["binary"]]
    if tool["bundled_completions"]:
        required += ["LICENSE", f'completions/{tool["binary"]}.bash', f'completions/{tool["binary"]}.zsh']
    with tarfile.open(archive, "r:gz") as bundle:
        members = {}
        for member in bundle.getmembers():
            path = PurePosixPath(member.name)
            if path.is_absolute() or ".." in path.parts or member.issym() or member.islnk():
                raise ValueError("unsafe archive member")
            if not member.isdir() and not member.isfile():
                raise ValueError("unsupported archive member")
            if member.name in members:
                raise ValueError("duplicate archive member")
            members[member.name] = member
        for name in required:
            member = members.get(name)
            if not member or not member.isfile() or member.size == 0:
                raise ValueError("archive missing nonempty regular file: " + name)
            target = destination / name
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(bundle.extractfile(member).read())
            target.chmod(0o755 if name == tool["binary"] else 0o644)


def run(argv, **kwargs):
    subprocess.run(argv, check=True, timeout=900, **kwargs)


def validate_binary(path, target):
    data = path.read_bytes()[:64]
    system, arch = target.split("_")
    if system == "linux":
        if len(data) < 20 or data[:6] != b"\x7fELF\x02\x01":
            raise ValueError("expected a 64-bit little-endian ELF binary")
        machine = struct.unpack_from("<H", data, 18)[0]
        expected = {"amd64": 62, "arm64": 183}[arch]
    else:
        if len(data) < 8 or data[:4] != b"\xcf\xfa\xed\xfe":
            raise ValueError("expected a 64-bit little-endian Mach-O binary")
        machine = struct.unpack_from("<I", data, 4)[0]
        expected = {"amd64": 0x1000007, "arm64": 0x100000C}[arch]
    if machine != expected:
        raise ValueError("binary architecture disagrees with release asset name")


def atomic_write(path, content):
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(dir=path.parent, prefix=".sync-", delete=False) as output:
        staged = Path(output.name)
        output.write(content)
    try:
        staged.replace(path)
    finally:
        staged.unlink(missing_ok=True)


def validate_assets(tool, plan, work):
    native_os = {"Darwin": "darwin", "Linux": "linux"}.get(platform.system())
    native_arch = {"arm64": "arm64", "aarch64": "arm64", "x86_64": "amd64", "AMD64": "amd64"}.get(platform.machine())
    native = f"{native_os}_{native_arch}"
    if native not in TARGETS:
        raise ValueError("unsupported smoke-test host")
    for target, asset in plan["assets"].items():
        content = fetch(asset["url"])
        if len(content) != asset["size"] or hashlib.sha256(content).hexdigest() != asset["sha256"]:
            raise ValueError("archive size/checksum mismatch: " + asset["name"])
        archive = work / asset["name"]
        archive.write_bytes(content)
        unpack = work / target
        unpack_verified(tool, archive, unpack)
        validate_binary(unpack / tool["binary"], target)
        if target == native:
            home = work / "home"
            home.mkdir(exist_ok=True)
            env = {**os.environ, "HOME": str(home), "XDG_CONFIG_HOME": str(home / "config"),
                   "XDG_DATA_HOME": str(home / "data"), "XDG_STATE_HOME": str(home / "state"),
                   "XDG_CACHE_HOME": str(home / "cache")}
            binary = str(unpack / tool["binary"])
            version = subprocess.run([binary, "--version"], env=env, capture_output=True, text=True, check=True, timeout=30).stdout
            if plan["version"] not in version:
                raise ValueError("binary version does not match release tag")
            for shell in ("bash", "zsh"):
                completion = subprocess.run([binary, "completion", shell], env=env, capture_output=True, check=True, timeout=30).stdout
                if not completion.strip():
                    raise ValueError("empty generated completion")


def brew_smoke(tool):
    name = "daviddwlee84/tap/" + tool["formula"]
    run(["brew", "style", name])
    run(["brew", "audit", "--strict", name])
    run(["brew", "install", "--formula", "--build-from-source", name])
    run(["brew", "test", name])


def sync_tool(tool, *, root, write, bootstrap, smoke):
    release = json.loads(fetch(f'https://api.github.com/repos/{tool["repo"]}/releases/latest'))
    tag = release.get("tag_name", "")
    if not TAG.fullmatch(tag) or release.get("draft") or release.get("prerelease"):
        raise ValueError("latest release is not stable")
    sums_url = f'https://github.com/{tool["repo"]}/releases/download/{tag}/{tool["checksums"]}'
    # Ensure the checksum file is a published asset, rather than guessing a URL.
    if not any(a["name"] == tool["checksums"] and a.get("browser_download_url") == sums_url for a in release.get("assets", [])):
        raise ValueError("release checksum asset is missing")
    sums_data = fetch(sums_url)
    sums_asset = next(a for a in release["assets"] if a["name"] == tool["checksums"])
    if sums_asset.get("digest") and sums_asset["digest"] != "sha256:" + hashlib.sha256(sums_data).hexdigest():
        raise ValueError("checksum manifest digest mismatch")
    plan = release_plan(tool, release, sums_data.decode("utf-8"))
    formula = root / "Formula" / (tool["formula"] + ".rb")
    receipt = root / ".sync-state" / (tool["formula"] + ".json")
    previous = json.loads(receipt.read_text()) if receipt.exists() else None
    rendered = render_formula(tool, plan)
    if guard_previous(previous, plan):
        if not formula.exists() or formula.read_text() != rendered:
            raise ValueError("same-version generated formula drift; review the change explicitly")
        return "unchanged " + plan["tag"]
    if previous is None and formula.exists() and not bootstrap:
        raise ValueError("existing formula needs an explicit bootstrap run")
    if previous is None and formula.exists():
        old_version = re.search(r'version "([0-9]+\.[0-9]+\.[0-9]+)"|/tags/v([0-9]+\.[0-9]+\.[0-9]+)', formula.read_text())
        if old_version and tuple(map(int, next(v for v in old_version.groups() if v).split("."))) > tuple(map(int, plan["version"].split("."))):
            raise ValueError("bootstrap would downgrade the existing formula")
    with tempfile.TemporaryDirectory(prefix="tap-sync-") as directory:
        work = Path(directory)
        candidate = work / formula.name
        candidate.write_text(rendered)
        run(["ruby", "-c", str(candidate)])
        validate_assets(tool, plan, work)
        if not write:
            return "validated " + plan["tag"] + " (no writes)"
        old = formula.read_bytes() if formula.exists() else None
        old_receipt = receipt.read_bytes() if receipt.exists() else None
        try:
            atomic_write(formula, rendered.encode())
            smoke(tool)
            atomic_write(receipt, (json.dumps(plan, indent=2, sort_keys=True) + "\n").encode())
        except Exception:
            if old is None:
                formula.unlink(missing_ok=True)
            else:
                atomic_write(formula, old)
            if old_receipt is None:
                receipt.unlink(missing_ok=True)
            else:
                atomic_write(receipt, old_receipt)
            raise
    return "updated " + plan["tag"]


def sync_all(tools, **kwargs):
    failed = False
    results = []
    for tool in tools:
        try:
            result = sync_tool(tool, **kwargs)
        except Exception as error:
            failed = True
            result = "FAILED: " + str(error)
        line = f'{tool["formula"]}: {result}'
        print(line, flush=True)
        results.append(line)
    if os.environ.get("GITHUB_STEP_SUMMARY"):
        with open(os.environ["GITHUB_STEP_SUMMARY"], "a") as summary:
            summary.write("## Stable formula sync\n\n" + "\n".join("- " + line for line in results) + "\n")
    return 1 if failed else 0


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--tool", action="append", default=[])
    parser.add_argument("--write", action="store_true", help="write only after formula installation smoke tests")
    parser.add_argument("--bootstrap", action="store_true", help="validate and initialize existing unrecorded formulas")
    parser.add_argument("--brew-smoke", action="store_true", help="install/test formulas in an isolated CI runner")
    args = parser.parse_args()
    if args.write and not args.brew_smoke:
        parser.error("--write requires --brew-smoke; use an isolated CI runner")
    tools = json.loads((ROOT / "tools.json").read_text())
    unknown = set(args.tool) - {tool["formula"] for tool in tools}
    if unknown:
        parser.error("unknown tool(s): " + ", ".join(sorted(unknown)))
    selected = [tool for tool in tools if not args.tool or tool["formula"] in args.tool]
    return sync_all(selected, root=ROOT, write=args.write, bootstrap=args.bootstrap, smoke=brew_smoke)


if __name__ == "__main__":
    sys.exit(main())
