#!/usr/bin/env python3
"""Compare original-format Windows uninstall-key CSV exports.

New portfolio utility written after the lab. No network and no third-party packages.
Not claimed to be the script originally run on Nov. 9, 2026.
"""
import argparse
import csv
import json
from pathlib import Path

COLUMNS = ('DisplayName', 'DisplayVersion', 'Publisher', 'InstallDate', 'PSPath')


def read_inventory(path):
    """Load Registry entries keyed by (case-insensitive Registry path, display name)."""
    rows = {}
    with Path(path).open(encoding='utf-8-sig', newline='') as stream:
        reader = csv.DictReader(stream)
        if reader.fieldnames is None or not set(COLUMNS).issubset(reader.fieldnames):
            raise ValueError(f'{path}: missing columns: {", ".join(COLUMNS)}')
        for line, row in enumerate(reader, 2):
            record = {field: (row.get(field) or '').strip() for field in COLUMNS}
            if not record['DisplayName'] or not record['PSPath']:
                raise ValueError(f'{path}:{line}: empty DisplayName or PSPath')
            key = (record['PSPath'].casefold(), record['DisplayName'].casefold())
            if key in rows:
                raise ValueError(f'{path}:{line}: duplicate Registry item')
            rows[key] = record
    return rows


def compare(before, after):
    old = read_inventory(before)
    new = read_inventory(after)
    return {
        'before_count': len(old),
        'after_count': len(new),
        'added': [new[key] for key in sorted(new.keys() - old.keys())],
        'removed': [old[key] for key in sorted(old.keys() - new.keys())],
        'modified': [
            {'before': old[key], 'after': new[key]}
            for key in sorted(old.keys() & new.keys())
            if old[key] != new[key]
        ],
    }


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('before', help='original before-export CSV')
    parser.add_argument('after', help='original after-export CSV')
    parser.add_argument('--output', help='optional JSON destination path')
    args = parser.parse_args(argv)
    report = json.dumps(compare(args.before, args.after), indent=2) + '\n'
    if args.output:
        Path(args.output).write_text(report, encoding='utf-8')
    else:
        print(report, end='')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
