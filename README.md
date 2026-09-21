# homebrew-tap

Prebuilt Homebrew formulas for seven personal CLI/TUI tools:

```sh
brew install daviddwlee84/tap/dev-cli
brew install daviddwlee84/tap/translate
brew install daviddwlee84/tap/exp-cli
brew install daviddwlee84/tap/lazychezmoi
brew install daviddwlee84/tap/lazyclash
brew install daviddwlee84/tap/lazymlflow
brew install daviddwlee84/tap/lazypueue
```

`dev-cli` installs `dev`; `exp-cli` installs `exp`. Stable formulas install
checksummed release binaries on macOS and Linux, for arm64 and amd64. These are
formulas, not casks. Bash/zsh completions are included. Agent skills and service
configuration remain explicit user actions. `dev-cli --HEAD` and `translate
--HEAD` retain their Go source-build paths.

## One writer for formulas

This repository owns the formula registry in `tools.json` and the renderer in
`scripts/sync.py`. Source repositories publish GitHub releases and any Scoop
manifests; they do not push formulas here or require a tap-writing token.

The **Sync stable formulas** workflow runs at minute 17 each hour and supports
manual dispatch. Its own repository-scoped `GITHUB_TOKEN` reads public releases
and commits successful updates. No cross-repository token is needed.

```sh
# All seven tools:
gh workflow run sync.yml --repo daviddwlee84/homebrew-tap
# Select one formula:
gh workflow run sync.yml --repo daviddwlee84/homebrew-tap -f tool=dev-cli
# First migration of an existing formula without a .sync-state receipt:
gh workflow run sync.yml --repo daviddwlee84/homebrew-tap -f tool=dev-cli -f bootstrap=true
```

Only stable `vMAJOR.MINOR.PATCH` releases are accepted. Four platform assets and
their release checksum file must exist. Each archive is checksum-verified,
checked for safe members and the correct executable architecture, and the native
binary is exercised in a temporary home. Ruby parsing, Homebrew style/audit,
installation, and `brew test` must pass before a formula and its receipt are kept.
The installation smoke runs on an isolated Linux GitHub runner, not the user's
Homebrew installation. Cross-platform archives are inspected, not all executed.

Unchanged versions produce no commits. The receipt records release and asset
identity; a changed checksum, asset, or release under an already-recorded tag is
an error. Publish a new version instead of moving tags or replacing assets.
Failed checks preserve the prior formula. Each tool is processed independently:
successful tools can be committed while the job still reports any failed tool.

`--bootstrap` validates the existing unrecorded formulas during the initial
source-to-binary migration. It does not bypass immutable-tag checks once a
receipt exists, nor allow a version downgrade. Do not hand-edit generated
formulas or `.sync-state` receipts.

## Validation

```sh
python3 -m unittest discover -s tests -v
actionlint .github/workflows/*.yml
# Download, verify, and exercise a native binary without changing formulas:
python3 scripts/sync.py --tool dev-cli --bootstrap
```

Writing requires `--write --brew-smoke` with this checkout registered as the tap.
Use the workflow for that operation so installing formula candidates cannot
replace tools on a developer's machine. Release artifacts use the existing
`dev-cli_vVERSION_OS_ARCH.tar.gz`/`SHA256SUMS` and
`translate_VERSION_OS_ARCH.tar.gz`/`checksums.txt` layouts; the five newer tools
use `REPO_VERSION_OS_ARCH.tar.gz` and `checksums.txt`.
