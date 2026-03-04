---
name: rebuttal
description: 中文学位论文答辩意见回复流程（分类、证据、修改说明、礼貌语气）
args:
  - name: review_file
    description: 答辩意见文件路径（可选）
    required: false
tags: [Thesis Defense, Rebuttal, Academic Chinese]
---

# /rebuttal - 学位论文答辩回复

启动中文学位论文答辩意见回复流程，生成规范化 `rebuttal.md`。

## 工作流

### Step 1: 获取意见

- 有 `review_file`：读取并分条
- 无 `review_file`：引导用户粘贴意见

### Step 2: 分类

按以下类型分类：
- `Major`：影响论文核心逻辑/结果可信度
- `Minor`：表述、结构、补充说明
- `Formatting`：格式、编号、标点、图表样式
- `Misunderstanding`：评审/答辩委员误解

### Step 3: 构建证据链

每条意见必须包含：
- 对应章节/页码
- 修改前后差异
- 数据、图表或文献支撑

### Step 4: 生成回复文本

输出结构：

```markdown
### 意见 X（Major/Minor/...）
- 原意见：...
- 回复：...
- 已完成修改：...
- 证据位置：第X章，第Y页，图Z/表Z，参考文献[n]
```

### Step 5: 语气优化

- 保持礼貌、客观、克制
- 避免对抗性表达
- 避免“笔者认为/本文认为”，改为“研究发现/结果表明”

## 输出文件

- `rebuttal.md`
- `defense-change-log.md`
- `defense-evidence-list.md`

## 推荐替代命令

- `/defense-rebuttal`：更细化的答辩场景命令（含模板化礼貌语）
