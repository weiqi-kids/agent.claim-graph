# skill_alignment_map Mode

## Mode 可驗證性：Factual

---

## Mode 定義表

| 項目 | 內容 |
|------|------|
| **Mode name** | skill_alignment_map（技能對照地圖） |
| **Verifiability** | Factual |
| **Purpose and audience** | 為家長呈現特定年級/科目的課綱標準清單 |
| **Source layers** | L1 standards_frameworks |
| **Required disclaimer** | 無（Factual 模式不需警語） |
| **Reviewer persona** | 資料可信度審核員、邏輯一致性審核員 |

---

## 資料來源定義

從 `docs/Extractor/standards_frameworks/` 讀取：
- `us_common_core_math/*.md` — 數學標準
- `us_common_core_ela/*.md` — 英語標準

---

## 輸入參數

報告產出時需要指定：

| 參數 | 必填 | 說明 |
|------|------|------|
| `subject` | ✅ | 科目（Math / ELA） |
| `grade_level` | ✅ | 年級（Grade 3, Grade 4, ...） |

---

## 輸出框架

```markdown
---
mode: skill_alignment_map
verifiability: Factual
generated_at: {ISO8601}
parameters:
  subject: {subject}
  grade_level: {grade_level}
source_layers:
  - standards_frameworks
---

# {grade_level} {subject} 技能對照地圖

## 資料來源

本報告的所有內容來自：
- [Common Standards Project](https://www.commonstandardsproject.com)
- 資料擷取時間：{fetched_at}

## 技能領域總覽

| Domain | Standard Count |
|--------|----------------|
| {domain_1} | {count} |
| {domain_2} | {count} |
| ... | ... |

## 詳細標準列表

### {Domain 1}

| Standard ID | Statement |
|-------------|-----------|
| {id} | {statement} |
| ... | ... |

### {Domain 2}

| Standard ID | Statement |
|-------------|-----------|
| {id} | {statement} |
| ... | ... |

---

*本報告由學生學習地圖系統自動產生*
*資料來源：US Common Core State Standards*
```

---

## 輸出位置

`docs/Narrator/skill_alignment_map/{grade_level}-{subject}.md`

範例：`docs/Narrator/skill_alignment_map/Grade-3-Math.md`

---

## 產出規則

1. **只呈現事實**：直接從 Layer 資料提取，不做任何詮釋
2. **保持原文**：Standard Statement 保持英文原文
3. **完整引用**：每個標準都必須標明 Standard ID
4. **按領域分組**：依 `skill_domain` 欄位分組
5. **來源標註**：明確標註資料來源和擷取時間

---

## 禁止行為

- 不可添加學習建議（如「建議先學 X 再學 Y」）
- 不可評論難度（如「這是較簡單的標準」）
- 不可比較不同年級（如「比 Grade 2 進階」）
- 不可推測學習順序

---

## 自我審核 Checklist

輸出前必須確認：

- [ ] 所有 Standard ID 與來源一致
- [ ] Statement 完整引用，無任何改寫
- [ ] 按 Domain 正確分組
- [ ] 來源 URL 和擷取時間已標註
- [ ] 無任何學習建議或主觀評論
- [ ] 檔名符合規範

---

End of skill_alignment_map/CLAUDE.md
