#!/usr/bin/env python3
"""Verify the portable project payload; report runtime availability separately."""
from pathlib import Path
import argparse
import hashlib
import json
import shutil
import sys

ROOT = Path(__file__).resolve().parents[1]


def digest(path):
    value = hashlib.sha256()
    with path.open('rb') as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b''):
            value.update(chunk)
    return value.hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--pdf', action='store_true', help='Also inspect page count and bookmarks with PyMuPDF')
    args = parser.parse_args()
    manifest = json.loads((ROOT / '工程清单.json').read_text(encoding='utf-8'))
    errors = []
    for item in manifest['files']:
        path = (ROOT / item['path']).resolve()
        if not path.is_relative_to(ROOT):
            errors.append({'path': item['path'], 'error': 'invalid relative path'})
        elif not path.is_file():
            errors.append({'path': item['path'], 'error': 'missing'})
        elif path.stat().st_size != item['bytes'] or digest(path) != item['sha256']:
            errors.append({'path': item['path'], 'error': 'content changed'})
    state = json.loads((ROOT / '接续状态.json').read_text(encoding='utf-8'))
    result = {'files_checked': len(manifest['files']), 'files_complete': not errors,
              'errors': errors, 'runtime': {name: shutil.which(name) for name in ['xelatex', 'kpsewhich', 'lean', 'elan']},
              'note': 'Runtime availability is separate from project-file integrity.'}
    if args.pdf:
        try:
            import fitz
        except ImportError:
            result['pdf_check'] = 'PyMuPDF is missing; install requirements.txt.'
            print(json.dumps(result, ensure_ascii=False, indent=2))
            return 2
        with fitz.open(ROOT / state['master_pdf']['path']) as document:
            result['pdf'] = {'pages': len(document), 'bookmarks': len(document.get_toc())}
            if len(document) != state['master_pdf']['pages'] or len(document.get_toc()) != state['master_pdf']['bookmarks']:
                errors.append({'error': 'PDF page count or bookmarks changed'})
        result['files_complete'] = not errors
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 1 if errors else 0


if __name__ == '__main__':
    sys.exit(main())
