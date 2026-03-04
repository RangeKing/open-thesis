---
name: generate-bilingual-abstract
description: 从论文正文或章节提炼中英文摘要与关键词（符合中文学位论文字数与表达规范）
args:
  - name: source
    description: 正文内容或文件路径
    required: true
  - name: degree
    description: 学位类型（master/phd）
    required: false
    default: master
tags: [Abstract, Thesis, Chinese English Bilingual]
---

# /generate-bilingual-abstract - 生成中英摘要

根据输入 "$source" 生成中文摘要、英文摘要及关键词。

## 生成规则

1. 采用五句式摘要结构：背景、目标、方法、结果、结论
2. 中文摘要字数：
- master: 500-1000
- phd: 1000-2000
3. 英文摘要与中文语义对齐，不做机械直译
4. 关键词 3-8 个，中英对应
5. 语体要求：避免“本文认为/笔者认为”，优先“研究发现/结果表明”

## 输出格式

1. Markdown 版本
```markdown
## 中文摘要
...

关键词：...；...；...

## Abstract
...

Keywords: ...; ...; ...
```

2. LaTeX(ctex) 版本
```latex
\chapter*{中文摘要}
...
\noindent\textbf{关键词：}...

\chapter*{Abstract}
...
\noindent\textbf{Keywords:} ...
```
