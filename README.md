# 2026烟台地区小学数学四年级上册同步练习册

**2026 Yantai Primary School Mathematics, Grade 4, Volume 1 — Synchronized Workbook**

本仓库保存当前答案、可编辑修订源码和 Lean 续作资料。数学内容基于 2026 年 11 月 17 日整理的答案第 37 版；GitHub 发布不会改变原工程文件的数学内容。

## 下载完整工程

| 下载 | 内容 |
| --- | --- |
| [完整续作工程 ZIP](https://github.com/liyiliuxingyu/2026-yantai-primary-school-mathematics-grade-4-volume-1-synchronized-workbook/releases/download/v2026.11.25/workbook-project.zip) | 原工程包，共 60 个文件，106,044,118 字节；解压即可获得完整目录 |
| [完整答案 PDF](https://github.com/liyiliuxingyu/2026-yantai-primary-school-mathematics-grade-4-volume-1-synchronized-workbook/releases/download/v2026.11.25/answers.pdf) | 213 页、203 条书签，143,553,201 字节 |
| [本次发布页](https://github.com/liyiliuxingyu/2026-yantai-primary-school-mathematics-grade-4-volume-1-synchronized-workbook/releases/tag/v2026.11.25) | 发布附件与说明 |

完整 PDF 和原工程 ZIP 均超过普通 Git 单文件限制，因此原文件放在同一仓库的 Release 中，源码、字体、Lean 与接续资料直接保存在仓库目录中。**GitHub 的“Code → Download ZIP”只包含仓库目录，完整工程请下载上表中的 `workbook-project.zip`。**

发布状态：完整答案 PDF 和原始续作工程 ZIP 已发布到 `v2026.11.25`，附件大小与 SHA-256 已核对一致。仓库内 62 个文件也已逐项核对路径、大小和内容。下载附件后可按下表核对 SHA-256；克隆仓库后，运行 `python3 工具/下载完整答案.py` 恢复完整答案。

### 文件校验值

| 文件 | SHA-256 |
| --- | --- |
| `workbook-project.zip` | `9eff049d389913f27e1230b05413bd25d192da08febeba78749a1cbe21ae80e8` |
| `answers.pdf` | `894c4561d4cd07bac0cab90d360ef6104870cd3dac4924c74a4b0bcb9a0096c9` |

## 当前内容与真实完成范围

| 目录或文件 | 内容 |
| --- | --- |
| `源码/` | 18 份现行 TeX、15 份完整计算与定位 JSON、4 个编译字体及许可、竖式修订脚本与编译入口 |
| `Lean/` | 原册第 1—4 页的合并 Lean 源码，107 个定理，仅依赖 `Std`；固定工具链 `leanprover/lean4:v4.36.0-rc1` |
| `核验/` | PDF 无损整理、源码取舍、编译入口与解压续作的既有核验记录 |
| `工具/检查工程.py` | 检查原工程文件大小与 SHA-256；可另外检查 PDF 页数及书签 |
| `工具/下载完整答案.py` | 从本仓库 Release 下载完整 PDF，校验后恢复到原目录；已有不同文件时拒绝覆盖 |
| `AGENTS.md`、`00_新对话接续说明.txt` | 新对话接手入口、书写规范、已确认更正和操作流程 |
| `接续状态.json`、`工程清单.json` | 真实完成范围、原册与物理 PDF 页码对应、原工程文件校验值 |

计算与解析数据包含 116 条计算链、599 行步骤，以及 1128 项短解析与单位记录。

**Lean 目前仅覆盖原册第 1—4 页，不是整册形式化验证。** 原代码依据早期答案第 4 版形成；2026 年 11 月 17 日整理时核对了代码完整性，但没有重新编译，也没有声称已按当前整册答案重新推导。继续 Lean 化应从原册第 5 页实际读题开始。

原书部分题干和底图仍是 PDF 中的扫描页。本仓库保留全部现行有效修订源码，完整答案 PDF 是后续局部修改的基底；这里并不是从一个主 TeX 文件即可重新生成全书的工程。旧动画课件不在本次现行答案与 Lean 续作包内。

## 克隆仓库后恢复完整答案

需要 Python 3.9 或更高版本。在仓库根目录执行：

```sh
python3 工具/下载完整答案.py
python3 工具/检查工程.py
```

下载工具只使用 Python 标准库。它会读取 `接续状态.json`，把完整 PDF 恢复到：

```text
答案/小学数学同步练习册四年级上册答案.pdf
```

已有正确 PDF 时直接核验成功；已有不同内容时会停止，避免覆盖你后续修改的答案。若 Release 尚未上传，下载会明确失败，不会把不完整文件当成完整答案。

如需读取、渲染或修改 PDF：

```sh
python3 -m pip install -r requirements.txt
python3 工具/检查工程.py --pdf
```

`requirements.txt` 固定 `PyMuPDF==1.26.6`。原工程清单只校验原工程文件；本次新增的 GitHub 说明和下载脚本不冒充此前已经核验的原文件。

## 编译 TikZ / TeX

安装含 XeLaTeX、fontspec、amsmath、array、geometry、xcolor 和 TikZ 的 TeX 发行版；ctex 等组件的具体使用见源码说明。中文字体已保存在 `源码/fonts/`，数学字体由 TeX 发行版提供。

```sh
python3 源码/编译源码.py 第123页第2题全部图形.tex --build-dir build/tikz
```

入口编译两遍，并将一般构建产物放入指定目录。优先使用系统 TeX 配置；若已安装 TeX 文件但缺搜索路径或 `xelatex.fmt`，入口可识别系统目录并生成本地格式缓存。详见 `源码/编译与续接说明.txt`。

## 检查 Lean

安装与 `Lean/lean-toolchain` 相符的 Lean 工具链后执行：

```sh
cd Lean
lean --version
lean "小学数学同步练习册四年级上册_第1至4页_Lean逐行注释答案.lean"
```

此单文件不需要 Mathlib 或其他本地模块。运行时与标准库未打包；工具链缺失不等于工程源码缺失。

## 继续修改

先读 `AGENTS.md`、`00_新对话接续说明.txt` 和 `接续状态.json`。以现行 PDF 的副本编辑指定题目，根据书签区分原册页码、配套检测页码和 PDF 物理页码。已有补丁均已应用，不重复插入附页或叠加历史修订。

脱式计算步骤完整，能简便必须简便；独立核对数学结论、单位、括号、图形与标注。修改后同步对应源码、状态与校验清单，并如实记录实际检查的范围和未完成事项。

字体的许可与修改说明保留在 `源码/fonts/`。第三方原书内容和字体的权利分别归其权利人所有；本仓库不对它们另行授予统一开源许可。
