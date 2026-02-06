# standards_frameworks Layer

## Layer 類型：Auto-Fetch

---

## Layer 定義表

| 項目 | 內容 |
|------|------|
| **Layer name** | standards_frameworks（課綱標準框架） |
| **Layer type** | Auto-Fetch |
| **Engineering function** | 擷取各國課綱標準的結構化資料 |
| **Data sources** | US Common Core（Common Standards Project API、GitHub） |
| **Update frequency** | 每週（課綱更新頻率低，但需要追蹤 API 變動） |
| **Output value** | 提供標準化的學習目標參照框架 |
| **Category enum** | `us_common_core_math`, `us_common_core_ela` |
| **Reviewer persona** | 資料可信度審核員、邏輯一致性審核員 |

---

## 資料來源

### Phase 1（US Common Core）

| 來源 | URL | 格式 | 狀態 |
|------|-----|------|------|
| Common Standards Project API | https://www.commonstandardsproject.com/developers | JSON API | ✅ 已驗證 |
| standards-data GitHub | https://github.com/SirFizX/standards-data | JSON files | ✅ 已驗證 |

### Phase 4（台灣，待實作）

| 來源 | URL | 格式 | 狀態 |
|------|-----|------|------|
| NAER 課綱 | https://www.naer.edu.tw/PageSyllabus?fid=52 | PDF/HTML | 待萃取 |

---

## Category Enum

| 英文 key | 中文 | 判定條件 |
|----------|------|----------|
| `us_common_core_math` | 美國共同核心數學 | subject field = "Math" |
| `us_common_core_ela` | 美國共同核心英語 | subject field = "ELA" (English Language Arts) |

> **嚴格限制**：category 只能使用上述值。需要新增（如台灣課綱）時必須先更新此表。

---

## 萃取邏輯

### 輸入格式（JSONL 單行）

Common Standards Project API 回傳的標準格式：

```json
{
  "id": "CCSS.MATH.3.OA.A.1",
  "statement": "Interpret products of whole numbers...",
  "education_levels": ["03"],
  "subject": "Math",
  "subject_area": "Operations & Algebraic Thinking",
  "document": {
    "title": "Common Core State Standards for Mathematics"
  }
}
```

### 萃取規則

1. **standard_id**：使用 `id` 欄位（如 `CCSS.MATH.3.OA.A.1`）
2. **grade_level**：從 `education_levels` 解析（"03" → "Grade 3"）
3. **subject**：使用 `subject` 欄位
4. **skill_domain**：使用 `subject_area` 欄位
5. **statement**：使用 `statement` 欄位，不做任何改寫

### 不可萃取的內容

- 不可新增原始資料沒有的詮釋
- 不可翻譯 statement（保持英文原文）
- 不可推測難度等級（原始資料沒有此欄位）

---

## `[REVIEW_NEEDED]` 觸發規則

以下情況**必須**標記 `[REVIEW_NEEDED]`：

1. `id` 欄位格式不符合 CCSS 標準格式（如缺少 "CCSS." 前綴）
2. `education_levels` 為空或格式異常
3. `statement` 欄位為空或內容不完整（少於 10 字元）
4. API 回傳的資料與 GitHub 版本有顯著差異

以下情況**不觸發** `[REVIEW_NEEDED]`：

- ❌ 「僅單一來源」— 這是結構性限制
- ❌ 「欄位為可選且為空」— 如 `parent_id` 為空是正常的
- ❌ 「跨年級標準」— 某些標準適用多個年級是正常的

---

## 輸出格式

每個標準產出一個 .md 檔，存放在 `docs/Extractor/standards_frameworks/{category}/`：

```markdown
---
standard_id: CCSS.MATH.3.OA.A.1
source_url: https://www.commonstandardsproject.com/api/v1/standard/CCSS.MATH.3.OA.A.1
fetched_at: 2026-02-02T10:00:00Z
source_layer: standards_frameworks
grade_level: Grade 3
subject: Math
skill_domain: Operations & Algebraic Thinking
---

# CCSS.MATH.3.OA.A.1

## Standard Statement

Interpret products of whole numbers, e.g., interpret 5 × 7 as the total number of objects in 5 groups of 7 objects each. For example, describe a context in which a total number of objects can be expressed as 5 × 7.

## Metadata

- **Document**: Common Core State Standards for Mathematics
- **Grade Level**: Grade 3
- **Domain**: Operations & Algebraic Thinking

---

*來源：Common Standards Project API*
```

### 檔名規則

`{standard_id}.md`，將 `.` 替換為 `-`

範例：`CCSS.MATH.3.OA.A.1` → `CCSS-MATH-3-OA-A-1.md`

---

## 自我審核 Checklist

輸出前必須確認：

- [ ] `standard_id` 格式正確且與來源一致
- [ ] `statement` 完整複製，無任何改寫
- [ ] `grade_level` 與 `education_levels` 對應正確
- [ ] `source_url` 指向實際可存取的 API endpoint
- [ ] 無新增原始資料不存在的內容
- [ ] 若觸發 REVIEW_NEEDED 條件，已在檔案開頭標記

---

End of standards_frameworks/CLAUDE.md
