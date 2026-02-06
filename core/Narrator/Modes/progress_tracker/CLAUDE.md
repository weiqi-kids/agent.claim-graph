# progress_tracker Mode

## Mode 可驗證性：Factual

> **Phase 2** — 此 Mode 在 Phase 1 為 `.disabled` 狀態

---

## Mode 定義表

| 項目 | 內容 |
|------|------|
| **Mode name** | progress_tracker（進度追蹤） |
| **Verifiability** | Factual |
| **Purpose and audience** | 追蹤孩子在一段時間內的狀態變化 |
| **Source layers** | L4 child_profile（多次快照） |
| **Required disclaimer** | 無 |
| **Reviewer persona** | 邏輯一致性審核員 |

---

## 資料來源定義

從 `docs/Extractor/child_profile/` 讀取同一 `child_id` 的歷史資料，
依 `updated_at` 時間戳排序。

---

## 輸出框架

```markdown
# {child_id} 進度追蹤報告

## 追蹤期間

{start_date} 至 {end_date}

## 狀態變化摘要

| 指標 | 起始 | 目前 | 變化 |
|------|------|------|------|
| 已掌握標準數 | {n1} | {n2} | +{diff} |
| 進行中標準數 | {n1} | {n2} | {diff} |

## 新掌握的標準

| Standard ID | Domain | 掌握日期 |
|-------------|--------|----------|
| {id} | {domain} | {date} |

---

*本報告僅呈現狀態變化數據*
```

---

## 產出規則

1. **只呈現數據變化**：不評價進步速度
2. **時間來自使用者輸入**：不可推測
3. **變化為中性描述**：「+3」而非「進步了 3 個」

---

## 自我審核 Checklist

- [ ] 時間範圍正確
- [ ] 數據計算正確
- [ ] 無評價性用語

---

End of progress_tracker/CLAUDE.md
