# 學生學習地圖系統 — 初始 Prompt v3

## 一、系統概覽

### 1.1 系統目的

本系統是一套圍繞 Claude CLI 運作的學生學習地圖系統，透過多角色協作完成教育標準資料擷取、萃取、學習分析報告生成與品質審核。

**核心價值**：協助家長了解孩子在各學習標準框架下的進度位置，提供可驗證的事實比對，**不提供教育諮詢或專業判斷**。

### 1.2 架構角色

| 角色 | 職責 | 實現方式 |
|------|------|----------|
| **Architect** | 系統巡檢、資料源探索、指揮協調 | 由 Claude CLI 頂層直接扮演（無外部腳本） |
| **Extractor** | 資料擷取（fetch）與萃取（extract） | `core/Extractor/Layers/` 下的 Layer 定義 + shell 腳本 |
| **Narrator** | 跨來源綜合分析、報告產出 | `core/Narrator/Modes/` 下的 Mode 定義 |
| **Reviewer** | 自我審核 Checklist | 內嵌於每個 Layer/Mode 的 CLAUDE.md |

### 1.3 資料流

```
外部資料源（API/Dataset/UserInput）
  → fetch.sh 下載原始資料 → docs/Extractor/{layer}/raw/*.jsonl
  → Claude 萃取（逐行處理）→ docs/Extractor/{layer}/{category}/*.md
  → update.sh 寫入 Qdrant + 檢查 REVIEW_NEEDED
  → Narrator Mode 讀取 Layer 資料 → docs/Narrator/{mode}/*.md
```

### 1.4 地理與科目範圍

| 維度 | Phase 1-2 | Phase 3-4 |
|------|-----------|-----------|
| **地理** | US Common Core | + 台灣十二年國教 |
| **科目** | 數學 | + 英語（CEFR）、程式（APCS） |

> **設計決策**：US 資料源 API 最成熟（Common Standards Project），台灣課綱需 PDF 萃取，技術複雜度較高，放在後期。

---

## 二、Layer 類型系統

### 2.1 四種 Layer 類型

本系統的 Layer 依資料取得方式分為四種類型：

| 類型 | fetch.sh | 說明 | 適用場景 |
|------|----------|------|----------|
| **Auto-Fetch** | ✅ 有 | 公開 API/RSS，可全自動抓取 | US Common Core API |
| **Static-Knowledge** | ✅ 有（一次性或定期） | 下載後長期使用的資料集 | PISA/AMC/AoPS 題庫 |
| **User-Input** | ❌ 無 | 需要使用者手動輸入的資料 | 孩子學習檔案、身心量表 |
| **Platform-OAuth** | ❌ 無 | 需要 OAuth 串接的平台資料 | Google Classroom |

### 2.2 Layer CLAUDE.md 必須宣告類型

每個 Layer 的 CLAUDE.md **開頭**必須宣告：

```markdown
## Layer 類型：{Auto-Fetch | Static-Knowledge | User-Input | Platform-OAuth}
```

### 2.3 各類型的執行差異

| 類型 | 步驟二執行內容 |
|------|----------------|
| **Auto-Fetch** | fetch.sh → 萃取 → update.sh（完整流程） |
| **Static-Knowledge** | 若 raw/ 為空則 fetch.sh，否則跳過 fetch → 萃取 → update.sh |
| **User-Input** | 跳過 fetch.sh → 直接讀取 raw/ 下使用者上傳的 JSON → 萃取 → update.sh |
| **Platform-OAuth** | 檢查 OAuth token 有效性 → fetch.sh（帶 token）→ 萃取 → update.sh |

---

## 三、Mode 可驗證性系統

### 3.1 三種可驗證性等級

| 等級 | 說明 | 輸出風格 | 是否需要警語 |
|------|------|----------|-------------|
| **Factual** | 所有聲明可追溯到來源 | 有來源標註的斷言 | 否 |
| **Comparative** | 基於事實的比較分析 | 表格/比較，不做價值判斷 | 是：「本比較僅呈現數據差異，不構成評估建議」 |
| **Advisory** | 提供選項但不做推薦 | Checklist / 選項列表 | 是：「本清單僅供參考，請依專業判斷選擇」 |

