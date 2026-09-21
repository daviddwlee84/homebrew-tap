import copy
import importlib.util
import io
import json
import struct
import tarfile
import tempfile
import unittest
from pathlib import Path
from unittest import mock

SPEC = importlib.util.spec_from_file_location('tap_sync', Path(__file__).resolve().parents[1] / 'scripts/sync.py')
sync = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(sync)
TOOLS = json.loads((sync.ROOT / 'tools.json').read_text())


def fixture(tool=None, version='1.2.3'):
    tool = tool or TOOLS[0]
    release = {'id': 17, 'tag_name': 'v' + version, 'draft': False, 'prerelease': False, 'assets': []}
    sums = []
    for number, target in enumerate(sync.TARGETS):
        system, arch = target.split('_')
        name = tool['archive'].format(tag=release['tag_name'], version=version, os=system, arch=arch)
        digest = str(number + 1) * 64
        release['assets'].append({'id': number + 1, 'name': name, 'size': 100,
            'browser_download_url': f'https://github.com/{tool["repo"]}/releases/download/v{version}/{name}',
            'digest': 'sha256:' + digest})
        sums.append(digest + '  ' + name)
    release['assets'].append({'id': 90, 'name': tool['checksums'], 'size': 100,
        'browser_download_url': f'https://github.com/{tool["repo"]}/releases/download/v{version}/{tool["checksums"]}'})
    return release, '\n'.join(sums) + '\n'


class ReleaseContracts(unittest.TestCase):
    def test_registry_is_exactly_seven_distinct_formulas_and_binaries(self):
        self.assertEqual({t['formula'] for t in TOOLS}, {'dev-cli', 'translate', 'exp-cli', 'lazychezmoi', 'lazyclash', 'lazymlflow', 'lazypueue'})
        self.assertEqual(len({t['binary'] for t in TOOLS}), 7)

    def test_all_archive_conventions_and_four_platforms(self):
        for tool in TOOLS:
            plan = sync.release_plan(tool, *fixture(tool))
            self.assertEqual(set(plan['assets']), set(sync.TARGETS))
            self.assertIn('_v1.2.3_' if tool['binary'] == 'dev' else '_1.2.3_', plan['assets']['linux_amd64']['name'])

    def test_missing_asset_and_checksum_fail_closed(self):
        for mutation in ('asset', 'checksum'):
            release, sums = fixture()
            if mutation == 'asset':
                release['assets'].pop(0)
            else:
                sums = '\n'.join(sums.splitlines()[1:])
            with self.assertRaisesRegex(ValueError, 'missing'):
                sync.release_plan(TOOLS[0], release, sums)

    def test_malformed_duplicate_and_api_disagreeing_checksums(self):
        for text in ('bad  file', 'a' * 64 + '  x\n' + 'b' * 64 + '  x'):
            with self.assertRaises(ValueError):
                sync.checksum_map(text)
        release, sums = fixture()
        release['assets'][0]['digest'] = 'sha256:' + '0' * 64
        with self.assertRaisesRegex(ValueError, 'disagree'):
            sync.release_plan(TOOLS[0], release, sums)

    def test_untrusted_asset_url_rejected(self):
        release, sums = fixture()
        release['assets'][0]['browser_download_url'] = 'https://example.test/asset'
        with self.assertRaisesRegex(ValueError, 'URL'):
            sync.release_plan(TOOLS[0], release, sums)

    def test_prerelease_draft_and_non_semver_rejected(self):
        for changes in ({'prerelease': True}, {'draft': True}, {'tag_name': 'latest'}, {'tag_name': 'v1.2.3-rc1'}):
            release, sums = fixture()
            release.update(changes)
            with self.assertRaises(ValueError):
                sync.release_plan(TOOLS[0], release, sums)

    def test_same_version_is_noop_but_changed_artifact_is_rejected(self):
        plan = sync.release_plan(TOOLS[0], *fixture())
        self.assertTrue(sync.guard_previous(plan, copy.deepcopy(plan)))
        for field, value in (('asset_id', 999), ('sha256', '9' * 64), ('size', 999)):
            changed = copy.deepcopy(plan)
            changed['assets']['linux_amd64'][field] = value
            with self.assertRaisesRegex(ValueError, 'same-tag'):
                sync.guard_previous(plan, changed)

    def test_replaced_checksum_manifest_is_not_a_same_version_noop(self):
        plan = sync.release_plan(TOOLS[0], *fixture())
        changed = copy.deepcopy(plan)
        changed['checksum_asset_id'] += 1
        with self.assertRaisesRegex(ValueError, 'same-tag'):
            sync.guard_previous(plan, changed)

    def test_downgrade_is_rejected(self):
        old = sync.release_plan(TOOLS[0], *fixture(version='2.0.0'))
        new = sync.release_plan(TOOLS[0], *fixture())
        with self.assertRaisesRegex(ValueError, 'downgrade'):
            sync.guard_previous(old, new)

    def test_stable_is_binary_and_head_is_only_build_dependency(self):
        for tool in TOOLS:
            rendered = sync.render_formula(tool, sync.release_plan(tool, *fixture(tool)))
            self.assertIn(f'bin.install "{tool["binary"]}"', rendered)
            self.assertNotIn('archive/refs/tags', rendered)
            self.assertEqual('depends_on "go"' in rendered, tool['head'])
            if tool['head']:
                self.assertIn('branch: "main"\n    depends_on "go" => :build', rendered)


