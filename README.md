# Open Thesis

> 现已专为**中文硕士/博士学位论文**优化（兼容 Claude Code / Codex / OpenCode）。

`open-thesis` 在保留 `hooks/`、`skills/`、`commands/`、`agents/`、`rules/`、`CLAUDE.md` 原架构的前提下，将原 `claude-scholar` 的 ML 顶会论文流优雅迁移为中文学位论文流。

## 核心升级

- 默认模式切换为：`thesis_mode: true`
- 规范优先级：
  1. GB/T 7713.1-2006（学位论文编写规则）
  2. GB/T 7714-2015（参考文献著录规则）
  3. 学校模板细则
- 全流程覆盖：选题 → 文献综述 → 章节写作 → 格式检查 → 答辩回复
- 新增命令：
  - `/thesis-format-check`
  - `/generate-bilingual-abstract`
  - `/defense-rebuttal`
- Zotero 集成增强：默认集合 `中文学位论文`，并提示 DOI/CNKI 双导入路径
- ML 顶会写作能力保留：`skills/ml-paper-writing` 作为兼容入口

---

## 一键安装

在仓库根目录执行：

```bash
bash setup.sh
```

Windows（PowerShell）：

```powershell
./setup.ps1
```

Windows（一键双击）：

- 直接双击 `setup.bat`
- 会保留窗口并输出日志到 `setup-windows.log`

安装脚本会：

1. 复制 `skills/commands/agents/rules/hooks/CLAUDE*.md`
2. 合并 `settings.json.template` 中的 hooks / mcpServers / enabledPlugins
3. 检查可选论文工具链（`xelatex`、`biber`）
4. 给出 ctex 模板位置提示

---

## 目录结构（核心）

```text
open-thesis/
├── setup.sh
├── setup.ps1
├── setup.bat
├── CLAUDE.md
├── CLAUDE.zh-CN.md
├── settings.json.template
├── hooks/
├── skills/
│   ├── chinese-degree-thesis-writing/
│   ├── ml-paper-writing/               # 兼容层（legacy ML）
│   ├── research-ideation/
│   ├── results-analysis/
│   └── paper-self-review/
├── commands/
│   ├── research-init.md
│   ├── zotero-review.md
│   ├── rebuttal.md
│   ├── paper-self-review.md
│   ├── thesis-format-check.md
│   ├── generate-bilingual-abstract.md
│   └── defense-rebuttal.md
├── agents/
│   ├── literature-reviewer.md
│   ├── paper-miner.md
│   └── rebuttal-writer.md
└── rules/
    ├── chinese-thesis-formatting.md
    ├── gbt-7714-citation.md
    └── defense-rebuttal-strategy.md
```

---

## 中文学位论文工作流

### 1) 初始化研究与文献库

```bash
/research-init "基于XX理论的中文硕士论文选题" master focused
```

输出：
- `thesis-outline.md`
- `literature-review.md`
- `thesis-template.tex`
- `references.bib`
- `writing-plan.md`

### 2) 生成中英摘要

```bash
/generate-bilingual-abstract "./chapters/chapter1.md" master
```

输出：
- Markdown 版摘要
- LaTeX(ctex) 版摘要

### 3) 格式合规检查

```bash
/thesis-format-check "./thesis-template.tex" master
```

输出：
- `thesis-format-report.md`
- `thesis-format-fixes.md`

### 4) 答辩意见分类回复

```bash
/defense-rebuttal "./defense-comments.md" formal
```

输出：
- `defense-rebuttal.md`
- `defense-major-minor-matrix.md`
- `defense-evidence-map.md`

---

## 关键规范约束

### 结构顺序

封面（中/英）→ 声明+授权 → 中文摘要+关键词 → 英文摘要+Keywords → 目录 → 正文 → 参考文献 → 附录 → 致谢 → 成果 → 作者简介（博士）

### 摘要字数

- 硕士：500-1000
- 博士：1000-2000

### 排版

- A4
- 正文：宋体小四
- 章标题：黑体小二
- 英文：Times New Roman
- 固定行距 20 磅
- 首行缩进 2 字符

### 参考文献

- 顺序编码制 `[1][2]...`
- 硕士至少 40 篇，博士至少 100 篇
- 中外文建议各半，近 5 年文献建议 ≥ 1/3

---

## Prompt Engineering 约定

所有 thesis 专用 skill/agent 统一遵循：

- YAML frontmatter
- Progressive disclosure（按需加载参考文件）
- 强制双输出：Markdown + LaTeX(ctex)
- 防 AI 检测中文写作：
  - 避免 promotional language / symbolism / vague attribution
  - 避免“本文认为/笔者认为”
  - 使用“研究发现/实证结果表明/数据分析显示”

---

## 向后兼容（ML 顶会）

若你仍需旧流程，可显式指定：

- `ml-paper-writing`（兼容入口）
- 旧模板与资料仍保留在 `skills/ml-paper-writing/templates/` 与 `references/`

---

## 常见问题

### Q1: 为什么 Zotero 导入失败？

先检查 `settings.json` 中 `ZOTERO_API_KEY`、`ZOTERO_LIBRARY_ID`。

### Q2: 没有 DOI 怎么办？

使用 CNKI 链接导入（命令会自动提示）。

### Q3: 为什么 LaTeX 无法编译中文？

请安装 TeX Live 或 MacTeX，并确认 `xelatex` 可用。

---

## License

MIT
