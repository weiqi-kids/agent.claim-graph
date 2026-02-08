# 學生學習地圖系統

協助家長用**公開的課程標準與考試門檻**評估孩子的學習程度。

## 核心原則

- 只做「資料彙整」，不做「教育諮詢」
- 所有聲明必須有來源，不可憑空推測
- 不提供學習建議、策略、優劣勢評估
- 比較類分析必須加警語：「本比較僅呈現數據差異，不構成評估建議」

---

## 網站

**URL**：https://weiqi-kids.github.io/agent.claim-graph/

```
docs/
├── index.md                     # 首頁
├── explored.md                  # 資料源探索紀錄
├── update-log.md                # 更新日誌（快取判斷用）
└── Narrator/
    ├── exam-analysis.md         # 考試分析（門檻+題型+範例）
    ├── methodology.md           # 方法論說明
    └── skill_alignment_map/
        ├── index.md             # 年級技能標準索引
        ├── Grade-4-Math.md      # 國小四年級數學
        └── Grade-8-Math.md      # 國中二年級數學
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
| 考試門檻 | `{考試} {年份} statistics percentile` | exam-analysis.md |
| 課程標準 | `Common Core Grade {N} Math standards` | skill_alignment_map/ |

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

## 回報格式

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
- 首頁：✅/❌
- 考試分析：✅/❌
- 方法論：✅/❌
- Grade-4-Math：✅/❌
- Grade-8-Math：✅/❌

### 需人工處理
- {列出項目，或「無」}
```
