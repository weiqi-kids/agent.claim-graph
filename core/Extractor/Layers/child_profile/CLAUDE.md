# child_profile Layer

## Layer 類型：User-Input

> **Phase 2** — 此 Layer 在 Phase 1 為 `.disabled` 狀態

---

## Layer 定義表

| 項目 | 內容 |
|------|------|
| **Layer name** | child_profile（孩子學習檔案） |
| **Layer type** | User-Input |
| **Engineering function** | 接收並驗證使用者上傳的孩子學習資料 |
| **Data sources** | 使用者手動上傳 JSON |
| **Update frequency** | 手動（使用者觸發） |
| **Output value** | 提供個別孩子的學習進度資料供 Mode 分析 |
| **Category enum** | `profiles` |
| **Reviewer persona** | 使用者誤導風險審核員 |

---

## 特殊說明

此 Layer **沒有 fetch.sh**，因為資料來自使用者輸入。

使用者需將 JSON 檔案放入 `docs/Extractor/child_profile/raw/` 目錄。

---

## JSON Schema

使用者上傳的 JSON 必須符合以下結構：

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["child_id", "grade_level", "assessments"],
  "properties": {
    "child_id": {
      "type": "string",
      "description": "唯一識別碼（家長自定義）"
    },
    "grade_level": {
      "type": "string",
      "description": "目前年級",
      "enum": ["K", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    },
    "assessments": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["standard_id", "status"],
        "properties": {
          "standard_id": {
            "type": "string",
            "description": "對應的標準 ID（如 CCSS.MATH.3.OA.A.1）"
          },
          "status": {
            "type": "string",
            "enum": ["not_started", "in_progress", "mastered"],
            "description": "學習狀態"
          },
          "assessed_date": {
            "type": "string",
            "format": "date"
          },
          "notes": {
            "type": "string"
          }
        }
      }
    }
  }
}
```

---

## 隱私保護規則

- `child_id` 必須由家長自行定義，系統不產生
- 系統不儲存真實姓名
- 所有資料僅在本地處理

---

## `[REVIEW_NEEDED]` 觸發規則

以下情況**必須**標記 `[REVIEW_NEEDED]`：

1. `standard_id` 不存在於 `standards_frameworks` Layer
2. `grade_level` 與 `standard_id` 的年級不符（差距超過 2 年）
3. JSON 格式不符合 schema

---

## 自我審核 Checklist

- [ ] JSON 通過 schema 驗證
- [ ] `child_id` 不含可識別個人資訊
- [ ] 所有 `standard_id` 可追溯到 L1

---

End of child_profile/CLAUDE.md
