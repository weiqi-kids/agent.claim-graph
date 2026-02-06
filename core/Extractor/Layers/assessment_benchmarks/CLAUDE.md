# assessment_benchmarks Layer

## Layer 類型：Static-Knowledge

---

## Layer 定義表

| 項目 | 內容 |
|------|------|
| **Layer name** | assessment_benchmarks（測評基準） |
| **Layer type** | Static-Knowledge |
| **Engineering function** | 擷取標準化測評的難度分級與能力指標 |
| **Data sources** | AMC/AIME（GitHub）、CEFR（HuggingFace） |
| **Update frequency** | 每季（測評標準更新頻率低） |
| **Output value** | 提供客觀的能力程度參照點 |
| **Category enum** | `amc_math`, `cefr_english` |
| **Reviewer persona** | 資料可信度審核員、領域保守審核員 |

---

## 資料來源

| 來源 | URL | 格式 | 狀態 |
|------|-----|------|------|
| AMC/AIME — GitHub | https://github.com/ryanrudes/amc | JSON | ✅ 已驗證 |
| CEFR — UniversalCEFR | https://huggingface.co/UniversalCEFR | JSON | ✅ 已驗證 |
| CEFR-J 詞彙/語法 | https://github.com/openlanguageprofiles/olp-en-cefrj | CSV/JSON | ✅ 已驗證 |

---

## Category Enum

| 英文 key | 中文 | 判定條件 |
|----------|------|----------|
| `amc_math` | AMC 數學測評基準 | 來源為 AMC 8/10/12 或 AIME |
| `cefr_english` | CEFR 英語能力基準 | 來源為 CEFR A1-C2 框架 |

---

## 萃取邏輯

### AMC 數據格式

```json
{
  "competition": "AMC 8",
  "year": 2023,
  "problem_number": 1,
  "difficulty": "easy",
  "topics": ["arithmetic", "number sense"],
  "answer": "B"
}
```

萃取規則：
- `benchmark_id`：`{competition}-{year}-P{problem_number}`（如 `AMC8-2023-P1`）
- `difficulty_level`：使用 `difficulty` 欄位（easy/medium/hard）
- `skill_topics`：使用 `topics` 陣列

### CEFR 數據格式

```json
{
  "level": "B1",
  "descriptor": "Can understand the main points of clear standard input...",
  "domain": "reading",
  "can_do_statements": ["Can understand texts..."]
}
```

萃取規則：
- `benchmark_id`：`CEFR-{level}-{domain}`（如 `CEFR-B1-reading`）
- `level_descriptor`：使用 `descriptor` 欄位
- `can_do_statements`：使用 `can_do_statements` 陣列

---

## `[REVIEW_NEEDED]` 觸發規則

以下情況**必須**標記 `[REVIEW_NEEDED]`：

1. `difficulty` 欄位為非標準值（不是 easy/medium/hard）
2. `level` 欄位不在 A1-C2 範圍內
3. `topics` 或 `can_do_statements` 為空陣列
4. 同一 `benchmark_id` 有重複但內容不同的紀錄

以下情況**不觸發** `[REVIEW_NEEDED]`：

- ❌ 「題目無解答說明」— AMC 公開資料不含解答過程
- ❌ 「CEFR 描述較籠統」— 這是 CEFR 框架的特性

---

## 輸出格式

### AMC 基準輸出

```markdown
---
benchmark_id: AMC8-2023-P1
source_url: https://github.com/ryanrudes/amc
fetched_at: 2026-02-02T10:00:00Z
source_layer: assessment_benchmarks
benchmark_type: amc_math
difficulty_level: easy
grade_level: Grades 6-8
subject: Math
---

# AMC8-2023-P1

## Benchmark Information

- **Competition**: AMC 8
- **Year**: 2023
- **Problem Number**: 1
- **Difficulty**: Easy
- **Topics**: arithmetic, number sense

## Skill Indicators

This benchmark tests:
- Basic arithmetic operations
- Number sense and estimation

---

*來源：AMC Competition Archive*
```

### CEFR 基準輸出

```markdown
---
benchmark_id: CEFR-B1-reading
source_url: https://huggingface.co/UniversalCEFR
fetched_at: 2026-02-02T10:00:00Z
source_layer: assessment_benchmarks
benchmark_type: cefr_english
level: B1
domain: reading
subject: English
---

# CEFR-B1-reading

## Level Descriptor

Can understand the main points of clear standard input on familiar matters regularly encountered in work, school, leisure, etc.

## Can-Do Statements

- Can understand texts that consist mainly of high frequency everyday or job-related language
- Can understand the description of events, feelings and wishes in personal letters

---

*來源：Common European Framework of Reference for Languages*
```

---

## 自我審核 Checklist

輸出前必須確認：

- [ ] `benchmark_id` 格式正確且唯一
- [ ] `difficulty_level` 或 `level` 使用標準值
- [ ] 所有內容直接來自原始資料，無額外詮釋
- [ ] 無主觀的難度評價（如「這題很難」）
- [ ] 若觸發 REVIEW_NEEDED 條件，已在檔案開頭標記

---

End of assessment_benchmarks/CLAUDE.md
