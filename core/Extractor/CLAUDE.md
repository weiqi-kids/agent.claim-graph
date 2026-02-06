# Extractor 角色說明 + 通用規則

## 角色定位

Extractor 負責資料擷取（fetch）與萃取（extract），由 `core/Extractor/Layers/` 下的 Layer 定義控制。

---

## Layer 類型系統

### 四種 Layer 類型

| 類型 | fetch.sh | 特性 | 範例 |
|------|----------|------|------|
| **Auto-Fetch** | ✅ 有 | 公開 API/RSS，每次執行都會更新 | US Common Core API |
| **Static-Knowledge** | ✅ 有（條件性） | 下載後長期使用，raw/ 有資料時跳過 fetch | PISA/AMC 資料集 |
| **User-Input** | ❌ 無 | 使用者手動上傳 JSON 到 raw/ | 孩子學習檔案 |
| **Platform-OAuth** | ❌ 無（需 token） | 需要 OAuth 認證的平台 API | Google Classroom |

### 執行邏輯

```python
if layer.type == "Auto-Fetch":
    run fetch.sh
    run extraction
    run update.sh

elif layer.type == "Static-Knowledge":
    if raw_dir is empty:
        run fetch.sh
    run extraction
    run update.sh

elif layer.type == "User-Input":
    if raw_dir has json files:
        validate json against schema.json
        run extraction
        run update.sh
    else:
        skip and notify user

elif layer.type == "Platform-OAuth":
    if oauth_token is valid:
        run fetch.sh (with token)
        run extraction
        run update.sh
    else:
        skip and notify user to re-authorize
```

---

## 萃取通用規則

### 1. JSONL 處理

**禁止**直接用 Read 工具讀取 `.jsonl` 檔案。

正確流程：
```bash
# 取得總行數
wc -l < {jsonl_file}

# 逐行讀取
sed -n '1p' {jsonl_file}  # 第 1 行
sed -n '2p' {jsonl_file}  # 第 2 行
```

### 2. 輸出格式

每個萃取的 .md 檔必須包含：

```markdown
---
standard_id: {ID}
source_url: {URL}
fetched_at: {ISO8601}
source_layer: {layer_name}
grade_level: {年級}
subject: {科目}
skill_domain: {技能領域}
---

# {標題}

{內容}
```

### 3. 去重規則

萃取前檢查 `docs/Extractor/{layer}/` 下是否已存在相同 `standard_id` 的 .md 檔：
- 若存在且來源相同 → 跳過
- 若存在但內容更新 → 覆蓋

### 4. `[REVIEW_NEEDED]` 標記

子代理必須**嚴格遵循**各 Layer CLAUDE.md 的觸發規則，不可自行擴大判定範圍。

以下情況**不可**自行標記：
- 「僅單一來源」（這是結構性限制，用 confidence 欄位反映）
- 「欄位為空」（資料來源本身不提供該欄位）

---

## 與 Qdrant 整合

update.sh 執行時：
1. 讀取新產生的 .md 檔
2. 生成 embedding（透過 lib/chatgpt.sh）
3. 寫入 Qdrant（透過 lib/qdrant.sh）
4. 以 `source_url` + `standard_id` 去重

Payload 必要欄位：
- `source_url`
- `fetched_at`
- `source_layer`
- `standard_id`
- `grade_level`
- `subject`
- `skill_domain`

---

## 審核角色

Extractor 適用的審核人設：

- **資料可信度審核員**：來源是否為官方 API、是否可追溯
- **幻覺風險審核員**：萃取是否新增了原始資料沒有的內容
- **邏輯一致性審核員**：年級、科目對應是否正確

---

End of Extractor/CLAUDE.md
