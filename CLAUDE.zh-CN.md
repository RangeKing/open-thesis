# Open Thesis 配置

## 项目定位

**Open Thesis** 是面向中文硕士/博士学位论文的 Claude Code / Codex / OpenCode 配置体系。

**目标**：覆盖学位论文全流程：选题、综述、写作、格式审查、答辩回复、定稿交付。

---

## 全局最高优先级配置

```yaml
thesis_mode: true
academic_standard_priority:
  - GB/T 7713.1-2006
  - GB/T 7714-2015
  - 学校模板细则
```

### 语言

- 默认使用中文回答
- 必要时保留英文术语（如 DOI、LaTeX、Zotero）

### 输出强约束

- 所有核心写作任务必须同时输出：
  1. 结构化 Markdown
  2. LaTeX（ctex）

---

## 学位论文硬约束

### 结构顺序

1. 封面（中/英）
2. 原创性声明 + 使用授权书
3. 中文摘要 + 关键词
4. 英文摘要 + Keywords
5. 目录
6. 正文（绪论/文献综述/研究方法/结果与分析/结论）
7. 参考文献
8. 附录
9. 致谢
10. 攻读期间成果
11. 作者简介（博士）

### 排版规范

- A4
- 正文：宋体小四
- 章标题：黑体小二
- 英文：Times New Roman
- 固定行距：20 磅
- 首行缩进：2 字符
- 编号：`第一章`、`2.1`、`2.1.1`

### 摘要规范

- 硕士中文摘要：500-1000 字
- 博士中文摘要：1000-2000 字
- 关键词：3-8 个
- 中英文摘要语义一致

### 参考文献规范

- GB/T 7714-2015 顺序编码制 `[1][2]...`
- 硕士不少于 40 篇
- 博士不少于 100 篇
- 中外文建议各半
- 近 5 年文献建议不少于 1/3

---

## 原创性声明模板（默认）

```text
本人郑重声明：所呈交的学位论文是本人在导师指导下独立完成的研究成果。除文中已经注明引用的内容外，本论文不包含任何他人已经发表或撰写过的研究成果。对本研究做出重要贡献的个人和集体，均已在文中以明确方式标明。

本人完全了解并同意学校关于保存、使用学位论文的相关规定，同意学校以复制、缩印、数字化或其他方式保存和汇编本学位论文。
```

---

## 核心工作流

### 1. 论文初始化

工具：`research-ideation` + `chinese-degree-thesis-writing` + `literature-reviewer` + Zotero MCP

命令：
- `/research-init`
- `/zotero-review`

### 2. 写作与格式核验

工具：`chinese-degree-thesis-writing` + `paper-self-review`

命令：
- `/generate-bilingual-abstract`
- `/thesis-format-check`
- `/paper-self-review`

### 3. 答辩准备

工具：`rebuttal-writer` + `review-response`

命令：
- `/defense-rebuttal`
- `/rebuttal`

---

## 技能兼容策略

- 默认写作技能：`chinese-degree-thesis-writing`
- `ml-paper-writing` 保留为兼容入口
- 仅当用户明确要求 NeurIPS/ICML/ICLR/ACL/AAAI/COLM 时，切换到 legacy ML 写作模式

---

## Agent 要求

- `literature-reviewer`：输出必须体现“述评结合”
- `paper-miner`：必须提取创新点表达模板与答辩证据组织方式
- `rebuttal-writer`：必须进行 Major/Minor/Formatting/Misunderstanding 分类

---

## 全局规则（始终启用）

1. `rules/coding-style.md`
2. `rules/agents.md`
3. `rules/security.md`
4. `rules/experiment-reproducibility.md`
5. `rules/chinese-thesis-formatting.md`
6. `rules/gbt-7714-citation.md`
7. `rules/defense-rebuttal-strategy.md`

---

## Zotero + CNKI 导入策略

- 文献导入优先 DOI
- 无 DOI 时，明确提示使用 CNKI 链接导入
- 默认集合名称：`中文学位论文`
- 引用导出后必须执行 GB/T 7714 格式核验

---

## 防 AI 检测中文写作规则

避免：
- 宣传化语言
- 象征化修辞
- 模糊归因
- “本文认为”“笔者认为”

推荐：
- “研究发现”
- “实证结果表明”
- “数据分析显示”
- “比较结果支持”

---

## 任务结束汇报要求

每次重要任务完成后，必须汇报：

```text
1）变更文件
2）规范符合性（结构/引用）
3）剩余风险与下一步
```