### 3.2 Mode CLAUDE.md 必須宣告等級

每個 Mode 的 CLAUDE.md **開頭**必須宣告：

```markdown
## Mode 可驗證性：{Factual | Comparative | Advisory}
```

### 3.3 禁止的 Mode 類型

以下類型**不可**實作為 Mode，已在設計階段移除：

| 原規劃 | 移除原因 |
|--------|---------|
| 優勢判定（advantage_diagnosis） | 涉及主觀判斷，無法驗證 |
| 不勉強策略（no_force_strategy） | 需要教育心理專業資格 |
| 壓力控制（stress_budget_controller） | 需要心理健康專業資格 |

> **原則**：系統只做「資料彙整」，不做「教育諮詢」。

---

## 四、執行編排模型

### 4.1 編排架構

本系統由 **Claude CLI 全程編排**，透過 Task tool 分派子代理執行各步驟。

```
頂層 Claude CLI（Opus）
├── Task(Bash, sonnet)     → 目錄掃描、fetch.sh、update.sh
├── Task(general-purpose, sonnet) → Layer 萃取（需 Write tool 寫 .md 檔）
└── Task(general-purpose, opus)   → Mode 報告產出（需跨來源綜合分析）
```

### 4.2 模型與子代理指派規則

| 步驟 | 任務類型 | 指定模型 | 子代理類型 | 原因 |
|------|----------|----------|------------|------|
| 步驟一 | 動態發現所有 Layer | `sonnet` | `Bash` | 純目錄掃描，無需推理 |
| 步驟二 | fetch.sh 執行 | `sonnet` | `Bash` | 純腳本執行 |
| 步驟二 | Layer 萃取 | `sonnet` | `general-purpose` | 需用 Write 工具寫 .md 檔 |
| 步驟二 | update.sh 執行 | `sonnet` | `Bash` | 純腳本執行 |
| 步驟三 | 動態發現所有 Mode | `sonnet` | `Bash` | 純目錄掃描，無需推理 |
| 步驟四 | Mode 報告產出 | `opus` | `general-purpose` | 需要跨來源綜合分析 |

> **強制規則**：只有步驟四（Mode 報告產出）使用 `opus`，其餘所有步驟一律使用 `sonnet`。

### 4.3 平行分派策略

- JSONL 萃取可平行分派多個 Task（例如：20 筆 JSONL 可一次分派 10 個 Task）
- 多個 Layer 的 fetch.sh 可平行執行（彼此獨立）
- Mode 報告產出依序執行（後一 Mode 可能依賴前一 Mode 的輸出）

---

## 五、執行流程

使用者說「執行完整流程」或「更新資料」時，依照以下步驟執行：

### 步驟一：動態發現所有 Layer

掃描 `core/Extractor/Layers/*/`，排除含有 `.disabled` 檔案的目錄。
讀取每個 Layer 的 `CLAUDE.md` 取得 Layer 類型。

### 步驟二：逐一執行 Layer（依類型）

對每個 Layer 依其類型執行：

**Auto-Fetch 類型**：
1. fetch.sh → 下載原始資料到 `docs/Extractor/{layer}/raw/`
2. 萃取 → 逐行處理 JSONL，輸出 `.md` 檔
3. update.sh → 寫入 Qdrant + REVIEW_NEEDED 檢查

**Static-Knowledge 類型**：
1. 檢查 `docs/Extractor/{layer}/raw/` 是否有資料
2. 若無資料，執行 fetch.sh 下載
3. 萃取 + update.sh

**User-Input 類型**：
1. 檢查 `docs/Extractor/{layer}/raw/` 是否有使用者上傳的 JSON
2. 若無資料，跳過此 Layer 並提示使用者
3. 若有資料，驗證 JSON Schema → 萃取 → update.sh

