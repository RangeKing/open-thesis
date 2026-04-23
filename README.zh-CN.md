<div align="center">
  <img src="LOGO.png" alt="Claude Scholar Logo" width="100%"/>

  <p>
    <a href="https://github.com/Galaxy-Dawn/claude-scholar/stargazers"><img src="https://img.shields.io/github/stars/Galaxy-Dawn/claude-scholar?style=flat-square&color=yellow" alt="Stars"/></a>
    <a href="https://github.com/Galaxy-Dawn/claude-scholar/network/members"><img src="https://img.shields.io/github/forks/Galaxy-Dawn/claude-scholar?style=flat-square" alt="Forks"/></a>
    <img src="https://img.shields.io/github/last-commit/Galaxy-Dawn/claude-scholar?style=flat-square" alt="Last Commit"/>
    <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="License"/>
    <img src="https://img.shields.io/badge/Claude_Code-Compatible-blueviolet?style=flat-square" alt="Claude Code"/>
    <img src="https://img.shields.io/badge/Codex_CLI-Compatible-blue?style=flat-square" alt="Codex CLI"/>
    <img src="https://img.shields.io/badge/OpenCode-Compatible-orange?style=flat-square" alt="OpenCode"/>
  </p>


  <strong>语言</strong>: <a href="README.md">English</a> | <a href="README.zh-CN.md">中文</a> | <a href="README.ja-JP.md">日本語</a>

</div>

