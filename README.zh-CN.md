# Open Thesis（中文说明）

> 本项目已专门优化为中文硕士/博士学位论文 CLI 配置。

详细文档请优先查看 [README.md](./README.md)。

## 快速开始

```bash
bash setup.sh
```

Windows（PowerShell）：

```powershell
./setup.ps1
```

Windows（一键安装）：

- 双击 `setup.bat`
- 脚本会停留窗口并写入日志 `setup-windows.log`
- 安装脚本会检测 `claude`，未安装时尝试自动安装；失败时给出官方安装文档链接

## 分平台安装 Claude Code / Codex CLI

> 安装脚本会自动检测并尝试安装；如需手动安装，请参考以下命令。

### Claude Code CLI

macOS / Linux / WSL：

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

Windows PowerShell：

```powershell
irm https://claude.ai/install.ps1 | iex
```

验证命令：

```bash
claude --version
```

官方文档：[Claude Code Getting Started](https://code.claude.com/docs/en/getting-started)

### Codex CLI

前置要求：Node.js + npm

macOS / Linux / Windows（PowerShell/cmd）：

```bash
npm install -g @openai/codex
```

验证命令：

```bash
codex --version
```

官方文档：[OpenAI Codex Installation](https://github.com/openai/codex#installation)

## Codex CLI 支持

macOS / Linux：

```bash
bash setup-codex.sh
```

Windows PowerShell：

```powershell
./setup-codex.ps1
```

Windows 一键：

- 双击 `setup-codex.bat`（日志：`setup-codex-windows.log`）
- 详细文档见 [INSTALL-CODEX.md](./INSTALL-CODEX.md)
- 安装脚本会检测 `codex`，未安装时尝试自动安装；失败时给出官方安装文档链接

## 核心命令

- `/research-init`
- `/zotero-review`
- `/paper-self-review`
- `/thesis-format-check`
- `/generate-bilingual-abstract`
- `/defense-rebuttal`
- `/rebuttal`

## 规范基线

- GB/T 7713.1-2006
- GB/T 7714-2015
- 学校模板细则

## 兼容说明

`ml-paper-writing` 保留为兼容入口；显式指定顶会场景时会走 legacy ML 模式。
