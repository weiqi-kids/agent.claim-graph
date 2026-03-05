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
    └── skill_alignment_map/     # 年齡帶學習地圖（Mode）
        ├── index.md             # 年齡帶總覽
        ├── age-6-9.md           # 6-9 歲（國小低年級）
        ├── age-9-12.md          # 9-12 歲（國小中高年級，7 國比較）
        ├── age-12-15.md         # 12-15 歲（國中，7 國比較）
        ├── age-15-18.md         # 15-18 歲（高中，競賽+考試）
        └── age-18-plus.md       # 18 歲以上（AP、NAPLAN）
```

---

## 資料來源

### 已驗證可用

| 資料源 | URL | 用途 |
|--------|-----|------|
| 🇺🇸 College Board | https://research.collegeboard.org/reports/sat-suite | SAT、AP 分數統計 |
| 🇺🇸 MAA | https://maa.org/student-programs/amc/ | AMC/AIME 競賽資料 |
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

## 網站改版流程

當需要進行**結構性改版**（非日常更新）時，使用 `revamp/` 目錄的完整流程。

### 觸發條件

使用者說以下關鍵字時，啟動改版流程：

- 「網站改版」、「revamp」
- 「品牌定位」、「重新定位」
- 「競品分析」
- 「內容策略」、「內容規劃」
- 「全面健檢」、「網站診斷」

### 流程總覽

```
0-Positioning → 1-Discovery → 2-Competitive → 3-Analysis → 4-Strategy → 5-Content-Spec → 執行 → Final-Review
     ↓              ↓             ↓              ↓            ↓              ↓                       ↓
  Review ✓      Review ✓      Review ✓      Review ✓     Review ✓       Review ✓                Review ✓
```

### 各階段說明

| 階段 | 目的 | 輸出 | 參照文件 |
|------|------|------|----------|
| **0-positioning** | 釐清品牌定位、核心價值 | 定位文件 | `revamp/0-positioning/CLAUDE.md` |
| **1-discovery** | 盤點現有內容 + 技術健檢 | 健檢報告 + KPI | `revamp/1-discovery/CLAUDE.md` |
| **2-competitive** | 分析競爭對手 | 競品分析報告 | `revamp/2-competitive/CLAUDE.md` |
| **3-analysis** | 受眾分析 + 內容差距 | 差距分析報告 | `revamp/3-analysis/CLAUDE.md` |
| **4-strategy** | 改版計劃 + 優先級排序 | 改版計劃書 | `revamp/4-strategy/CLAUDE.md` |
| **5-content-spec** | 每頁內容規格 | 內容規格書 | `revamp/5-content-spec/CLAUDE.md` |
| **final-review** | 驗收執行結果 | 驗收報告 | `revamp/final-review/CLAUDE.md` |

### 執行方式

每個階段包含 Writer 和 Reviewer 兩個角色：

```bash
# 執行階段
請以 Writer 角色，參照 revamp/[階段]/CLAUDE.md 執行

# 檢查輸出
請以 Reviewer 角色，參照 revamp/[階段]/review/CLAUDE.md 檢查輸出
```

### 自動化工具

`revamp/tools/` 提供網站健檢和競品分析腳本：

| 工具 | 用途 | 指令 |
|------|------|------|
| site-audit.sh | 完整網站健檢 | `./revamp/tools/site-audit.sh https://example.com` |
| competitive-audit.sh | 競品比較分析 | `./revamp/tools/competitive-audit.sh [我們] [競品1] [競品2]` |

**檢測項目**：
- Lighthouse（效能、SEO、Accessibility、Best Practices）
- 安全性（Mozilla Observatory、SSL Labs、HTTP Headers）
- SEO 基礎（W3C 驗證、robots.txt、sitemap）

### 單一階段執行

可以單獨執行特定階段，不必跑完整流程：

```bash
# 只做技術健檢
請以 Writer 角色，參照 revamp/1-discovery/CLAUDE.md 執行網站健檢

# 只做競品分析
請以 Writer 角色，參照 revamp/2-competitive/CLAUDE.md 執行競品分析
```

### 與日常流程的差異

