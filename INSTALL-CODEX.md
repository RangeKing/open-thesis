# Open Thesis - Codex CLI 安装指南

本仓库已新增 Codex CLI 支持，配置文件位于 `codex/`。

## 先决条件

- Git
- Node.js
- （可选）zotero-mcp

说明：安装脚本会自动检测 `codex`，若未安装会尝试执行：

```bash
npm install -g @openai/codex
```

若自动安装失败，会提示官方文档：
- https://github.com/openai/codex#installation

安装流程会检测已有 `~/.codex/config.toml` 与 `~/.codex/auth.json`：
- 若你选择“保持已有配置”，且已有 model 与 API key，可直接复用并跳过输入。
- 若缺失项需要补充，脚本会给出“现在输入/跳过输入”的选项。

## 一键安装

### macOS / Linux

```bash
bash setup-codex.sh
```

### Windows PowerShell

```powershell
./setup-codex.ps1
```

### Windows 双击

- 双击 `setup-codex.bat`
- 日志输出到 `setup-codex-windows.log`

## 安装结果

会写入以下目录：

- `~/.codex/config.toml`
- `~/.codex/auth.json`（如果输入了 API Key）
- `~/.codex/skills/`（从仓库 `skills/` 同步）
- `~/.codex/agents/`（从仓库 `codex/agents/` 同步）
- `~/.codex/AGENTS.md`

## 目录说明

- `codex/config.toml`：Codex 配置模板（安装脚本会替换模型/供应商占位符）
- `codex/AGENTS.md`：Codex 项目级指令
- `codex/agents/*`：每个 agent 的 `config.toml` + `AGENTS.md`

## 验证

1. 执行 `codex`
2. 检查 `~/.codex/config.toml` 中是否存在：
   - `sandbox_mode = "workspace-write"`
   - `developer_instructions` 含 thesis_mode 约束
   - `agents.*` 段
3. 在项目内发起任务并观察是否触发 thesis 写作规范

## 故障排查

- 安装失败：查看 Windows 日志 `setup-codex-windows.log`
- 认证失败：检查 `~/.codex/auth.json` 或环境变量 `OPENAI_API_KEY`
- agent 未触发：确认 `~/.codex/agents/<name>/config.toml` 与 `AGENTS.md` 均存在