**Platform-OAuth 類型**：
1. 檢查 OAuth token 有效性
2. 若 token 無效，跳過此 Layer 並提示使用者重新授權
3. 若 token 有效，fetch.sh（帶 token）→ 萃取 → update.sh

### 步驟三：動態發現所有 Mode

掃描 `core/Narrator/Modes/*/`，排除含有 `.disabled` 檔案的目錄。

### 步驟四：逐一執行 Mode

對每個 Mode 依序執行：
1. 讀取該 Mode 的 `CLAUDE.md` 和 `core/Narrator/CLAUDE.md`
2. 讀取 CLAUDE.md 中宣告的來源 Layer 資料
3. 依照輸出框架產出報告到 `docs/Narrator/{mode_name}/`

### 指定執行

使用者也可以指定執行特定 Layer 或 Mode：

- 「執行 standards_frameworks」→ 只跑該 Layer
- 「執行 skill_alignment_map」→ 只跑該 Mode 的報告產出

---

## 六、JSONL 處理規範

### 6.1 禁止行為

> **⛔ 禁止使用 Read 工具直接讀取 `.jsonl` 檔案**
> JSONL 檔案可能數百 KB 至數 MB，直接讀取會超出 token 上限。

### 6.2 正確流程

```
✅ 用 `wc -l < {jsonl_file}` 取得總行數
✅ 用 `sed -n '{N}p' {jsonl_file}` 逐行讀取（N = 1, 2, 3, ...）
✅ 每行獨立交由一個 Task 子代理處理
✅ 子代理透過 Write tool 寫出 .md 檔（不用 Bash heredoc）
```

### 6.3 萃取前去重

在萃取前，檢查 `docs/Extractor/{layer_name}/` 下是否已存在相同 ID 的 `.md` 檔：
- 若存在且內容相同，**跳過**該筆
- 若存在但內容不同，依 Layer 策略決定**覆蓋**或**保留兩版**

---

## 七、`[REVIEW_NEEDED]` 標記規範

### 7.1 統一原則

| 概念 | 含義 | 標記方式 |
|------|------|----------|
| `[REVIEW_NEEDED]` | 萃取結果**可能有誤**，需要人工確認 | 在 .md 檔開頭加上 |
| `confidence: 低` | 資料來源有**結構性限制** | 在 confidence 欄位反映 |

### 7.2 子任務合規

- 子任務必須**嚴格遵循** Layer CLAUDE.md 定義的觸發規則
- 不可因「僅單一來源」而自行標記 REVIEW_NEEDED
- 不可因「欄位為空」（資料來源本身不提供該欄位）而標記 REVIEW_NEEDED

---

## 八、目錄結構

### 8.1 完整結構