| 項目 | 日常更新（執行完整流程） | 改版流程（revamp） |
|------|--------------------------|-------------------|
| 目的 | 更新現有資料 | 結構性重構 |
| 頻率 | 定期（7 天一次） | 需要時 |
| 範圍 | 資料內容更新 | 定位、結構、內容策略 |
| 輸出 | 更新日誌 | 完整規劃文件 |

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
| 課綱（6-9 歲） | `Common Core Grade 1-3 Math standards` | skill_alignment_map/age-6-9.md |
| 課綱（9-12 歲） | `Common Core Grade 4-6`, `十二年國教 數學 四年級`, `Singapore P4 Math`, `UK Year 5 Maths`, `MEXT 算数 四年`, `Ontario Grade 4 Math`, `ACARA Year 4 Math` | skill_alignment_map/age-9-12.md |
| 課綱（12-15 歲） | `Common Core Grade 7-8`, `十二年國教 數學 八年級`, `Singapore S2 Math`, `UK Year 8 Maths`, `MEXT 数学 中二`, `Ontario Grade 8 Math`, `ACARA Year 8 Math` | skill_alignment_map/age-12-15.md |
| 課綱（15-18 歲） | 各國高中數學概覽 | skill_alignment_map/age-15-18.md |
| 課綱（18+ 歲） | AP Calculus, NAPLAN | skill_alignment_map/age-18-plus.md |

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

### 7. 網站健檢與優化掃描

執行輕量級健檢，識別優化方向：

#### 7.1 技術健檢

```bash
# 使用 PageSpeed API 快速檢測
curl -s "https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url=https://learn.weiqi.kids/&strategy=mobile" | jq '{
  performance: (.lighthouseResult.categories.performance.score * 100),
  seo: (.lighthouseResult.categories.seo.score * 100),
  accessibility: (.lighthouseResult.categories.accessibility.score * 100),
  lcp: .lighthouseResult.audits["largest-contentful-paint"].displayValue,
  cls: .lighthouseResult.audits["cumulative-layout-shift"].displayValue
}'
```

#### 7.2 評估標準

| 指標 | 良好 | 需改善 | 差 |
|------|------|--------|-----|
| Performance | ≥ 90 | 50-89 | < 50 |
| SEO | ≥ 90 | 50-89 | < 50 |
| LCP | < 2.5s | 2.5-4s | > 4s |
| CLS | < 0.1 | 0.1-0.25 | > 0.25 |

#### 7.3 優化建議觸發條件

| 條件 | 建議行動 |
|------|----------|
| Performance < 50 | 建議執行 `revamp/1-discovery` 完整健檢 |
| SEO < 70 | 檢查 Schema 和 Meta 標籤 |
| LCP > 4s | 檢查圖片優化和載入策略 |
| 連續 3 次健檢分數下降 | 建議啟動完整 revamp 流程 |

#### 7.4 記錄健檢結果

將健檢數據記錄到 `docs/update-log.md`，用於追蹤趨勢。

---

### 8. 品質關卡檢查

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

### 4. 網站健檢

- [ ] 執行 PageSpeed 檢測（Mobile）
- [ ] Performance 分數 ≥ 50（⚠️ < 50 需檢視）
- [ ] SEO 分數 ≥ 70
- [ ] 與上次檢測比較，無重大退步（> 10 分下降）
- [ ] 記錄數據到 update-log.md

### 5. Git 狀態檢查

- [ ] 所有變更已 commit
- [ ] commit message 清楚描述本次變更
- [ ] 已 push 到 Github（除非另有指示）
- [ ] 遠端分支已更新

### 6. SOP 完成度檢查

- [ ] 回顧原始任務需求
- [ ] 原訂 SOP 每個步驟都已執行（步驟 1-7）
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

**年齡帶學習地圖（抽驗）**
- 9-12 歲（7 國比較）：✅/❌
- 12-15 歲（7 國比較）：✅/❌
- 6-9 歲 / 15-18 歲（任一）：✅/❌

### 網站健檢

| 指標 | 數值 | 上次數值 | 變化 | 評價 |
|------|------|----------|------|------|
| Performance | | | ↑/↓/→ | ✅/⚠️/❌ |
| SEO | | | | |
| Accessibility | | | | |
| LCP | | | | |
| CLS | | | | |

### 優化建議

| 優先級 | 建議 | 觸發原因 |
|--------|------|----------|
| P0 | {或「無」} | |
| P1 | | |
| P2 | | |

**是否建議啟動 revamp？** ✅ 是 / ❌ 否
- 原因：{說明}

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
| 網站健檢 | ✅/⚠️/❌ | |
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
