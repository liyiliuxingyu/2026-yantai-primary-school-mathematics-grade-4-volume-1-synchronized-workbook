#!/usr/bin/env python3
"""Restore the exact complete answer PDF from this repository's GitHub Release."""

from pathlib import Path
import hashlib
import json
import os
import sys
import tempfile
from urllib.error import URLError
from urllib.parse import urlparse
from urllib.request import Request, urlopen


ROOT = Path(__file__).resolve().parents[1]
ASSET_URL = (
    "https://github.com/liyiliuxingyu/"
    "2026-yantai-primary-school-mathematics-grade-4-volume-1-synchronized-workbook/"
    "releases/download/v2026.11.25/answers.pdf"
)
EXPECTED_BYTES = 143553201
EXPECTED_SHA256 = "894c4561d4cd07bac0cab90d360ef6104870cd3dac4924c74a4b0bcb9a0096c9"
CHUNK_BYTES = 1024 * 1024


def digest(path):
    value = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(CHUNK_BYTES), b""):
            value.update(chunk)
    return value.hexdigest()


def resolve_target(root):
    root = Path(root).resolve()
    state = json.loads((root / "接续状态.json").read_text(encoding="utf-8"))
    master = state["master_pdf"]
    relative = Path(master["path"])
    if relative.is_absolute() or ".." in relative.parts:
        raise ValueError("接续状态中的PDF路径必须是工程内的相对路径。")
    target = root / relative
    if not target.resolve().is_relative_to(root) or target.is_symlink():
        raise ValueError("PDF路径不在当前工程内，或目标是符号链接。")
    if master.get("sha256") != EXPECTED_SHA256:
        raise ValueError("接续状态已指向其他PDF版本；请使用与该版本一致的发布附件。")
    return target


def existing_is_correct(target):
    if target.exists():
        if (
            target.is_file()
            and not target.is_symlink()
            and target.stat().st_size == EXPECTED_BYTES
            and digest(target) == EXPECTED_SHA256
        ):
            return True
        raise FileExistsError("目标位置已有不同内容，已停止；不会覆盖你的现有答案。")
    return False


def ensure_answer(root=ROOT, opener=urlopen):
    target = resolve_target(root)
    if existing_is_correct(target):
        return "already_verified", target
    if urlparse(ASSET_URL).scheme != "https":
        raise ValueError("发布附件必须使用HTTPS地址。")

    target.parent.mkdir(parents=True, exist_ok=True)
    temporary = None
    try:
        with tempfile.NamedTemporaryFile(
            prefix=".answers-download-", suffix=".part", dir=target.parent, delete=False
        ) as output:
            temporary = Path(output.name)
            request = Request(ASSET_URL, headers={"User-Agent": "Yantai-Workbook-Restorer/1.0"})
            checksum = hashlib.sha256()
            received = 0
            with opener(request, timeout=60) as response:
                if urlparse(response.geturl()).scheme != "https":
                    raise ValueError("下载被重定向到非HTTPS地址，已停止。")
                for chunk in iter(lambda: response.read(CHUNK_BYTES), b""):
                    received += len(chunk)
                    if received > EXPECTED_BYTES:
                        raise ValueError("下载内容超过预期文件大小，已停止。")
                    checksum.update(chunk)
                    output.write(chunk)
            output.flush()
            os.fsync(output.fileno())

        if received != EXPECTED_BYTES or checksum.hexdigest() != EXPECTED_SHA256:
            raise ValueError("下载文件的大小或SHA-256不匹配；未安装下载内容。")

        # Install a verified file atomically without replacing any existing file.
        # The temporary file and destination share a directory/filesystem.
        try:
            os.link(temporary, target)
        except FileExistsError:
            if existing_is_correct(target):
                return "already_verified", target
            raise
        return "downloaded_and_verified", target
    finally:
        if temporary is not None:
            temporary.unlink(missing_ok=True)


def main():
    try:
        status, target = ensure_answer()
    except (OSError, ValueError, KeyError, URLError) as error:
        print("恢复完整答案失败：" + str(error), file=sys.stderr)
        print("请确认本仓库对应Release已发布且网络可用；原有答案不会被自动覆盖。", file=sys.stderr)
        return 1
    print("完整答案已核验：" + str(target.relative_to(ROOT)))
    print("状态：" + status)
    print("SHA-256：" + EXPECTED_SHA256)
    print("接下来运行：python3 工具/检查工程.py")
    return 0


if __name__ == "__main__":
    sys.exit(main())
