---
name: thesis-format-check
description: 自动检查中文学位论文格式是否符合 GB/T 7713.1-2006 与 GB/T 7714-2015
args:
  - name: thesis_file
    description: 论文主文件路径（md/tex/docx 任一）
    required: false
  - name: degree
    description: 学位类型（master/phd）
    required: false
    default: master
tags: [Thesis Format, GB/T 7713.1-2006, GB/T 7714-2015]
---

# /thesis-format-check - 学位论文格式核验

自动核验以下内容并输出问题清单。

## 检查项

1. 结构顺序检查
- 封面 → 声明与授权 → 中文摘要+关键词 → 英文摘要+Keywords → 目录 → 正文 → 参考文献 → 附录 → 致谢 → 成果 → 作者简介（博士）

2. 摘要字数检查
- 硕士：500-1000
- 博士：1000-2000

3. 排版检查
- A4、字体、行距、缩进、章节编号格式

4. 参考文献检查
- 顺序编码制
- 类型标识
- 编号一致性
- 数量、中外文比例、近5年比例

## 输出文件

- `thesis-format-report.md`
- `thesis-format-fixes.md`

## 输出格式

```markdown
## 格式检查报告
- 总体结论：通过/需修复
- 严重问题：N
- 一般问题：N

### [High] 问题标题
- 现象：...
- 规范依据：GB/T ...
- 修复建议：...
```
