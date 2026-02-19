# 學生學習地圖系統

協助家長用**公開的課程標準與考試門檻**評估孩子的學習程度。

## 核心原則

- 只做「資料彙整」，不做「教育諮詢」
- 所有聲明必須有來源，不可憑空推測
- 不提供學習建議、策略、優劣勢評估
- 比較類分析必須加警語：「本比較僅呈現數據差異，不構成評估建議」

---

## 網站

**URL**：https://learn.weiqi.kids/

```
docs/
├── index.md                     # 首頁（含四類受眾入口）
├── explored.md                  # 資料源探索紀錄
├── update-log.md                # 更新日誌（快取判斷用）
├── for-parents/                 # 家長專區
│   └── index.md
├── for-learners/                # 自學者專區
│   ├── index.md
│   ├── competition-entry.md     # 競賽入門門檻
│   └── standardized-tests.md    # SAT/AP 參考
├── for-educators/               # 教育工作者專區
│   ├── index.md
│   └── standard-ids.md          # 標準 ID 索引
├── for-researchers/             # 研究者專區
│   ├── index.md
│   ├── data-sources.md          # 資料來源登記冊
│   └── pisa-data.md             # PISA 統計數據
└── Narrator/
    ├── exam-analysis.md         # 考試分析（舊版，保留）
    ├── methodology.md           # 方法論說明
    ├── exam_threshold_map/      # 考試門檻（Mode）
    │   ├── index.md             # 總覽
    │   ├── entrance/            # 升學考試
    │   │   ├── taiwan-gsat.md   # 學測
    │   │   └── us-sat.md        # SAT
    │   └── competition/         # 數學競賽
    │       ├── amc-aime.md      # AMC/AIME
    │       ├── ukmt.md          # UKMT
    │       └── entry-thresholds.md  # 入門門檻總覽
    └── skill_alignment_map/     # 年級技能標準（Mode）
        ├── index.md             # 索引
        ├── Grade-4-Math.md      # 美國 Grade 4
        ├── Grade-8-Math.md      # 美國 Grade 8
        ├── Taiwan*.md           # 台灣（3 頁）
        ├── Singapore*.md        # 新加坡（3 頁）
        ├── UK*.md               # 英國（3 頁）
        ├── Japan*.md            # 日本（3 頁）
        ├── Canada*.md           # 加拿大（3 頁）
        └── Australia*.md        # 澳洲（3 頁）
```

---

## 資料來源

### 已驗證可用

| 資料源 | URL | 用途 |
|--------|-----|------|
| 🇺🇸 College Board | https://research.collegeboard.org/reports/sat-suite | SAT、AP 分數統計 |
| 🇺🇸 MAA | https://maa.org/math-competitions | AMC/AIME 競賽資料 |
| 🇹🇼 大考中心 | https://www.ceec.edu.tw | 學測統計資料 |
| 🇸🇬 MOE Singapore | https://www.moe.gov.sg | 新加坡數學課綱 |
| 🇯🇵 MEXT | https://www.mext.go.jp | 日本課程指引 |
| 🇬🇧 UKMT | https://www.ukmt.org.uk | 英國數學競賽資料 |
| 🇦🇺 ACARA | https://www.acara.edu.au | 澳洲 NAPLAN 統計 |
| 🇨🇦 Ontario | https://www.ontario.ca/page/math-curriculum-grades-1-8 | 加拿大課綱 |
| 🌍 IMO Official | https://www.imo-official.org | 國際數學奧林匹亞 |
| 🌍 OECD PISA | https://www.oecd.org/pisa | 國際學生評量 |

### 已確認不可用

| 資料源 | 原因 |
|--------|------|
| Common Standards Project API | 頁面僅有 JavaScript，無 API 端點 |
| 台灣課綱 JSON/API | 官方僅提供 PDF 格式 |

詳見 `docs/explored.md`。

---

## SEO 規則

本專案遵循 `seo/CLAUDE.md` 的 SEO/AEO 優化標準。

### 適用的 Schema