```
agent.claim-graph/
├── CLAUDE.md                              # 執行入口（Claude CLI 自動載入）
├── README.md                              # 專案說明 + 健康度儀表板
├── .env                                   # 環境設定（不入版控）
├── .gitignore
│
├── core/
│   ├── CLAUDE.md                          # 系統維護指令
│   ├── Architect/
│   │   └── CLAUDE.md                      # Architect 角色說明
│   ├── Extractor/
│   │   ├── CLAUDE.md                      # Extractor 通用規則 + Layer 類型定義
│   │   └── Layers/
│   │       ├── standards_frameworks/      # L1 Auto-Fetch
│   │       ├── assessment_benchmarks/     # L2 Static-Knowledge
│   │       ├── problem_banks/             # L3 Static-Knowledge
│   │       ├── child_profile/             # L4 User-Input
│   │       ├── platform_records/          # L5 Platform-OAuth
│   │       ├── peer_benchmarks/           # L6 Static-Knowledge
│   │       └── wellbeing_signals/         # L7 User-Input
│   └── Narrator/
│       ├── CLAUDE.md                      # Narrator 通用規則 + 可驗證性定義
│       └── Modes/
│           ├── skill_alignment_map/       # M1 Factual
│           ├── gap_identification/        # M2 Comparative
│           ├── resource_options/          # M3 Factual (list)
│           ├── progress_tracker/          # M4 Factual
│           ├── peer_context/              # M5 Comparative
│           └── load_summary/              # M6 Factual
│
├── lib/
│   ├── args.sh                            # 參數解析工具
│   ├── core.sh                            # 核心工具函式
│   ├── time.sh                            # 時間/日期工具
│   ├── rss.sh                             # RSS 擷取與解析
│   ├── chatgpt.sh                         # OpenAI API 呼叫
│   ├── qdrant.sh                          # Qdrant 向量資料庫操作
│   ├── huggingface.sh                     # HuggingFace datasets 下載
│   ├── kaggle.sh                          # Kaggle datasets 下載（Phase 2）
│   ├── schema.sh                          # JSON Schema 驗證（Phase 2）
│   └── oauth.sh                           # OAuth token 管理（Phase 3）
│
├── docs/
│   ├── explored.md                        # 資料源探索紀錄
│   ├── lessons-learned-student-learning-map.md
│   ├── Extractor/
│   │   └── {layer_name}/
│   │       ├── raw/                       # 原始資料
│   │       └── {category}/                # 萃取結果
│   └── Narrator/
│       └── {mode_name}/
│           └── {報告檔名}.md
│
└── .github/
    └── workflows/
        └── build-index.yml
```

### 8.2 lib/ 說明

| 檔案 | 用途 | Phase |
|------|------|-------|
| `args.sh` | 命令列參數解析 | 1 |
| `core.sh` | 通用工具函式 | 1 |
| `time.sh` | 時間與日期計算 | 1 |
| `rss.sh` | RSS 下載與轉換 | 1 |
| `chatgpt.sh` | OpenAI API 呼叫 | 1 |
| `qdrant.sh` | Qdrant 向量資料庫 | 1 |
| `huggingface.sh` | HuggingFace datasets 下載 | 1 |
| `kaggle.sh` | Kaggle datasets 下載 | 2 |
| `schema.sh` | JSON Schema 驗證 | 2 |
| `oauth.sh` | OAuth token 管理 | 3 |

---

## 九、Layer 建立規範

### 9.1 Layer 定義表

新增 Layer 時必須確認以下每一欄：

| 項目 | 說明 |
|------|------|
| **Layer name** | 中英文名稱 |
| **Layer type** | Auto-Fetch / Static-Knowledge / User-Input / Platform-OAuth |
| **Engineering function** | 這個 Layer 的工程職責 |
| **Data sources** | 資料來源 URL 列表（已驗證） |
| **Update frequency** | 更新頻率（每日/每週/手動/一次性） |
| **Output value** | 產出的價值 |
| **Category enum** | 固定分類清單（英文 key + 中文 + 判定條件） |
| **Reviewer persona** | 從審核人設池中選擇 |

### 9.2 Layer CLAUDE.md 必備內容

1. **Layer 類型宣告**（開頭）
2. **Layer 定義表**
3. **執行指令** — 萃取邏輯與輸出格式
4. **分類規則（enum）** — 固定值清單 + 判定條件
5. **`[REVIEW_NEEDED]` 觸發規則**
6. **輸出格式** — Markdown 模板
7. **自我審核 Checklist**

### 9.3 fetch.sh 模板（Auto-Fetch / Static-Knowledge）

```bash
#!/bin/bash
# {layer_name} 資料擷取腳本

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

source "$PROJECT_ROOT/lib/args.sh"
source "$PROJECT_ROOT/lib/core.sh"

LAYER_NAME="{layer_name}"
RAW_DIR="$PROJECT_ROOT/docs/Extractor/$LAYER_NAME/raw"

mkdir -p "$RAW_DIR"

# === 資料擷取邏輯 ===

echo "Fetch completed: $LAYER_NAME"
```

### 9.4 User-Input Layer 特殊檔案

User-Input 類型的 Layer **不含** fetch.sh，但必須包含：

