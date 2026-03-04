---
name: paper-self-review
description: 中文学位论文提交前自审（结构、排版、摘要、引用、创新点、答辩准备）
args:
  - name: thesis_file
    description: 论文文件路径（可选，默认扫描当前目录）
    required: false
  - name: degree
    description: 学位类型（master/phd）
    required: false
    default: master
tags: [Thesis QA, Self Review, GB/T 7713.1-2006, GB/T 7714-2015]
---

# /paper-self-review - 中文学位论文自审

对论文进行提交前全量质量核验。

## 核验维度

1. 结构完整性
- 是否包含封面、声明、中英摘要、目录、正文、参考文献、附录、致谢、成果、作者简介（博士）

2. 摘要合规
- 硕士中文摘要 500-1000 字
- 博士中文摘要 1000-2000 字
- 英文摘要与中文一致，关键词 3-8 个

3. 排版合规
- A4、宋体小四、章标题黑体小二、英文 Times New Roman
- 行距 20 磅、首行缩进 2 字符

4. 引用合规
- GB/T 7714-2015 顺序编码制
- 文内文末编号一致
- 文献数量与时效满足学位要求

5. 学术表达质量
- 去除 AI 腔：宣传化、象征化、模糊归因
- 结论是否给出明确新见解
- 文献综述是否“述评结合”

6. 答辩就绪度
- 是否准备 Major/Minor 分类回复表
- 是否完成证据链索引（页码、图表、文献）

## 输出

1. `thesis-self-review-report.md`
2. `thesis-fix-list.md`
3. `thesis-risk-register.md`

## 强制格式

每一项问题给出：
- 问题等级（High/Medium/Low）
- 问题描述
- 修复建议
- 优先级
