"""Apply audited vertical arithmetic patches to an open PyMuPDF document."""
from pathlib import Path
import json, fitz

ROOT=Path(__file__).resolve().parent

def apply_vertical_fixes(doc, kind='main', metadata_path=None, patch_path=None):
    assert kind in ('main','packet')
    data=json.loads(Path(metadata_path or ROOT/'vertical_fixes.json').read_text())
    patch=fitz.open(patch_path or ROOT/data['patch_pdf'])
    field='pdf_page' if kind=='main' else 'packet_page'
    touched=[]
    for pno in sorted({g[field] for g in data['groups']}):
        page=doc[pno-1];groups=[g for g in data['groups'] if g[field]==pno]
        for g in groups:page.add_redact_annot(fitz.Rect(g['clear_rect']),fill=False,cross_out=False)
        page.apply_redactions(images=0,graphics=0,text=0)
        for g in groups:
            rect=fitz.Rect(g['paint_rect'])
            page.show_pdf_page(rect,patch,g['patch_page']-1,clip=rect,keep_proportion=True,overlay=True)
        touched.append(pno)
    patch.close()
    return touched

if __name__=='__main__':
    import argparse
    ap=argparse.ArgumentParser();ap.add_argument('source');ap.add_argument('output');ap.add_argument('--kind',choices=['main','packet'],default='main')
    a=ap.parse_args();d=fitz.open(a.source);pages=apply_vertical_fixes(d,a.kind)
    d.save(a.output,garbage=2,deflate=True,use_objstms=1)
    print(json.dumps({'output':a.output,'modified_pages':pages},ensure_ascii=False))