```
{layer_name}/
├── CLAUDE.md
├── schema.json        # JSON Schema 定義使用者輸入格式
└── update.sh
```

使用者將 JSON 檔案放入 `docs/Extractor/{layer_name}/raw/` 後，執行萃取流程會：
1. 驗證 JSON 符合 schema.json
2. 萃取 JSON 為 .md 檔
3. 執行 update.sh

---

## 十、Mode 建立規範

### 10.1 Mode 定義表

新增 Mode 時必須確認以下每一欄：

| 項目 | 說明 |
|------|------|
| **Mode name** | 中英文名稱 |
| **Verifiability** | Factual / Comparative / Advisory |
| **Purpose and audience** | 報告目的與目標受眾 |
| **Source layers** | 讀取哪些 Layer 的資料 |
| **Required disclaimer** | 若為 Comparative/Advisory，必須包含的警語 |
| **Reviewer persona** | 從審核人設池中選擇 |

### 10.2 Mode CLAUDE.md 必備內容

1. **可驗證性宣告**（開頭）
2. **Mode 定義表**
3. **資料來源定義**
4. **輸出框架**
5. **免責聲明**（若為 Comparative/Advisory）
6. **輸出位置**
7. **自我審核 Checklist**

---

## 十一、系統規範

### 11.1 審核人設池

| 審核人設 | 關注重點 |
|----------|----------|
| 資料可信度審核員 | 來源是否一手、是否可驗證 |
| 幻覺風險審核員 | AI 是否產生無中生有的內容 |
| 領域保守審核員 | 是否符合教育領域的專業標準 |
| 邏輯一致性審核員 | 前後陳述是否矛盾 |
| 使用者誤導風險審核員 | 是否可能造成誤解 |
| 自動化邊界審核員 | 是否超出適合自動化的範圍 |

### 11.2 Qdrant 設定

- Collection 和向量維度設定在 .env
- 距離：Cosine
- Payload 必要欄位：
  - `source_url`、`fetched_at`、`source_layer`
  - `standard_id`（標準 ID，如 CCSS.MATH.3.OA.A.1）
  - `grade_level`（年級）
  - `subject`（科目）
  - `skill_domain`（技能領域）

### 11.3 禁止行為

1. 不可產出無法驗證的「專業外觀」聲明 — 所有聲明必須有來源
2. 不可提供教育諮詢、心理建議、醫療建議
3. 不可跳過審核層 — 每個輸出必須經過自我審核 checklist
4. 不可混淆推測與事實 — 推測必須明確標註
5. 不可自行新增 category enum 值
6. 不可使用 Read 工具直接讀取 `.jsonl` 檔案
7. 不可自行擴大 `[REVIEW_NEEDED]` 判定範圍

---

## 十二、已驗證資料源

### 立即可用

| 資料源 | URL | 格式 | 對應 Layer |
|--------|-----|------|------------|
| US Common Core — Common Standards Project | https://www.commonstandardsproject.com/developers | JSON API | L1 |
| US Common Core — GitHub | https://github.com/SirFizX/standards-data | JSON | L1 |
| CEFR — UniversalCEFR | https://huggingface.co/UniversalCEFR | JSON | L2 |
| AMC/AIME — GitHub | https://github.com/ryanrudes/amc | 結構化 | L2 |
| AMC/AIME — Kaggle | https://www.kaggle.com/datasets/hemishveeraboina/aime-problem-set-1983-2024 | CSV | L3 |
| AoPS 題庫 — HuggingFace | https://huggingface.co/datasets/bigdata-pw/aops | JSON | L3 |
| PISA 資料 | https://www.oecd.org/en/about/programmes/pisa/pisa-data.html | SAS/SPSS/CSV | L6 |
| Google Classroom API | https://developers.google.com/classroom | JSON API | L5 |

### 已確認不可用

| 資料源 | 原因 |
|--------|------|
| Khan Academy API | 2020/7/1 停用 |
| IB Curriculum | 專有授權 |

