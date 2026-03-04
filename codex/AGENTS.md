# Open Thesis Codex Instructions

## Project Scope

Open Thesis is optimized for Chinese master's/doctoral degree thesis writing.

### Global Preference

- `thesis_mode: true`
- Priority standards:
  1. GB/T 7713.1-2006
  2. GB/T 7714-2015
  3. University template details

## Output Requirements

- Prefer structured Markdown.
- For thesis drafting/formatting tasks, also provide LaTeX (`ctex`) snippets.
- Avoid AI-style promotional language and vague attribution.
- Prefer formal wording such as "研究发现" and "实证结果表明".

## Thesis Structure Baseline

封面（中/英）→ 原创性声明+授权 → 中文摘要+关键词 → 英文摘要+Keywords → 目录 → 正文 → 参考文献 → 附录 → 致谢 → 成果 → 作者简介（博士）

## Formatting Baseline

- A4
- 正文：宋体小四
- 章标题：黑体小二
- 英文：Times New Roman
- 固定行距：20 磅
- 首行缩进：2 字符

## Citation Baseline

- GB/T 7714-2015
- Numeric sequence `[1][2]...`
- Master >= 40 refs, Doctoral >= 100 refs
- Recent 5 years >= 1/3

## Zotero Workflow

- DOI import first
- If DOI is missing, prompt CNKI URL import
- Default collection: `中文学位论文`

## Existing Resources

- Skills: `skills/`
- Claude command prompts: `commands/`
- Source agent prompts: `agents/*.md`
- Rules: `rules/`

## Completion Summary

Report at task end:
1. changed files
2. compliance status (structure/citation)
3. remaining risks and next actions
