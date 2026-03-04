---
name: zotero-review
description: 针对 Zotero 集合生成中文学位论文文献综述（述评结合）与国标引用核验
args:
  - name: collection
    description: Zotero 集合名或关键词
    required: true
  - name: depth
    description: 分析深度（quick/deep）
    required: false
    default: deep
tags: [Thesis, Zotero, Literature Review, GB/T 7714]
---

# /zotero-review - 中文学位论文文献综述

读取并分析 Zotero 集合 "$collection"（深度："$depth"），输出符合中文学位论文要求的综述结果。

## 执行步骤

### Step 1: 定位集合

1. 获取集合列表
2. 定位目标集合
3. 拉取集合条目与基础元数据

### Step 2: 读取文献内容

- `quick`：摘要 + 引言
- `deep`：优先全文（PDF）+ 摘要补充

对每篇文献提取：
- 研究问题
- 理论/方法
- 数据与实验设计
- 关键结论
- 局限性
- 可复用到本论文的位置

### Step 3: 述评结合综合

1. “述”：按时间线或主题线梳理研究脉络
2. “评”：识别共识、分歧、方法短板、数据偏差
3. 提炼创新入口：
   - 理论创新
   - 方法创新
   - 应用创新

### Step 4: 国标引用核验

按 GB/T 7714-2015 检查：
- 顺序编码制 `[1][2]...`
- 文内编号与文末条目一致
- 作者、题名、文献类型标识、出版项完整

### Step 5: 输出文件

1. `literature-review.md`
   - 含“国内外研究现状 + 述评 + 本文切入点”
2. `references.bib`
   - Zotero 导出
3. `references-gbt7714-check.md`
   - 格式核验报告（错误项 + 修复建议）

## Zotero 导入提示

如需补充文献，优先 DOI 导入；无 DOI 时提示使用 CNKI 链接导入。