---

## 十三、環境設定

執行前需確認 `.env` 包含以下設定：

```
QDRANT_URL=...
QDRANT_API_KEY=...
QDRANT_COLLECTION=...
EMBEDDING_MODEL=...
EMBEDDING_DIMENSION=...
OPENAI_API_KEY=sk-...

# Phase 2+
KAGGLE_USERNAME=...
KAGGLE_KEY=...

# Phase 3+
GOOGLE_CLIENT_ID=...
GOOGLE_CLIENT_SECRET=...
```

---

## 十四、互動規則

完成執行後，簡要回報：

1. 各 Layer 擷取與萃取結果（筆數、有無 REVIEW_NEEDED）
2. 各 Mode 報告產出狀態
3. 是否有錯誤或需要人工介入的項目
4. 是否有 User-Input Layer 缺少資料

---

## 十五、健康度儀表板

README.md 中的系統健康度表格：

| Layer | 類型 | 最後更新 | 資料筆數 | 狀態 |
|-------|------|----------|----------|------|
| {Layer 名稱} | {類型} | {YYYY-MM-DD} | {N} | {✅/⚠️/❌} |

| Mode | 可驗證性 | 最後產出 | 狀態 |
|------|----------|----------|------|
| {Mode 名稱} | {等級} | {YYYY-MM-DD} | {✅/⚠️/❌} |

---

## 十六、實作階段

### Phase 1（Foundation）

**目標**：用最可靠的資料源驗證架構

**實作**：
- L1 `standards_frameworks`（僅 US Common Core）
- L2 `assessment_benchmarks`（PISA/AMC）
- M1 `skill_alignment_map`
- M2 `gap_identification`

**驗收標準**：
- 可產生 US Common Core Math 3-8 年級的技能對照表
- 所有資料來源可追溯

### Phase 2（Problem Banks + User Input）

- L3 `problem_banks`（AoPS + AMC/AIME）
- L4 `child_profile`（JSON 上傳）
- M3 `resource_options`
- M4 `progress_tracker`

### Phase 3（Platform + Peer Context）

- L5 `platform_records`（Google Classroom OAuth）
- L6 `peer_benchmarks`
- M5 `peer_context`

### Phase 4（Wellbeing + Taiwan）

- L7 `wellbeing_signals`
- L1 擴展：台灣課綱 PDF 萃取
- M6 `load_summary`

---

## 十七、設計決策與教訓

> 本節記錄探索階段（2026-02-02）學到的教訓，避免未來重蹈覆轍。

### 17.1 資料源驗證規則

**教訓**：不可假設資料源存在，必須先驗證再規劃。

在規劃任何 Layer 之前，必須完成以下檢查清單：

| 檢查項目 | 說明 | 範例 |
|----------|------|------|
| ✅ URL 存在且可達 | `curl -I {url}` 確認 200 | Khan API → 404 |
| ✅ 格式已確認 | RSS/JSON/API/PDF/CSV | 台灣課綱 → PDF |
| ✅ 認證需求已知 | 公開/API Key/OAuth/付費 | IB → 專有授權 |
| ✅ API 仍在運作 | 檢查 deprecation notice | Khan API → 2020 停用 |
| ✅ 實際測試過 fetch | 不只看文件，要實際抓取 | - |

**反例**：原規劃假設「可以從學習平台 API 抓取學習紀錄」，但實際上：
- Khan Academy API 已於 2020/7/1 停用
- IB Curriculum 是專有授權
- 台灣課綱只有 PDF，沒有 API

### 17.2 Layer 類型分類

**教訓**：不是所有資料都能自動抓取，必須依取得方式分類。

原系統設計假設所有 Layer 都有 `fetch.sh`，但教育場景中：
- **只有 2/7 的 Layer 可以全自動**（L1 部分、L2）
- **3/7 需要使用者輸入**（L4、L5、L7）
- **2/7 需要手動處理**（L3 Kaggle 需帳號、L6 PISA 需下載）

