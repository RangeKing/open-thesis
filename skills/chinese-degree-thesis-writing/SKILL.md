---
name: chinese-degree-thesis-writing
description: 用于中文硕士/博士学位论文全流程写作、格式核验、双语摘要生成与答辩回复。严格遵循 GB/T 7713.1-2006 与 GB/T 7714-2015，默认输出结构化 Markdown + LaTeX(ctex) 双版本。
version: 2.0.0
author: Open Thesis Team
license: MIT
tags: [Chinese Thesis, Master Thesis, Doctoral Dissertation, GB/T 7713.1-2006, GB/T 7714-2015, ctex, xeCJK, Zotero, CNKI]
---

# Chinese Degree Thesis Writing

面向中文硕士/博士学位毕业论文的专用写作技能，覆盖从选题到答辩的完整流程。

## Global Preference

- `thesis_mode: true`
- 规范优先级（从高到低）：
  1. GB/T 7713.1-2006《学位论文编写规则》
  2. GB/T 7714-2015《信息与文献 参考文献著录规则》
  3. 学校细则（默认按全国高校通行要求）

## Trigger Rules

以下场景必须启用本技能：
- 中文硕士/博士学位论文写作
- 论文目录/章节结构搭建
- 中英双语摘要生成
- 参考文献国标核验
- 答辩意见分类与回复

## Mandatory Output Contract

每次输出必须同时提供两版：
1. 结构化 Markdown 版
2. LaTeX（`ctex + xeCJK`）版

并满足以下要求：
- 先给可直接复制的正文结果，再给简要说明
- 明确章节层级（如“第一章”“2.1”）
- 文献引用默认顺序编码制（`[1] [2] ...`）
- 若信息不足，先给占位符并标注待补信息

## Thesis Structure Baseline

默认结构顺序：
1. 封面（中/英）
2. 原创性声明 + 授权书
3. 中文摘要（硕士 500-1000 字；博士 1000-2000 字）+ 关键词（3-8）
4. 英文摘要 + Keywords
5. 目录
6. 正文（第一章绪论/引言 → 文献综述 → 研究方法 → 结果与分析 → 结论）
7. 参考文献（GB/T 7714-2015，顺序编码制）
   - 硕士不少于 40 篇，博士不少于 100 篇
   - 中外文比例建议各半
   - 近 5 年文献不少于 1/3
8. 附录
9. 致谢
10. 攻读期间成果
11. 作者简介（博士）

## Formatting Baseline

- 纸型：A4
- 正文：宋体小四
- 章标题：黑体小二
- 英文：Times New Roman
- 固定行距：20 磅
- 首行缩进：2 字符

## Anti-AI Chinese Writing Rules

必须避免：
- 宣传化语句（promotional language）
- 口号化或象征化表达（symbolism）
- 模糊归因（vague attribution）
- 模板句（如“本文认为”“笔者认为”）

优先替换为：
- “研究发现”
- “实证结果表明”
- “数据分析显示”
- “比较结果支持”

## Zotero Workflow Constraints

- 默认先尝试 DOI 导入
- DOI 缺失时，明确提示可用 CNKI 链接导入
- 输出引用前执行 GB/T 7714-2015 核查（作者、题名、类型标识、出版项）

## Progressive Disclosure

按需加载以下文件，不要一次性展开全部内容：
- `template-latex-ctex.md`：ctex 论文模板与排版参数
- `5-sentence-chinese-abstract.md`：中英摘要五句式模板
- `structure-checklist.md`：结构/字数/文献配额核验清单
- `anti-ai-chinese-writing.md`：学术中文改写规则
- `references/knowledge/README.md`：扩展知识入口

## Compatibility

- 默认模式：`chinese-degree-thesis-writing`
- 若用户明确要求 NeurIPS/ICML/ICLR/ACL 等顶会论文流程，再切换 `ml-paper-writing`
