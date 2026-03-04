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
