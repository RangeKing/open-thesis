# Open Thesis Configuration

## Project Overview

**Open Thesis** is a Claude Code/Codex/OpenCode configuration optimized for Chinese master's and doctoral degree thesis workflows.

**Mission**: Provide a full thesis lifecycle workflow: topic selection, literature review, chapter drafting, formatting compliance, defense rebuttal, and graduation-ready finalization.

---

## Global Preference (Highest Priority)

```yaml
thesis_mode: true
academic_standard_priority:
  - GB/T 7713.1-2006
  - GB/T 7714-2015
  - university_template
```

### Language

- Default response language: Chinese
- Keep technical terms in English when necessary

### Thesis Writing Baseline

- Degree scope: master's / doctoral thesis
- Required output style: structured Markdown + LaTeX(ctex)
- Avoid AI-style promotional language and vague attribution

---

## Mandatory Thesis Rules

### Structure Order

1. Chinese/English cover
2. Originality statement + authorization letter
3. Chinese abstract + keywords
4. English abstract + keywords
5. Table of contents
6. Main chapters (绪论/文献综述/研究方法/结果与分析/结论)
7. References (GB/T 7714-2015)
8. Appendix
9. Acknowledgements
10. Academic achievements during degree
11. Author profile (doctoral)

### Formatting Baseline

- Paper size: A4
- Body font: SimSun, 小四
- Chapter title: SimHei, 小二
- English font: Times New Roman
- Line spacing: fixed 20 pt
- Paragraph indent: 2 characters
- Numbering style: `第一章`, `2.1`, `2.1.1`

### Abstract Requirements

- Master Chinese abstract: 500-1000 characters
- Doctoral Chinese abstract: 1000-2000 characters
- Keywords: 3-8
- Chinese and English abstracts must be semantically aligned

### Reference Requirements

- Citation style: numeric sequence `[1] [2] ...`
- Master: at least 40 references
- Doctoral: at least 100 references
- Suggested Chinese/English balance: around 1:1
- References from last 5 years: at least one-third

---

## Originality Statement Template

Use this baseline template when user asks for originality statement draft:

```text
本人郑重声明：所呈交的学位论文是本人在导师指导下独立完成的研究成果。除文中已经注明引用的内容外，本论文不包含任何他人已经发表或撰写过的研究成果。对本研究做出重要贡献的个人和集体，均已在文中以明确方式标明。

本人完全了解并同意学校关于保存、使用学位论文的相关规定，同意学校以复制、缩印、数字化或其他方式保存和汇编本学位论文。
```

---

## Core Workflows

### 1. Thesis Research Init

Tools:
- `research-ideation`
- `chinese-degree-thesis-writing`
- `literature-reviewer`
- Zotero MCP

Commands:
- `/research-init`
- `/zotero-review`

### 2. Drafting and Compliance

Tools:
- `chinese-degree-thesis-writing`
- `paper-self-review`

Commands:
- `/generate-bilingual-abstract`
- `/thesis-format-check`
- `/paper-self-review`

### 3. Defense Preparation

Tools:
- `rebuttal-writer`
- `review-response`

Commands:
- `/defense-rebuttal`
- `/rebuttal`

---

## Skills Policy

### Default Thesis Skill

- Primary writing skill: `chinese-degree-thesis-writing`

### Backward Compatibility

- `ml-paper-writing` is preserved as compatibility layer.
- If user explicitly requests NeurIPS/ICML/ICLR/ACL/AAAI/COLM paper workflow, switch to legacy ML mode.

---

## Agents Policy

- `literature-reviewer`: must support “述评结合” output
- `paper-miner`: must extract innovation statements and defense evidence patterns
- `rebuttal-writer`: must classify feedback into Major/Minor/Formatting/Misunderstanding

---

## Rules (Always Active)

1. `rules/coding-style.md`
2. `rules/agents.md`
3. `rules/security.md`
4. `rules/experiment-reproducibility.md`
5. `rules/chinese-thesis-formatting.md`
6. `rules/gbt-7714-citation.md`
7. `rules/defense-rebuttal-strategy.md`

---

## Zotero/CNKI Policy

- Import priority: DOI first
- If DOI is unavailable, explicitly prompt CNKI URL import
- Use Zotero collection default name: `中文学位论文`
- Export citations and run GB/T 7714 compliance check before final output

---

## Anti-AI Writing Policy (Chinese Academic)

Avoid:
- promotional language
- symbolism
- vague attribution
- phrases like “本文认为/笔者认为”

Prefer:
- “研究发现”
- “实证结果表明”
- “数据分析显示”
- “比较结果支持”

---

## Completion Summary Requirement

After each major task, provide:

```text
1) Changed files
2) Compliance status (GB/T structure/citation)
3) Remaining risks and next actions
```
