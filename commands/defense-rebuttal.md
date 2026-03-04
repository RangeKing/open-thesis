---
name: defense-rebuttal
description: 输入答辩意见并生成分类回复（Major/Minor）+ 证据链 + 中文礼貌语气模板
args:
  - name: comments
    description: 答辩意见文本或文件路径
    required: true
  - name: tone
    description: 回复语气（formal/moderate）
    required: false
    default: formal
tags: [Defense, Rebuttal, Thesis, Chinese Academic]
---

# /defense-rebuttal - 答辩意见分类回复

对 "$comments" 进行分类并生成可直接提交的答辩回复。

## 处理流程

1. 意见拆分与编号
2. 分类：Major / Minor
3. 逐条构建证据链（章节、页码、图表、文献）
4. 生成礼貌回复与修改说明
5. 汇总总体修改清单

## 回复模板

```markdown
### Comment 1 (Major)
- 委员意见：...
- 回复：感谢委员指出该问题。研究已在第X章第Y节补充......
- 修改内容：新增/重写......
- 证据：页X，图Y，表Z，参考文献[n]
```

## 语气约束

- 开头使用感谢语
- 避免情绪化、防御性语句
- 结论以事实和证据为中心

## 输出文件

- `defense-rebuttal.md`
- `defense-major-minor-matrix.md`
- `defense-evidence-map.md`
