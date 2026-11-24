"""Offline synthetic tests for the Registry comparator."""
import csv
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from compare_registry_exports import compare, read_inventory


class RegistryComparisonTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.base = Path(self.tmp.name)

    def row(self, name, path, version='1.0'):
        return {
            'DisplayName': name, 'DisplayVersion': version,
            'Publisher': 'Example', 'InstallDate': '20261109', 'PSPath': path
        }

    def make_csv(self, name, rows):
        file = self.base / name
        with file.open('w', newline='', encoding='utf-8') as output:
            writer = csv.DictWriter(output, fieldnames=list(self.row('', '').keys()))
            writer.writeheader()
            writer.writerows(rows)
        return file

    def test_added_registry_entry(self):
        old = self.make_csv('before.csv', [self.row('App A', 'HKLM:AppA')])
        new = self.make_csv('after.csv', [self.row('App A', 'HKLM:AppA'),
                                          self.row('App B', 'HKLM:AppB')])
        diff = compare(old, new)
        self.assertEqual(diff['before_count'], 1)
        self.assertEqual(diff['after_count'], 2)
        self.assertEqual([x['DisplayName'] for x in diff['added']], ['App B'])
        self.assertEqual(diff['modified'], [])

    def test_modified_version(self):
        old = self.make_csv('before.csv', [self.row('App A', 'HKLM:AppA')])
        new = self.make_csv('after.csv', [self.row('App A', 'HKLM:AppA', '2.0')])
        diff = compare(old, new)
        self.assertEqual(len(diff['modified']), 1)
        self.assertEqual(diff['modified'][0]['after']['DisplayVersion'], '2.0')

    def test_removed_entry(self):
        old = self.make_csv('before.csv', [self.row('App A', 'HKLM:AppA')])
        new = self.make_csv('after.csv', [])
        self.assertEqual(len(compare(old, new)['removed']), 1)

    def test_reject_duplicate(self):
        source = self.make_csv('bad.csv', [self.row('App A', 'HKLM:AppA')] * 2)
        with self.assertRaises(ValueError):
            read_inventory(source)

    def test_reject_missing_columns(self):
        source = self.base / 'bad.csv'
        source.write_text('DisplayName\nApp A\n', encoding='utf-8')
        with self.assertRaises(ValueError):
            read_inventory(source)


if __name__ == '__main__':
    unittest.main()
