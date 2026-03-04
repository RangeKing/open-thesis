---
name: research-init
description: 初始化中文硕士/博士学位论文研究流程（Zotero 文献库 + 论文框架 + ctex 模板 + 研究计划）
args:
  - name: topic
    description: 论文题目或研究主题
    required: true
  - name: degree
    description: 学位类型（master/phd）
    required: false
    default: master
  - name: scope
    description: 调研范围（focused/broad）
    required: false
    default: focused
tags: [Thesis, Zotero, Literature Review, Chinese Academic]
---

# /research-init - 中文学位论文研究初始化

为主题 "$topic" 初始化中文学位论文工作流（学位类型："$degree"，调研范围："$scope"）。

## 执行步骤

### Step 1: 启用 thesis 模式

1. 强制启用技能：`chinese-degree-thesis-writing`
2. 在上下文中写入偏好：`thesis_mode: true`
3. 默认遵循：GB/T 7713.1-2006 与 GB/T 7714-2015

### Step 2: 创建 Zotero 论文集合

1. 创建主集合：`中文学位论文-{TopicShort}-{YYYY-MM}`
2. 创建子集合：
   - `中文核心文献`
   - `外文核心文献`
   - `方法与理论`
   - `待精读`
   - `答辩支撑材料`
3. 记录各子集合 `collection_key`

### Step 3: 文献检索与导入（DOI 优先，CNKI 兜底）

1. 检索与 "$topic" 高相关的中外文文献
2. 导入策略：
   - 优先 `mcp__zotero__add_items_by_doi`
   - 无 DOI 时，提示并允许通过 CNKI 链接导入（`add_web_item`）
3. 导入前去重：
   - DOI 精确匹配
   - 标题相似度 > 0.8 视为重复
4. 导入后批量附 PDF：`mcp__zotero__find_and_attach_pdfs`

### Step 4: 生成论文初稿骨架

输出以下文件：

1. `thesis-outline.md`
   - 含完整章节顺序：封面/声明/中英摘要/目录/正文/参考文献/附录/致谢/成果/作者简介（博士）
2. `literature-review.md`
   - 按“述评结合”写法组织：研究脉络 + 评议 + gap
3. `thesis-template.tex`
   - ctex + xeCJK 可编译模板
4. `references.bib`
   - 从 Zotero 导出
5. `writing-plan.md`
   - 周计划与里程碑（选题、综述、方法、实验、定稿、答辩）

### Step 5: 合规检查

使用 `structure-checklist.md` 检查：
- 硕士文献不少于 40，博士不少于 100
- 中外文比例建议各半
- 近 5 年文献不少于 1/3

## 强制输出格式

每个核心结果必须给两版：
1. Markdown
2. LaTeX(ctex)

## 进度跟踪

使用 TodoWrite 记录阶段状态（检索、导入、综述、框架、模板、核验）。

## 相关命令

- `/zotero-review`：对已有文献集合做述评分析
- `/thesis-format-check`：检查格式合规
- `/generate-bilingual-abstract`：中英摘要生成
- `/defense-rebuttal`：答辩意见分类回复