| Schema | 用途 | 說明 |
|--------|------|------|
| WebPage + Speakable | 每個頁面 | 必填 |
| Article | 文章頁面 | 必填，citations 連結到「已驗證可用」的資料源 |
| Organization | 網站資訊 | 必填 |
| BreadcrumbList | 導覽路徑 | 必填 |
| FAQPage | 常見問題 | 考試門檻頁面適用 |
| Table | 比較表格 | 跨國比較適用 |
| ItemList | 排名清單 | 競賽排名適用 |

### 不適用的 Schema

本專案為資料彙整型網站，以下 Schema **不使用**：

- `Person`（無個人作者，以資料來源為權威）
- `Recipe`、`Product`、`LocalBusiness`、`Event`、`Course`（非此類內容）
- `Review`（不做評價）

### 觸發時機

當使用者說「SEO 優化」或「檢查 SEO」時：
1. 讀取 `seo/CLAUDE.md` 了解完整規則
2. 使用 Writer 角色（`seo/writer/CLAUDE.md`）產出優化建議
3. 使用 Reviewer 角色（`seo/review/CLAUDE.md`）檢查輸出

### Jekyll 整合

- JSON-LD 透過 `docs/_includes/head_custom.html` 注入
- Meta 標籤由 `jekyll-seo-tag` 插件處理
- 每個頁面的 front matter 需包含 `description` 欄位

---

## 執行完整流程

當使用者說「執行完整流程」時：

### 1. 讀取快取狀態

讀取 `docs/update-log.md` 和 `docs/explored.md`：
- 跳過 7 天內已更新的資料類型
- 跳過「已確認不可用」的資料源

### 2. 更新現有資料

對於需要更新的項目，用 WebSearch 並行搜尋：

| 資料類型 | 搜尋關鍵字 | 對應頁面 |
|----------|------------|----------|
| SAT 門檻 | `SAT {年份} percentile scores` | exam_threshold_map/entrance/us-sat.md |
| 學測門檻 | `學測 {年份} 級分 人數百分比` | exam_threshold_map/entrance/taiwan-gsat.md |
| AMC/AIME | `AMC 10 12 {年份} cutoff scores` | exam_threshold_map/competition/amc-aime.md |
| UKMT | `UKMT {年份} thresholds` | exam_threshold_map/competition/ukmt.md |
| PISA | `PISA {年份} mathematics results` | for-researchers/pisa-data.md |
| 美國課綱 | `Common Core Grade {N} Math standards` | skill_alignment_map/Grade-{N}-Math.md |
| 台灣課綱 | `十二年國教 數學 {年級}` | skill_alignment_map/Taiwan-*.md |
| 新加坡課綱 | `Singapore MOE Math syllabus` | skill_alignment_map/Singapore-*.md |
| 英國課綱 | `UK National Curriculum Maths` | skill_alignment_map/UK-*.md |
| 日本課綱 | `MEXT 学習指導要領 算数 数学` | skill_alignment_map/Japan-*.md |
| 加拿大課綱 | `Ontario Math Curriculum` | skill_alignment_map/Canada-*.md |
| 澳洲課綱 | `Australian Curriculum Mathematics` | skill_alignment_map/Australia-*.md |

若搜尋結果與現有資料不同，更新對應頁面。

### 3. 搜集新資料

主動搜尋可補充的資料，新發現記錄到 `docs/explored.md`。

### 4. 產出見解

基於收集到的資料產出分析（跨考試比較、門檻變化趨勢等），每個結論必須標註來源。

### 5. 提交變更

```bash
git add docs/ && git commit -m "chore: update reports (YYYY-MM-DD)" && git push
```

更新 `docs/update-log.md` 的對應日期。

### 6. 驗證部署

等待 GitHub Actions 完成後，用 WebFetch 驗證各頁面（加 `?v=日期` 避免快取）。

---

### 7. 品質關卡檢查

**全部通過才能視為流程成功完成。**

---

## 品質關卡

### 1. 連結檢查

- [ ] 所有新增/修改的內部連結正常，無 404
- [ ] 所有新增/修改的外部連結正常
- [ ] 無死連結或斷裂連結

### 2. SEO + AEO 標籤檢查

#### 2.1 Meta 標籤

