# gap_identification Mode

## Mode 可驗證性：Comparative

---

## Mode 定義表

| 項目 | 內容 |
|------|------|
| **Mode name** | gap_identification（差異識別） |
| **Verifiability** | Comparative |
| **Purpose and audience** | 比較孩子已掌握的技能與課綱標準的差異 |
| **Source layers** | L1 standards_frameworks, L4 child_profile |
| **Required disclaimer** | ✅ 必須（見下方警語） |
| **Reviewer persona** | 使用者誤導風險審核員、自動化邊界審核員 |

---

## 必要警語

> **重要提示**
>
> 本報告僅呈現「課綱標準」與「使用者輸入的學習狀態」之間的數據差異。
>
> - 這不是學習診斷或能力評估
> - 差異不代表「落後」或「需要補救」
> - 每個孩子的學習路徑不同，課綱順序僅供參考
>
> 如需學習規劃建議，請諮詢專業教育人員。

---

## 資料來源定義

| 來源 | 路徑 | 用途 |
|------|------|------|
| 課綱標準 | `docs/Extractor/standards_frameworks/` | 參照框架 |
| 孩子檔案 | `docs/Extractor/child_profile/` | 使用者輸入的狀態 |

---

## 輸入參數

| 參數 | 必填 | 說明 |
|------|------|------|
| `child_id` | ✅ | 孩子識別碼（來自 child_profile） |
| `subject` | ✅ | 科目（Math / ELA） |

---

## 輸出框架

```markdown
---
mode: gap_identification
verifiability: Comparative
generated_at: {ISO8601}
parameters:
  child_id: {child_id}
  subject: {subject}
source_layers:
  - standards_frameworks
  - child_profile
---

# {child_id} — {subject} 差異識別報告

> **重要提示**
>
> 本報告僅呈現「課綱標準」與「使用者輸入的學習狀態」之間的數據差異。
> 這不是學習診斷或能力評估。差異不代表「落後」或「需要補救」。
> 如需學習規劃建議，請諮詢專業教育人員。

## 報告摘要

| 指標 | 數值 |
|------|------|
| 目前年級 | {grade_level} |
| 該年級標準總數 | {total_standards} |
| 標記為「已掌握」 | {mastered_count} |
| 標記為「進行中」 | {in_progress_count} |
| 標記為「未開始」 | {not_started_count} |

## 狀態分佈

### 已掌握（Mastered）

| Standard ID | Domain | Statement |
|-------------|--------|-----------|
| {id} | {domain} | {statement} |

### 進行中（In Progress）

| Standard ID | Domain | Statement |
|-------------|--------|-----------|
| {id} | {domain} | {statement} |

### 未開始（Not Started）

| Standard ID | Domain | Statement |
|-------------|--------|-----------|
| {id} | {domain} | {statement} |

## 資料來源

- 課綱標準：Common Standards Project（擷取時間：{fetched_at}）
- 學習狀態：使用者輸入（更新時間：{profile_updated_at}）

---

*本報告由學生學習地圖系統自動產生*
```

---

## 輸出位置

`docs/Narrator/gap_identification/{child_id}-{subject}.md`

---

## 產出規則

1. **警語置頂**：警語必須出現在報告開頭
2. **只呈現比對結果**：不做任何價值判斷
3. **狀態來自使用者輸入**：不可由系統推測狀態
4. **中性用語**：使用「未開始」而非「缺漏」或「落後」

---

## 禁止行為

- 不可使用「落後」、「需要加強」、「缺漏」等詞
- 不可建議學習順序
- 不可預測學習時間
- 不可比較不同孩子
- 不可暗示「已掌握」數量多寡代表學習品質

---

## 自我審核 Checklist

- [ ] 警語完整出現在報告開頭
- [ ] 狀態分類正確（mastered/in_progress/not_started）
- [ ] 所有 Standard ID 可追溯到 L1
- [ ] 無任何價值判斷或建議
- [ ] 使用中性用語

---

End of gap_identification/CLAUDE.md
