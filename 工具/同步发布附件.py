#!/usr/bin/env python3
"""Recover the exact published PDF and ZIP into their Git LFS repository paths."""
from pathlib import Path
import argparse
import hashlib
import json
import os
import tempfile
import urllib.request

ROOT = Path(__file__).resolve().parents[1]
RELEASE = (
    'https://github.com/liyiliuxingyu/'
    '2026-yantai-primary-school-mathematics-grade-4-volume-1-synchronized-workbook/'
    'releases/download/v2026.11.25/'
)
ASSETS = (
    {
        'asset': 'answers.pdf',
        'path': '答案/小学数学同步练习册四年级上册答案.pdf',
        'bytes': 143553201,
        'sha256': '894c4561d4cd07bac0cab90d360ef6104870cd3dac4924c74a4b0bcb9a0096c9',
    },
    {
        'asset': 'workbook-project.zip',
        'path': '工程包/workbook-project.zip',
        'bytes': 106044118,
        'sha256': '9eff049d389913f27e1230b05413bd25d192da08febeba78749a1cbe21ae80e8',
    },
)


def digest(path):
    value = hashlib.sha256()
    with path.open('rb') as source:
        for chunk in iter(lambda: source.read(1024 * 1024), b''):
            value.update(chunk)
    return value.hexdigest()


def is_expected_pointer(path, item):
    if path.stat().st_size > 1024:
        return False
    expected = (
        'version https://git-lfs.github.com/spec/v1\n'
        f"oid sha256:{item['sha256']}\n"
        f"size {item['bytes']}\n"
    ).encode('ascii')
    return path.read_bytes() == expected


def ensure_asset(item, check_only=False):
    target = ROOT / item['path']
    if target.is_symlink():
        raise RuntimeError(f'Refusing a symlink: {item["path"]}')
    if target.exists():
        if target.is_file() and target.stat().st_size == item['bytes'] and digest(target) == item['sha256']:
            return {'path': item['path'], 'status': 'already_verified'}
        if not target.is_file() or not is_expected_pointer(target, item):
            raise RuntimeError(f'Refusing to overwrite different existing content: {item["path"]}')
    if check_only:
        raise RuntimeError(f'Full file is missing; run git lfs pull: {item["path"]}')
    target.parent.mkdir(parents=True, exist_ok=True)
    descriptor, temporary_name = tempfile.mkstemp(prefix='.release-asset-', suffix='.part', dir=target.parent)
    temporary = Path(temporary_name)
    try:
        request = urllib.request.Request(RELEASE + item['asset'], headers={'User-Agent': 'workbook-repository-asset-recovery/1.0'})
        value = hashlib.sha256()
        total = 0
        with os.fdopen(descriptor, 'wb') as output, urllib.request.urlopen(request, timeout=90) as response:
            while True:
                chunk = response.read(1024 * 1024)
                if not chunk:
                    break
                total += len(chunk)
                if total > item['bytes']:
                    raise RuntimeError(f'Download exceeds the recorded size: {item["asset"]}')
                value.update(chunk)
                output.write(chunk)
        if total != item['bytes'] or value.hexdigest() != item['sha256']:
            raise RuntimeError(f'Download size or SHA-256 mismatch: {item["asset"]}')
        if target.exists() and not is_expected_pointer(target, item):
            raise RuntimeError(f'Target changed during download: {item["path"]}')
        os.replace(temporary, target)
        return {'path': item['path'], 'status': 'downloaded_and_verified'}
    finally:
        temporary.unlink(missing_ok=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check-only', action='store_true', help='Verify local real files without downloading anything')
    args = parser.parse_args()
    results = [ensure_asset(item, args.check_only) for item in ASSETS]
    checksums = ''.join(f"{item['sha256']}  {item['path']}\n" for item in ASSETS)
    checksum_path = ROOT / 'SHA256SUMS.txt'
    if args.check_only:
        if checksum_path.read_text(encoding='utf-8') != checksums:
            raise RuntimeError('SHA256SUMS.txt does not match the recorded repository paths')
    else:
        checksum_path.write_text(checksums, encoding='utf-8')
    print(json.dumps({'status': 'passed', 'assets': results}, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
