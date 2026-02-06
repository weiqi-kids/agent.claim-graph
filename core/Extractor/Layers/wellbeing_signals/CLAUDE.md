# wellbeing_signals Layer

## Layer 類型：User-Input

> **Phase 4** — 此 Layer 在 Phase 1-3 為 `.disabled` 狀態

---

## Layer 定義表

| 項目 | 內容 |
|------|------|
| **Layer name** | wellbeing_signals（身心指標） |
| **Layer type** | User-Input |
| **Engineering function** | 接收並儲存使用者自評的身心狀態量表 |
| **Data sources** | 使用者手動輸入 |
| **Update frequency** | 手動（建議每週） |
| **Output value** | 提供學習負荷的參考指標 |
| **Category enum** | `weekly_checkin` |
| **Reviewer persona** | 自動化邊界審核員、使用者誤導風險審核員 |

---

## 重要警示

此 Layer 的資料**僅用於呈現趨勢**，系統不會：

- 提供心理健康建議
- 判斷是否需要專業協助
- 做任何診斷性聲明

如有身心健康疑慮，請諮詢專業人員。

---

## 資料格式

使用者填寫的量表格式：

```json
{
  "child_id": "string",
  "week": "2026-W05",
  "indicators": {
    "sleep_quality": 1-5,
    "study_motivation": 1-5,
    "stress_level": 1-5,
    "enjoyment": 1-5
  },
  "notes": "optional free text"
}
```

---

## 自我審核 Checklist

- [ ] 不產生任何心理健康建議
- [ ] 僅呈現數據趨勢
- [ ] 已加上專業諮詢提示

---

End of wellbeing_signals/CLAUDE.md
