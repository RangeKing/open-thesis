---
name: ml-paper-writing
description: 兼容入口技能。默认将学术写作任务路由到 chinese-degree-thesis-writing（中文学位论文模式）；当用户明确要求 NeurIPS/ICML/ICLR/ACL/AAAI/COLM 等顶会论文时，切换到 legacy ML 论文流程。
version: 2.0.0
author: Open Thesis Team
license: MIT
tags: [Compatibility, Legacy ML, Chinese Thesis]
---

# ml-paper-writing (Compatibility Layer)

该技能已进入兼容模式，用于保持旧命令和旧触发词可用。

## Routing Policy

- 若用户需求包含以下关键词：`学位论文`、`硕士`、`博士`、`中文摘要`、`答辩`、`GB/T 7714`，
  - 立即切换到 `chinese-degree-thesis-writing`。
- 若用户明确指定：`NeurIPS`、`ICML`、`ICLR`、`ACL`、`AAAI`、`COLM`、`camera-ready`，
  - 启用 ML 顶会写作 legacy 流程。

## Legacy Preservation

- 原始 ML 技能完整内容保存在：`SKILL.legacy.md`
- 旧模板仍可用：`templates/`
- 旧参考资料仍可用：`references/`

## Output Requirements

无论处于哪种分支，都应输出结构化 Markdown。

- 学位论文分支：必须额外输出 LaTeX(ctex) 版本。
- ML 顶会分支：使用 legacy 会议模板输出。
