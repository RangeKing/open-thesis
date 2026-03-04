# ctex + xeCJK 学位论文模板（可直接改造）

## 使用说明

- 引擎：`xelatex`（推荐）
- 文献：`biblatex` + `biber` 或学校指定 `gbt7714` 样式
- 中文支持：`ctex` + `xeCJK`

## 版式参数（默认）

- A4，正文小四（12pt），固定行距 20pt
- 章标题小二黑体
- 中文正文宋体，英文 Times New Roman
- 首行缩进 2 字符

## 基础骨架

```latex
\documentclass[UTF8,12pt,a4paper,oneside]{ctexbook}

\usepackage{geometry}
\geometry{left=3cm,right=2.5cm,top=2.8cm,bottom=2.6cm}

\usepackage{setspace}
\setstretch{1.667} % 接近 20 磅固定行距

\usepackage{fontspec}
\usepackage{xeCJK}
\setmainfont{Times New Roman}
\setCJKmainfont{SimSun}
\setCJKsansfont{SimHei}

\ctexset{
  chapter={
    format=\heiti\zihao{-2}\centering,
    name={第,章},
    number=\chinese{chapter}
  },
  section={
    format=\heiti\zihao{4}
  },
  subsection={
    format=\heiti\zihao{-4}
  }
}

\usepackage{indentfirst}
\setlength{\parindent}{2em}
\setlength{\parskip}{0pt}

\usepackage[backend=biber,style=gb7714-2015]{biblatex}
\addbibresource{references.bib}

\begin{document}

% 封面（中/英）
\frontmatter
\chapter*{原创性声明}
这里填写原创性声明和授权书。

\chapter*{中文摘要}
关键词：关键词1；关键词2；关键词3

\chapter*{Abstract}
Keywords: keyword1; keyword2; keyword3

\tableofcontents

\mainmatter
\chapter{绪论}
\section{研究背景}

\chapter{文献综述}
\section{国内外研究现状}

\chapter{研究方法}

\chapter{结果与分析}

\chapter{结论与展望}

\backmatter
\printbibliography[title={参考文献}]

\appendix
\chapter{附录A}

\chapter*{致谢}
\chapter*{攻读学位期间取得的成果}

\end{document}
```

## 输出要求

- 生成章节草稿时，必须同时给出 Markdown + 上述 ctex 可嵌入片段。
- 若学校模板与默认参数冲突，优先学校模板，但保留 GB/T 7713.1-2006 核心约束。