class ArtifactContracts(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)

    def archive(self, entries):
        archive = self.root / 'test.tar.gz'
        with tarfile.open(archive, 'w:gz') as bundle:
            for name, kind in entries:
                item = tarfile.TarInfo(name)
                if kind == 'link':
                    item.type = tarfile.SYMTYPE
                    item.linkname = '/tmp/outside'
                    bundle.addfile(item)
                else:
                    item.size = 3
                    bundle.addfile(item, io.BytesIO(b'abc'))
        return archive

    def test_unsafe_archive_paths_and_links_are_rejected(self):
        for name, kind in (('../dev', 'file'), ('/dev', 'file'), ('dev', 'link')):
            with self.assertRaisesRegex(ValueError, 'unsafe'):
                sync.unpack_verified(TOOLS[0], self.archive([(name, kind)]), self.root / 'unpack')

    def test_flat_binary_and_bundled_completions_are_required(self):
        with self.assertRaisesRegex(ValueError, 'missing'):
            sync.unpack_verified(TOOLS[0], self.archive([('nested/dev', 'file')]), self.root / 'unpack')
        with self.assertRaisesRegex(ValueError, 'missing'):
            sync.unpack_verified(TOOLS[1], self.archive([('translate', 'file')]), self.root / 'unpack')

    def test_binary_architecture_validation(self):
        binary = self.root / 'binary'
        for target in sync.TARGETS:
            system, arch = target.split('_')
            data = bytearray(64)
            if system == 'linux':
                data[:6] = b'\x7fELF\x02\x01'
                struct.pack_into('<H', data, 18, 62 if arch == 'amd64' else 183)
            else:
                data[:4] = b'\xcf\xfa\xed\xfe'
                struct.pack_into('<I', data, 4, 0x1000007 if arch == 'amd64' else 0x100000C)
            binary.write_bytes(data)
            sync.validate_binary(binary, target)
            with self.assertRaises(ValueError):
                sync.validate_binary(binary, target.replace(arch, 'arm64' if arch == 'amd64' else 'amd64'))


class SynchronizationContracts(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.formula = self.root / 'Formula/dev-cli.rb'
        self.receipt = self.root / '.sync-state/dev-cli.json'
        release, self.sums = fixture()
        self.plan = sync.release_plan(TOOLS[0], release, self.sums)
        patch = mock.patch.object(sync, 'fetch', side_effect=lambda url: json.dumps(release).encode() if 'api.github.com' in url else self.sums.encode())
        patch.start()
        self.addCleanup(patch.stop)
        patch = mock.patch.object(sync, 'validate_assets')
        self.validate = patch.start()
        self.addCleanup(patch.stop)
        patch = mock.patch.object(sync, 'run')
        patch.start()
        self.addCleanup(patch.stop)

    def invoke(self, **changes):
        options = dict(root=self.root, write=True, bootstrap=False, smoke=mock.Mock())
        options.update(changes)
        return sync.sync_tool(TOOLS[0], **options)

    def test_same_version_skips_binary_download_smoke_and_writes(self):
        self.formula.parent.mkdir()
        self.formula.write_text(sync.render_formula(TOOLS[0], self.plan))
        self.receipt.parent.mkdir()
        self.receipt.write_text(json.dumps(self.plan))
        stamp = self.formula.stat().st_mtime_ns
        self.assertIn('unchanged', self.invoke())
        self.validate.assert_not_called()
        self.assertEqual(stamp, self.formula.stat().st_mtime_ns)

    def test_existing_formula_requires_bootstrap(self):
        self.formula.parent.mkdir()
        self.formula.write_text('existing')
        with self.assertRaisesRegex(ValueError, 'bootstrap'):
            self.invoke()
        self.assertEqual(self.formula.read_text(), 'existing')

    def test_smoke_failure_restores_old_formula_and_leaves_no_receipt(self):
        self.formula.parent.mkdir()
        self.formula.write_text('existing')
        with self.assertRaisesRegex(RuntimeError, 'smoke'):
            self.invoke(bootstrap=True, smoke=mock.Mock(side_effect=RuntimeError('smoke failed')))
        self.assertEqual(self.formula.read_text(), 'existing')
        self.assertFalse(self.receipt.exists())

    def test_failed_new_formula_is_not_left_for_commit(self):
        with self.assertRaises(RuntimeError):
            self.invoke(smoke=mock.Mock(side_effect=RuntimeError('smoke failed')))
        self.assertFalse(self.formula.exists())

    def test_validation_only_does_not_write(self):
        self.assertIn('no writes', self.invoke(write=False))
        self.assertFalse(self.formula.exists())
        self.assertFalse(self.receipt.exists())

    def test_partial_success_continues_but_returns_failure(self):
        with mock.patch.object(sync, 'sync_tool', side_effect=[ValueError('bad checksum'), 'updated v1.2.3']) as call:
            self.assertEqual(sync.sync_all(TOOLS[:2]), 1)
            self.assertEqual(call.call_count, 2)

    def test_success_records_verified_identity(self):
        smoke = mock.Mock()
        self.invoke(smoke=smoke)
        smoke.assert_called_once_with(TOOLS[0])
        self.assertEqual(json.loads(self.receipt.read_text()), self.plan)


if __name__ == '__main__':
    unittest.main()