因此建立四種 Layer 類型：

```
Auto-Fetch      → 公開 API，可全自動
Static-Knowledge → 下載一次，長期使用
User-Input      → 使用者手動輸入
Platform-OAuth  → 需要 OAuth 串接
```

### 17.3 Mode 可驗證性邊界

**教訓**：AI 系統不可產出「看起來專業但無法驗證」的內容。

原規劃的 8 個 Mode 中，有 3 個被移除：

| 原 Mode | 問題 | 處置 |
|---------|------|------|
| advantage_diagnosis | 「優勢是遷移能力還是超前進度」無法客觀驗證 | 移除 |
| no_force_strategy | 涉及教育心理專業，AI 不應該給建議 | 移除 |
| stress_budget_controller | 涉及心理健康，需要專業資格 | 移除 |

**可驗證性分類原則**：

```
Factual     → 每個聲明都能指向具體來源
Comparative → 只呈現數據差異，不做價值判斷
Advisory    → 只列選項，不做推薦
```

**絕對禁止**：
- 提供「學習建議」或「學習策略」
- 評估孩子的「優勢」或「劣勢」
- 預測「如果不改善會怎樣」
- 任何需要教育/心理專業資格才能做的判斷

### 17.4 地理範圍策略

**教訓**：「各國」範圍太大，應從單一體系開始。

原規劃想做「各國學生學習地圖」，但每個國家的課綱結構完全不同：
- 美國：Common Core（州級標準）
- 英國：National Curriculum（Key Stage）
- 台灣：十二年國教
- 日本：學習指導要領

**正確策略**：

```
Phase 1-2 → US Common Core（API 最成熟）
Phase 4   → 台灣十二年國教（需要 PDF 萃取，技術複雜）
未來      → 其他國家（待驗證資料源）
```

### 17.5 科目優先順序

**教訓**：從資料可得性最高的科目開始。

| 科目 | 資料可得性 | 可驗證性 | 優先順序 |
|------|-----------|---------|---------|
| 數學 | 最高（AMC/AoPS/Common Core） | 高（客觀答案） | ⭐ 第一 |
| 英語 | 中高（CEFR datasets） | 中（有主觀成分） | 第二 |
| 程式 | 低（APCS 無結構化資料） | 中 | 最後 |

### 17.6 架構演化原則

**教訓**：架構應該能適應不同領域，但每個領域需要重新驗證假設。

本系統從「產業智慧分析系統」演化而來，原設計適合：
- 公開、結構化、持續更新的資料源（如資安新聞 RSS）

但**不適合**：
- 私有、非結構化、一次性的資料源（如教育機構資料）

**演化時必須重新驗證**：
1. 資料源的實際可得性（不是「應該有」，而是「確實有」）
2. 自動化程度的可行性（不是「理論上可以」，而是「實際能做」）
3. 輸出的可驗證性（不是「看起來合理」，而是「能追溯來源」）

### 17.7 新增 Layer/Mode 前的強制檢查

在提出新的 Layer 或 Mode 之前，必須回答以下問題：

**Layer 檢查**：
```
□ 資料源 URL 是什麼？（具體 URL，不是「應該有」）
□ 已實際測試 curl/fetch 嗎？
□ 資料格式是什麼？（RSS/JSON/API/PDF）
□ 是否需要認證？什麼類型？
□ API 最後更新時間？有無 deprecation 公告？
□ 這是哪種 Layer 類型？（Auto-Fetch/Static-Knowledge/User-Input/Platform-OAuth）
```

**Mode 檢查**：
```
□ 輸出的每個聲明能追溯到具體來源嗎？
□ 如果不能驗證，是否屬於「專業諮詢」而非「資料彙整」？
□ 是否涉及需要專業資格的領域？（心理/教育/法律/財務）
□ 這是哪種可驗證性等級？（Factual/Comparative/Advisory）
□ 如果是 Comparative/Advisory，警語內容是什麼？
```

---

End of CLAUDE.md