> 面向学术研究和软件开发的半自动研究助手，尤其适合计算机科学与 AI 研究者。支持 [Claude Code](https://github.com/anthropics/claude-code)、[Codex CLI](https://github.com/openai/codex) 和 [OpenCode](https://github.com/opencode-ai/opencode)，覆盖文献管理、编码、实验分析、结果报告、写作与项目知识库维护。

  <p><em>分支说明</em>：<code>main</code> 分支对应 Claude Code 工作流。如果你使用 Codex CLI，请查看 <a href="https://github.com/Galaxy-Dawn/claude-scholar/tree/codex"><code>codex</code> 分支</a>；如果你使用 OpenCode，请查看 <a href="https://github.com/Galaxy-Dawn/claude-scholar/tree/opencode"><code>opencode</code> 分支</a>。</p>

> **默认 agent 说明**：为了降低上下文开销，Claude Scholar 现在只保留一组精简的默认 agent。当前保留的是 `literature-reviewer`、`paper-miner`、`rebuttal-writer`、`code-reviewer`、`kaggle-miner` 和 `tdd-guide`。其他大多数工作应优先走 skills 和 commands，而不是依赖额外默认 agent。
## 最新动态

- **2026-04-22**: **精简常驻核心指令** — 将大型 always-on `CLAUDE.md` / `AGENTS.md` 改为紧凑的核心指令，新增中文 companion 文件，并把详细 skills、commands、agents 与 workflow 内容保留为按需参考，以降低默认 context 开销。
- **2026-04-15**: **提出 pubfig 与 pubtab 两个 Python package** — 推出了 [`pubfig`](https://github.com/Galaxy-Dawn/pubfig)（用于论文级 scientific figures）和 [`pubtab`](https://github.com/Galaxy-Dawn/pubtab)（用于 publication-ready tables 与 Excel↔LaTeX workflows）两个独立 Python package，为研究者提供更清晰的论文图、benchmark 表、导出控制与最终 QA 生产路径。
- **2026-04-15**: **将 publication-chart-skill 融入 Claude Scholar** — 把 [`pubfig`](https://github.com/Galaxy-Dawn/pubfig) + [`pubtab`](https://github.com/Galaxy-Dawn/pubtab) 封装成 `publication-chart-skill`，加入仓库，并接到 Claude Scholar 的分析/写作边界里，让论文级图表工作有了明确的 handoff 路径，而不是继续混在通用分析或 prose skill 里。

## 快速导航

| 部分 | 作用 |
|---|---|
| [为什么使用 Claude Scholar](#为什么使用-claude-scholar) | 快速理解项目定位和适用场景。 |
| [核心工作流](#核心工作流) | 查看从研究构思到发表的主链路。 |
| [快速开始](#快速开始) | 选择完整、最小或选择性安装方式。 |
| [上手场景](#上手场景) | 查看安装完成后几种最常见的上手场景。 |
| [集成能力](#集成能力) | 了解 Zotero 和 Obsidian 如何接入工作流。 |
| [主要工作流](#主要工作流) | 查看核心研究与开发工作流。 |
| [支撑工作流](#支撑工作流) | 查看支撑主工作流的后台机制。 |
| [文档入口](#文档入口) | 快速跳转到 setup、配置和模板文档。 |
| [引用](#引用) | 在论文、报告或项目文档中引用 Claude Scholar。 |

## 当前保留的默认 Agent

Claude Scholar 现在只保留这一组默认 agent。下面这张表就是当前分支的完整默认集合。

| 类型 | 名称 | 保留用途 |
|---|---|---|
| Agent | `literature-reviewer` | 搜索、分类并综合论文，形成可执行的文献图景。 |
| Agent | `paper-miner` | 从高质量论文中提炼可复用的写作模式、结构信号和投稿经验。 |
| Agent | `rebuttal-writer` | 起草专业、礼貌且结构清晰的 rebuttal 文本。 |
| Agent | `code-reviewer` | 审查改动代码的正确性、可维护性和实现质量。 |
| Agent | `kaggle-miner` | 从优秀 Kaggle 工作流中提炼工程实践和解决方案模式。 |
| Agent | `tdd-guide` | 当任务明确需要 TDD 路径时，提供聚焦的测试驱动实现指导。 |

其他大多数任务请优先走 skills 和 commands，不要默认还有更多内置 agent。


## 为什么使用 Claude Scholar

Claude Scholar **不是**那种试图替代研究者、追求端到端全自动化科研的系统。

它的核心思想很简单：

> **以人的决策为中心，让助手去加速科研流程，而不是替人做最终判断。**

这意味着 Claude Scholar 更适合承担科研中那些高重复、重结构、但仍需要人来把关的环节，例如文献整理、知识沉淀、实验分析、结果汇报和写作辅助；而真正关键的判断始终应该由研究者自己做出：

- 这个问题值不值得做，
- 哪些文献真正重要，
- 哪些假设值得继续验证，
- 哪些结果足够可信，
- 以及什么应该继续推进、写成论文、投稿，或者及时放弃。

换句话说，Claude Scholar 是一个**以人类决策为中心的半自动研究助手**，而不是一个“全自动科研代理”。

## 更适合谁

Claude Scholar 当前尤其适合：

- **计算机科学研究者**：需要在文献、代码、实验和论文写作之间频繁切换；
- **AI / ML researcher**：希望用一套工作流串起构思、实现、分析、报告和 rebuttal；
- **research engineer 与研究生**：希望引入更强的流程结构，但不放弃人的判断；
- **偏软件与计算驱动的学术项目**：能够直接受益于 Zotero、Obsidian、CLI 自动化和可追踪的 project memory。

它当然也可以帮助其他研究场景，但当前这套工作流的设计重心，最贴近计算机科学、AI 以及相邻的 computational research。

## 核心工作流

- **研究构思**：把模糊主题收敛成具体研究问题、研究空白和初步计划。
- **文献工作流**：通过 Zotero 文献集合检索、导入、组织并阅读论文。
- **论文笔记**：把论文转成结构化阅读笔记和可复用论点。
- **知识库沉淀**：将稳定知识写入 Obsidian，并按 `Papers / Knowledge / Experiments / Results / Writing` 路由整理，具体轮次的实验报告存放在 `Results/Reports/` 下。
- **实验推进**：跟踪假设、实验线、运行历史、关键发现和下一步动作。
- **严格分析**：使用 `results-analysis` 生成严谨统计、真实科研图和分析产物。
- **结果报告**：使用 `results-report` 生成完整实验复盘报告，并写回 Obsidian。
- **写作与发表**：把稳定结论延伸到综述、论文、rebuttal、演示文稿、海报和传播材料中。

## 快速开始

### 系统要求

- [Claude Code](https://github.com/anthropics/claude-code)
- Git
- （可选）Python + [uv](https://docs.astral.sh/uv/) 用于 Python 开发
- （可选）[Zotero](https://www.zotero.org/) + [Galaxy-Dawn/zotero-mcp](https://github.com/Galaxy-Dawn/zotero-mcp) 用于文献工作流
- （可选）[Obsidian](https://obsidian.md/) 用于项目知识库工作流

### 选项 1：完整安装（推荐）

```bash
git clone https://github.com/Galaxy-Dawn/claude-scholar.git /tmp/claude-scholar
bash /tmp/claude-scholar/scripts/setup.sh
```

**Windows**：请使用 Git Bash / WSL 运行安装脚本。

安装器现在支持**带备份的安全增量更新**：
- 更新仓库托管的 `skills/commands/agents/rules/hooks/scripts/CLAUDE*.md`
- 将被覆盖的文件备份到 `~/.claude/.claude-scholar-backups/<timestamp>/`
- 同时把 `settings.json` 备份为 `settings.json.bak`
- 如果已存在 `~/.claude/CLAUDE.md`，则保留原文件，并把仓库版本另存为 `~/.claude/CLAUDE.scholar.md`
- 如果已存在 `~/.claude/CLAUDE.zh-CN.md`，则保留原文件，并把仓库版本另存为 `~/.claude/CLAUDE.zh-CN.scholar.md`
- 保留已有的 `env`、模型/provider 配置、API key、permissions，以及当前 `mcpServers` 的现有取值
- 对 hooks 采用追加缺失项的方式，而不是整体替换

**重要 CLAUDE 说明**：如果你原来就有自己的 `~/.claude/CLAUDE.md` 或 `~/.claude/CLAUDE.zh-CN.md`，安装后请查看 `~/.claude/CLAUDE.scholar.md` 和 `~/.claude/CLAUDE.zh-CN.scholar.md`，并将其中你需要的 Claude Scholar 内容按需 merge 到你自己的文件里；不要假设这些 sidecar 文件会自动生效。

以后做增量更新时：

```bash
cd /tmp/claude-scholar
git pull --ff-only
bash scripts/setup.sh
```

### 选项 2：最小化安装

只安装一组较小的研究工作流子集：

```bash
git clone https://github.com/Galaxy-Dawn/claude-scholar.git /tmp/claude-scholar
mkdir -p ~/.claude/hooks ~/.claude/skills
cp /tmp/claude-scholar/hooks/*.js ~/.claude/hooks/
cp -r /tmp/claude-scholar/skills/ml-paper-writing ~/.claude/skills/
cp -r /tmp/claude-scholar/skills/research-ideation ~/.claude/skills/
cp -r /tmp/claude-scholar/skills/results-analysis ~/.claude/skills/
cp -r /tmp/claude-scholar/skills/results-report ~/.claude/skills/
cp -r /tmp/claude-scholar/skills/review-response ~/.claude/skills/
cp -r /tmp/claude-scholar/skills/writing-anti-ai ~/.claude/skills/
cp -r /tmp/claude-scholar/skills/git-workflow ~/.claude/skills/
cp -r /tmp/claude-scholar/skills/bug-detective ~/.claude/skills/
```

**安装后**：最小化/手动安装**不会自动合并** `settings.json`；请按需从 `settings.json.template` 复制你需要的 hooks 或 MCP 条目。如果你已经有自己的 `~/.claude/CLAUDE.md` 或 `~/.claude/CLAUDE.zh-CN.md`，也请把仓库提供的相关内容按需 merge 到你的文件里，而不是直接覆盖。

### 选项 3：选择性安装

只复制你需要的部分：

```bash
git clone https://github.com/Galaxy-Dawn/claude-scholar.git /tmp/claude-scholar
cd /tmp/claude-scholar

cp hooks/*.js ~/.claude/hooks/
cp -r skills/latex-conference-template-organizer ~/.claude/skills/
cp -r skills/architecture-design ~/.claude/skills/
cp agents/paper-miner.md ~/.claude/agents/
cp rules/coding-style.md ~/.claude/rules/
cp rules/agents.md ~/.claude/rules/
```

**安装后**：选择性/手动安装**不会自动合并** `settings.json`；请按需从 `settings.json.template` 复制你需要的 hooks 或 MCP 条目。如果你已经有自己的 `~/.claude/CLAUDE.md` 或 `~/.claude/CLAUDE.zh-CN.md`，也请把仓库提供的相关内容按需 merge 到你的文件里，而不是直接覆盖。

### 选项 4：插件市场安装

**第一步：安装插件**

```bash
/plugin marketplace add Galaxy-Dawn/claude-scholar
/plugin install claude-scholar@claude-scholar
```

自动加载所有 skills、commands、agents 和 hooks。安装时可选择作用范围：user（所有项目）或 project（单个项目）。

**第二步：安装 Rules（必须）**

Claude Code 插件无法自动分发 rules，需要手动安装：

```bash
git clone https://github.com/Galaxy-Dawn/claude-scholar.git /tmp/claude-scholar

# 用户级（所有项目生效）
mkdir -p ~/.claude/rules
cp /tmp/claude-scholar/rules/*.md ~/.claude/rules/

# 或项目级（仅当前项目生效）
mkdir -p .claude/rules
cp /tmp/claude-scholar/rules/*.md .claude/rules/
```

**安装后**：插件安装**不会**自动加载 `CLAUDE.md` 或配置 `settings.json`；如果你已经有自己的 `~/.claude/CLAUDE.md` 或 `~/.claude/CLAUDE.zh-CN.md`，也请把仓库提供的相关内容按需 merge 到你的文件里，而不是假设插件会自动应用。如需 Zotero MCP 或其他集成，请参阅[集成能力](#集成能力)部分手动设置。

## 上手场景

安装完成后，最简单的上手方式就是直接用自然语言描述你的任务，不需要先把整套系统全部背下来。下面给几种最常见、也最实用的起步场景。

### 1. 启动一个新的研究主题
**你可以这样说：**
> 帮我围绕[你的研究主题]启动研究。我想先得到一个基于文献的初步计划、关键开放问题，以及接下来最具体的推进步骤。

**Claude Scholar 通常会帮助你：**
- 澄清主题并收敛研究问题，
- 给出值得优先看的文献方向，
- 形成初始研究计划或假设列表，
- 如果你在用 Zotero / Obsidian，还可以把工作进一步路由进去。

### 2. 回顾一个 Zotero 文献集合
**你可以这样说：**
> 帮我回顾我在 Zotero 里关于 brain foundation models 的文献集合，并总结其中的主要方向、研究空白，以及最值得继续推进的下一步。

**典型输出包括：**
- 按主题分组的论文图景，
- 一段简明文献综合，
- research gap 分析，
- 值得继续推进的候选研究方向。

### 3. 分析已经完成的实验结果
**你可以这样说：**
> 帮我分析这个实验目录里的结果，看看不同 runs 之间到底变了什么，并输出一份面向决策的总结。

**典型输出包括：**
- 指标对比，
- ablation 或 error analysis 建议，
- 一份结果总结，说明哪些结论比较稳、哪些还不够稳、下一步该跑什么。

### 4. 起草论文段落或 rebuttal 回复
**你可以这样说：**
> 请基于这个项目当前已有的发现和论文笔记，帮我起草相关工作这一节。

或者：

> 请根据这些审稿人意见，帮我起草一版 rebuttal。

**典型输出包括：**
- 结构化的段落草稿，
- 更清楚的论证链条，
- claims 与 evidence 的对应关系，
- 还需要补验证或补材料的点。

### 使用建议
- 先从一个具体任务开始，而不是一上来让系统”把所有事情都做了”。
- 如果你已经有自己的本地 `CLAUDE.md` 文件，请把你需要的 Claude Scholar 内容按需 merge 进去，不要假设 sidecar 文件会自动生效。
- Zotero 和 Obsidian 都不是强制的，但如果你希望得到 durable literature notes 或 project memory，而不是一次性聊天输出，它们会非常有帮助。

## 平台支持

Claude Scholar 目前面向以下 CLI 工作流：

- **Claude Code** — 主安装目标
- **Codex CLI** — 支持对应工作流与文档
- **OpenCode** — 作为替代 CLI 支持

顶层目标一致：研究、编码、实验、报告、写作、项目知识库维护。

## 集成能力

### Zotero

适合这些场景：
- 通过 DOI / arXiv / URL 导入论文
- 按 collection 批量阅读论文
- 通过 Zotero MCP 读取全文
- 生成详细论文笔记与文献综合分析

详见 [MCP_SETUP.zh-CN.md](./MCP_SETUP.zh-CN.md)。

### Obsidian

适合这些场景：
- 维护以文件系统为核心的项目知识库
- 管理 `Papers/`
- 管理 `Experiments/`
- 管理 `Results/`
- 管理 `Results/Reports/`
- 管理 `Writing/` 与 `Daily/`

详见 [OBSIDIAN_SETUP.zh-CN.md](./OBSIDIAN_SETUP.zh-CN.md)。

## 主要工作流

完整学术研究生命周期 —— 从研究构思到发表的 7 个阶段。

### 1. 研究构思（Zotero 集成）

从想法生成到文献管理的一体化研究启动流程。

| 类型 | 名字 | 一句话解释 |
|---|---|---|
| Skill | `research-ideation` | 把模糊研究主题收敛成结构化问题、研究空白分析和初始研究计划。 |
| Agent | `literature-reviewer` | 搜索、分类并综合论文，形成可执行的文献图景。 |
| Command | `/research-init` | 从文献检索、Zotero 组织到研究提案草稿，一键启动新研究主题。 |
| Command | `/zotero-review` | 对已有 Zotero collection 做结构化文献综述与比较。 |
| Command | `/zotero-notes` | 批量阅读 Zotero collection，并生成结构化论文阅读笔记。 |

**工作方式**
- **5W1H 头脑风暴**：把模糊主题收敛成结构化问题。
- **文献检索与导入**：搜索论文、提取 DOI/arXiv/URL、导入 Zotero，并组织到主题文献集合。
- **PDF 与全文**：能挂 PDF 就挂 PDF，能读全文就读全文，必要时回退到摘要分析。
- **研究空白分析**：识别 literature / methodology / application / interdisciplinary / temporal 等不同类型的研究空白。
- **研究问题与规划**：把文献综述进一步转成明确研究问题、初始假设和下一步计划。

**典型产出**
- 文献综述笔记
- 结构化 Zotero 文献集合
- 研究计划 / 方向草稿

### 2. ML 项目开发

面向实验代码的可维护 ML 项目开发工作流。

| 类型 | 名字 | 一句话解释 |
|---|---|---|
| Skill | `architecture-design` | 在新增可注册组件或模块时设计可维护的 ML 项目结构。 |
| Skill | `git-workflow` | 约束分支规范、commit 规范和更安全的协作流程。 |
| Skill | `bug-detective` | 系统化排查 stack trace、shell 报错和代码路径问题。 |
| Agent | `code-reviewer` | 审查改动代码的正确性、可维护性和实现质量。 |
| Command | `/plan` | 在编码前创建或细化实现计划。 |
| Command | `/commit` | 为当前改动生成符合规范的 commit。 |
| Command | `/code-review` | 对当前代码改动执行一次聚焦审查。 |
| Command | `/tdd` | 以小步、测试驱动的方式推进功能实现。 |

**工作方式**
- **结构设计**：在合适场景下使用 Factory / Registry 模式组织 ML 组件。
- **代码质量**：保持文件规模、类型提示与配置驱动设计。
- **问题排查**：系统化处理 stack trace、shell 报错和代码路径问题。
- **Git 纪律**：维持分支策略、commit 规范和更安全的 merge/rebase 流程。

### 3. 实验分析

严格实验分析工作流：统计、科研图、分析产物与实验后报告。

| 类型 | 名字 | 一句话解释 |
|---|---|---|
| Skill | `results-analysis` | 生成由严格统计、真实科研图和分析附录组成的严格分析产物包。 |
| Skill | `results-report` | 把分析产物组织成完整实验总结报告，明确结论、限制和下一步动作。 |
| Command | `/analyze-results` | 一键执行完整实验后工作流：先严格分析，再生成最终实验报告。 |

**工作方式**
- **数据处理**：读取实验日志、metrics 文件和结果目录。
- **统计检验**：在合适前提下执行 t-test / ANOVA / Wilcoxon 等严格统计检验。
- **科研可视化**：生成真实科研图和解释线索，而不是只给模糊的绘图建议。
- **消融与比较**：分析组件贡献、性能 tradeoff 和稳定性。
- **实验后报告**：把分析产物包转成完整实验后总结报告，包含结论、限制和下一步动作。

**典型产出**
- `analysis-report.md`
- `stats-appendix.md`
- `figure-catalog.md`
- `figures/`
- 写入 Obsidian `Results/Reports/` 的实验总结报告

### 4. 论文写作

从结构准备到草稿迭代的系统化论文写作工作流。

| 类型 | 名字 | 一句话解释 |
|---|---|---|
| Skill | `ml-paper-writing` | 基于 repo、实验结果和文献上下文撰写投稿导向的 ML/AI 论文。 |
| Skill | `citation-verification` | 检查参考文献、元数据和 claim-citation 对齐，避免引用错误。 |
| Skill | `writing-anti-ai` | 减少机械化表述，提升清晰度、节奏和更自然的学术语气。 |
| Skill | `latex-conference-template-organizer` | 把混乱的会议模板整理成 Overleaf-ready 写作结构。 |
| Agent | `paper-miner` | 从高质量论文中提炼可复用的写作模式、结构和投稿经验。 |
| Command | `/mine-writing-patterns` | 读取论文并把可复用写作知识合并进全局 paper-miner writing memory。 |

**工作方式**
- **模板准备**：把会议模板清理成 Overleaf-ready 结构。
- **引用核验**：检查参考文献、元数据和 claim-citation 对齐。
- **系统化写作**：基于 repo、实验结果和文献上下文逐节写作。
- **风格打磨**：减少 AI 痕迹，改善节奏、清晰度和学术语气。

### 5. 论文自审

投稿前的质量保障工作流。

| 类型 | 名字 | 一句话解释 |
|---|---|---|
| Skill | `paper-self-review` | 在投稿前系统检查结构、逻辑、引用、图表和合规性。 |

**工作方式**
- **结构检查**：检查逻辑流、章节平衡和叙事连贯性。
- **逻辑校验**：检查 claim-evidence 对齐、假设清晰度和论证一致性。
- **引用审计**：检查引用准确性与完整性。
- **图表质量**：检查 caption 完整性、可读性和可访问性。
- **合规性检查**：检查页数限制、格式和披露要求。

### 6. 投稿与 Rebuttal

投稿准备和审稿回复工作流。

| 类型 | 名字 | 一句话解释 |
|---|---|---|
| Skill | `review-response` | 把审稿意见组织成基于证据的 rebuttal 工作流。 |
| Agent | `rebuttal-writer` | 起草专业、礼貌且结构清晰的 rebuttal 文本。 |
| Command | `/rebuttal` | 基于审稿意见和现有证据生成完整 rebuttal 草稿。 |

**工作方式**
- **投稿前检查**：检查会议/期刊格式、匿名化和清单要求。
- **审稿意见分析**：把审稿意见分类成可执行的问题。
- **回复策略**：决定是 accept、defend、clarify 还是补实验。
- **Rebuttal 写作**：生成结构化、基于证据、语气专业的回复文档。

### 7. 录用后处理

论文录用后的会议准备与研究传播工作流。

| 类型 | 名字 | 一句话解释 |
|---|---|---|
| Skill | `post-acceptance` | 支持论文录用后的报告、海报和传播材料准备。 |
| Command | `/presentation` | 生成会议报告的结构和讲解指导。 |
| Command | `/poster` | 整理论文内容并生成海报版式与内容指导。 |
| Command | `/promote` | 起草面向外部传播的摘要、帖子或 thread 内容。 |

**工作方式**
- **报告准备**：准备报告结构和演示文稿指导。
- **海报整理**：整理海报内容层级和版式。
- **传播内容**：生成社交媒体、博客或简明研究摘要。

## 支撑工作流

这些工作流运行在主工作流背后，用来增强整体使用体验。

### Obsidian 项目知识库

把 Obsidian 当作稳定科研知识的沉淀中心，而不是随手堆放笔记的地方。

| 类型 | 名字 | 一句话解释 |
|---|---|---|
| Skill | `obsidian-project-memory` | 维护项目级 Obsidian 知识库，并决定哪些稳定知识需要写回。 |
| Skill | `obsidian-project-bootstrap` | 为新项目或已有科研项目初始化对应的 Obsidian 知识库结构。 |
| Skill | `obsidian-research-log` | 将每日研究进展、计划、想法和 TODO 写入知识库。 |
| Skill | `obsidian-experiment-log` | 在 Obsidian 中记录实验设置、运行过程、结果和后续动作。 |
| Command | `/obsidian-ingest` | 把新的 Markdown 文件或目录整理并纳入正确的知识库位置。 |
| Command | `/obsidian-note` | 对单个 note 执行查找、重命名、归档或删除等生命周期操作。 |
| Command | `/obsidian-views` | 生成或刷新可选的 Obsidian 视图文件，例如 `.base`。 |

**工作方式**
- 将已有 repo 绑定到 Obsidian vault
- 把稳定知识路由进 `Papers / Knowledge / Experiments / Results / Writing`，具体轮次的实验报告存放在 `Results/Reports/` 下
- 以保守方式维护 `Daily/` 和项目记忆
- 把新的 Markdown 文件分类并合并进正确的规范笔记
- 按需生成额外视图和 canvas

**笔记语言配置**

生成和同步 Obsidian 笔记时，语言按以下优先级解析：
1. 项目配置：`.claude/project-memory/registry.yaml` 中的 `note_language`
2. 环境变量：`OBSIDIAN_NOTE_LANGUAGE`
3. 默认值：`en`

说明：文件名目前仍叫 `registry.yaml`，但其磁盘格式实际上是 JSON。

项目级示例：

```json
{
  "projects": {
    "my-project": {
      "project_id": "my-project",
      "vault_root": "/path/to/vault/Research/my-project",
      "note_language": "zh-CN"
    }
  }
}
```

同步时会同时兼容英文和中文 section heading，因此切换配置后，历史英文/中文笔记都可以继续安全更新。

### 自动化约束工作流

跨平台 hooks 自动执行日常检查与提醒。

**Hook 列表**
- `skill-forced-eval.js`
- `session-start.js`
- `session-summary.js`
- `stop-summary.js`
- `security-guard.js`

**工作方式**
- **用户提问前**：评估当前 prompt 应该触发哪些 skills，并补充相关 workflow 提示。
- **会话开始时**：显示 Git 状态、可用命令和项目记忆上下文。
- **会话结束或停止时**：总结工作内容，并提醒最小维护动作。
- **安全防护**：拦截灾难性命令，并对危险但合理的操作要求确认。

### 知识提炼工作流

专门的 agents 可持续提炼论文和竞赛中的可复用知识。

| 类型 | 名字 | 一句话解释 |
|---|---|---|
| Agent | `paper-miner` | 从高质量论文中提炼可复用的写作知识、结构模式和投稿经验。 |
| Agent | `kaggle-miner` | 从优秀 Kaggle 工作流中提炼工程实践和解决方案模式。 |

**工作方式**
- 从论文中提炼写作模式、会议要求和 rebuttal 策略
- 从 Kaggle 工作流中提炼工程模式和解决方案结构
- 再把这些知识回流进 skills 与 references 中。

### 技能进化系统

Claude Scholar 也内置了自我改进的 skill 工作流。

| 类型 | 名字 | 一句话解释 |
|---|---|---|
| Skill | `skill-development` | 创建具备清晰触发条件、结构和渐进展开方式的新技能模块。 |
| Skill | `skill-quality-reviewer` | 从内容质量、组织方式、表达风格和结构完整性审查 skill。 |
| Skill | `skill-improver` | 根据结构化改进计划持续优化已有 skills。 |

**工作方式**
- 创建带有清晰触发描述的新 skill
- 按多个质量维度审查 skill
- 合并改进建议并持续迭代

## 文档入口

- [MCP_SETUP.zh-CN.md](./MCP_SETUP.zh-CN.md) — Zotero / 浏览器 MCP 配置
- [OBSIDIAN_SETUP.zh-CN.md](./OBSIDIAN_SETUP.zh-CN.md) — Obsidian 项目知识库工作流
- [CLAUDE.md](./CLAUDE.md) — 轻量版 Claude Code 核心指令
- [CLAUDE.zh-CN.md](./CLAUDE.zh-CN.md) — 轻量核心指令的中文 companion 文件
- [settings.json.template](./settings.json.template) — hooks / plugins / MCP 的可选模板

## 项目规则

Claude Scholar 包含以下方面的项目规则：
- 代码风格
- agent 编排
- 安全约束
- 实验可复现性

这些规则体现在仓库附带的 rules 以及 `CLAUDE.md` 中。

## 贡献

欢迎提交 issue、PR 和工作流改进建议。

如果你想改 installer、Zotero 工作流或 Obsidian 路由，建议在提案中说明：
- 用户场景
- 当前限制
- 预期行为
- 兼容性影响

## 许可证

MIT 许可证。

## 引用

如果 Claude Scholar 对你的研究或工程工作流有帮助，你可以按下面方式引用：

```bibtex
@misc{claude_scholar_2026,
  title        = {Claude Scholar: Semi-automated research assistant for academic research and software development},
  author       = {Gaorui Zhang},
  year         = {2026},
  howpublished = {\url{https://github.com/Galaxy-Dawn/claude-scholar}},
  note         = {GitHub repository}
}
```

## 致谢

使用 Claude Code CLI 构建，并由开源社区增强。

### 参考资料

本项目受到社区优秀工作的启发和构建：

- **[everything-claude-code](https://github.com/anthropics/everything-claude-code)** - Claude Code CLI 的综合资源
- **[AI-research-SKILLs](https://github.com/zechenzhangAGI/AI-research-SKILLs)** - 研究导向的技能和配置

这些项目为 Claude Scholar 的研究导向功能提供了宝贵的见解和基础。

---

**面向数据科学、AI 研究和学术写作。**

仓库：[https://github.com/Galaxy-Dawn/claude-scholar](https://github.com/Galaxy-Dawn/claude-scholar)
