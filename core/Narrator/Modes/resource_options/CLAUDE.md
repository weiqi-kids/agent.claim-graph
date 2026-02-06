# resource_options Mode

## Mode 可驗證性：Factual

> **Phase 2** — 此 Mode 在 Phase 1 為 `.disabled` 狀態

---

## Mode 定義表

| 項目 | 內容 |
|------|------|
| **Mode name** | resource_options（資源選項） |
| **Verifiability** | Factual (list) |
| **Purpose and audience** | 列出對應特定標準的練習資源 |
| **Source layers** | L1 standards_frameworks, L3 problem_banks |
| **Required disclaimer** | 無（僅列出資源，不做推薦） |
| **Reviewer persona** | 資料可信度審核員 |

---

## 資料來源定義

| 來源 | 路徑 | 用途 |
|------|------|------|
| 課綱標準 | `docs/Extractor/standards_frameworks/` | 對應標準 |
| 題庫索引 | `docs/Extractor/problem_banks/` | 練習資源列表 |

---

## 輸出框架

```markdown
# {Standard ID} 相關練習資源

## 標準資訊

- **ID**: {standard_id}
- **Statement**: {statement}
- **Domain**: {domain}

## 相關題目（共 {count} 題）

| Source | Problem ID | Difficulty | Topics |
|--------|------------|------------|--------|
| AoPS | {id} | {difficulty} | {topics} |
| AMC | {id} | {difficulty} | {topics} |

---

*本列表不構成推薦。請依實際需求選擇適合的練習資源。*
```

---

## 產出規則

1. **只列出資源**：不做推薦或排序
2. **難度來自原始資料**：不可自行標註難度
3. **對應關係透明**：說明如何判定相關性

---

## 自我審核 Checklist

- [ ] 資源來源明確
- [ ] 難度標註來自原始資料
- [ ] 無推薦語句

---

End of resource_options/CLAUDE.md