- [ ] `<title>` 存在且 ≤ 60 字，含核心關鍵字
- [ ] `<meta name="description">` 存在且 ≤ 155 字
- [ ] `og:title`, `og:description`, `og:image`, `og:url` 存在
- [ ] `og:type` = "article"
- [ ] `article:published_time`, `article:modified_time` 存在（ISO 8601 格式）
- [ ] `twitter:card` = "summary_large_image"

#### 2.2 JSON-LD Schema（本專案必填）

| Schema | 必填欄位 |
|--------|----------|
| WebPage | speakable（至少 7 個 cssSelector） |
| Article | isAccessibleForFree, isPartOf（含 SearchAction）, significantLink, citations |
| Organization | contactPoint, logo（含 width/height） |
| BreadcrumbList | position 從 1 開始連續編號 |
| FAQPage | 3-5 個 Question + Answer（考試門檻頁面） |
| ItemList | itemListElement（競賽排名頁面） |

> **注意**：本專案不使用 Person、Recipe、Product、LocalBusiness、Event、Course、Review Schema。

#### 2.3 條件式 Schema（依內容判斷）

| Schema | 觸發條件 | 必填欄位 |
|--------|----------|----------|
| HowTo | 有步驟教學 | step, totalTime |
| VideoObject | 有嵌入影片 | duration, thumbnailUrl |
| Table | 有比較表格 | 跨國比較適用 |

#### 2.4 E-E-A-T 信號

- [ ] Article Schema 的 citations 連結到「已驗證可用」的資料源
- [ ] 至少 2 個高權威外部連結（.gov、學術期刊、專業協會）

> **注意**：本專案以資料來源為權威，不使用個人作者（Person Schema）。

### 3. 內容更新確認

- [ ] 列出本次預計修改的所有檔案
- [ ] 逐一確認每個檔案都已正確更新
- [ ] 修改內容與任務要求一致
- [ ] 無遺漏項目
- [ ] 比較類分析已加警語：「本比較僅呈現數據差異，不構成評估建議」

### 4. Git 狀態檢查

- [ ] 所有變更已 commit
- [ ] commit message 清楚描述本次變更
- [ ] 已 push 到 Github（除非另有指示）
- [ ] 遠端分支已更新

### 5. SOP 完成度檢查

- [ ] 回顧原始任務需求
- [ ] 原訂 SOP 每個步驟都已執行（步驟 1-6）
- [ ] 無遺漏的待辦項目
- [ ] 無「之後再處理」的項目

---

## 回報格式

完成「執行完整流程」後，輸出以下格式：

```
## 執行結果

### 更新現有資料
- 課程標準：{跳過（X 天前更新）/ 無更新 / 已更新}
- 考試門檻：{跳過（X 天前更新）/ 無更新 / 已更新}

### 新增資料
- {列出項目，或「無」}

### 新增見解
- {列出項目，或「無」}

### 部署驗證

**受眾入口**
- 首頁：✅/❌
- 家長專區：✅/❌
- 自學者專區：✅/❌
- 教育工作者專區：✅/❌
- 研究者專區：✅/❌

**考試門檻**
- 總覽：✅/❌
- SAT：✅/❌
- 學測：✅/❌
- AMC/AIME：✅/❌

**課綱頁面（抽驗）**
- 美國 Grade-4-Math：✅/❌
- 台灣 Grade-4-Math：✅/❌
- 日本/加拿大/澳洲（任一）：✅/❌

### 品質關卡檢查

| 類別 | 狀態 | 問題（如有） |
|------|------|-------------|
| 連結檢查 | ✅/❌ | |
| Meta 標籤 | ✅/❌ | |
| Schema（必填） | ✅/❌ | |
| Schema（條件式） | ✅/❌/N/A | |
| E-E-A-T 信號 | ✅/❌ | |
| 內容更新 | ✅/❌ | |
| Git 狀態 | ✅/❌ | |
| SOP 完成度 | ✅/❌ | |

**總結**：X/Y 項通過，狀態：通過/未通過

### 需人工處理
- {列出項目，或「無」}
```

---

## 品質關卡未通過時

1. **不回報完成**
2. 列出所有未通過項目
3. 立即修正問題
4. 重新執行檢查
5. 全部通過才能說「完成」
