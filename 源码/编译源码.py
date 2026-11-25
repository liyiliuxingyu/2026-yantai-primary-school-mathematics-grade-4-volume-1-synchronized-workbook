#!/usr/bin/env python3
"""Compile selected current TeX sources twice using relative bundled fonts."""
from pathlib import Path
import argparse
import os
import shutil
import subprocess

ROOT = Path(__file__).resolve().parent
VERTICAL = Path("小数竖式对齐修订/小数竖式小数点对齐修订.tex")


def tex_lookup(name, env):
    result = subprocess.run(["kpsewhich", name], env=env, capture_output=True, text=True)
    return result.stdout.strip() if result.returncode == 0 else ""


def prepare_tex_environment(build_dir):
    """Prefer the native TeX setup; repair only missing container search paths."""
    if not shutil.which("xelatex") or not shutil.which("kpsewhich"):
        raise RuntimeError("Install XeLaTeX and kpsewhich from a TeX distribution first.")
    env = os.environ.copy()
    needs_paths = not all(tex_lookup(name, env) for name in ("article.cls", "xelatex.ini"))
    if needs_paths:
        roots = [Path(p) for p in ("/etc/texmf", "/usr/share/texmf", "/usr/share/texlive/texmf-dist")]
        roots = [p for p in roots if p.is_dir()]
        if not roots:
            raise RuntimeError("TeX files are unavailable; install the standard LaTeX packages.")
        fallback = "{" + ",".join(str(p) for p in roots) + "}"
        previous = env.get("TEXMF", "")
        env["TEXMF"] = previous + ":" + fallback if previous else fallback
        inputs = [str(p / "tex") + "//" for p in roots if (p / "tex").is_dir()]
        env["TEXINPUTS"] = ".:" + ":".join(inputs) + ":" + env.get("TEXINPUTS", "")
        if not all(tex_lookup(name, env) for name in ("article.cls", "xelatex.ini")):
            raise RuntimeError("The detected TeX installation lacks article.cls or xelatex.ini.")
        print("Using detected system TeX trees.", flush=True)
    if not tex_lookup("xelatex.fmt", env):
        cache = build_dir / "cache"
        cache.mkdir(parents=True, exist_ok=True)
        format_file = cache / "xelatex.fmt"
        previous = env.get("TEXFORMATS", "")
        env["TEXFORMATS"] = str(cache) + ":" + previous
        if not format_file.is_file():
            print("Building XeLaTeX format in the local build cache.", flush=True)
            command = ["xelatex", "-ini", "-etex", "-interaction=nonstopmode", "-halt-on-error", "-jobname=xelatex", "xelatex.ini"]
            with (cache / "format-build.log").open("w", encoding="utf-8") as log:
                subprocess.run(command, cwd=cache, env=env, stdout=log, stderr=subprocess.STDOUT, check=True)
        if not format_file.is_file() or not tex_lookup("xelatex.fmt", env):
            raise RuntimeError("XeLaTeX format generation did not produce a usable xelatex.fmt.")
    return env


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("sources", nargs="*", help="TeX paths relative to this directory")
    parser.add_argument("--all", action="store_true", help="Compile every source; the full notes file is large")
    parser.add_argument("--build-dir", type=Path, default=ROOT / "build", help="Output and cache directory; may be outside the source tree")
    args = parser.parse_args()
    selected = sorted(p.relative_to(ROOT) for p in ROOT.rglob("*.tex")) if args.all else [Path(p) for p in args.sources]
    if not selected:
        parser.error("Give at least one TeX source or --all")
    build_dir = args.build_dir.resolve()
    build_dir.mkdir(parents=True, exist_ok=True)
    env = prepare_tex_environment(build_dir)
    for relative in selected:
        source = (ROOT / relative).resolve()
        if not source.is_relative_to(ROOT) or source.suffix != ".tex" or not source.is_file():
            parser.error(f"Invalid TeX source: {relative}")
        relative = source.relative_to(ROOT)
        target = build_dir
        command = ["xelatex", "-interaction=nonstopmode", "-halt-on-error"]
        if relative == VERTICAL:
            target = source.parent
            command += ["-jobname=vertical_patches"]
        target.mkdir(exist_ok=True)
        command += ["-output-directory", str(target), str(relative)]
        for _ in range(2):
            subprocess.run(command, cwd=ROOT, env=env, check=True)
        stem = "vertical_patches" if relative == VERTICAL else source.stem
        print(target / (stem + ".pdf"))

if __name__ == "__main__":
    main()
