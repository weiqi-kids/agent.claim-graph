# 學生學習地圖系統

## 系統目的

協助家長用**公開的課程標準與考試門檻**評估孩子的學習程度。

**核心原則**：
- 只做「資料彙整」，不做「教育諮詢」
- 所有聲明必須有來源，不可憑空推測
- 用公開基準（考試門檻、課程標準）作為參考點

---

## 網站結構

```
docs/
├── index.md                              # 首頁
└── Narrator/
    ├── skill_alignment_map/
    │   ├── index.md                      # 年級技能標準索引
    │   ├── Grade-4-Math.md               # 國小四年級數學
    │   └── Grade-8-Math.md               # 國中二年級數學
    ├── exam-analysis.md                  # 各國考試分析（門檻+題型+範例）
    └── methodology.md                    # 方法論說明
```

**網站 URL**：https://weiqi-kids.github.io/agent.claim-graph/

---

## 執行完整流程

當使用者說「執行完整流程」時，依序執行以下步驟：

### 步驟零：檢查快取與跳過邏輯

**在開始前先執行**：

1. **讀取 `docs/explored.md`**，取得「已確認不可用」清單，後續步驟跳過這些來源
2. **讀取 `docs/update-log.md`**，檢查各資料類型的上次更新日期：
   - 若距今 **< 7 天**：跳過該項檢查（顯示「跳過：X 天前已更新」）
   - 若距今 **≥ 7 天**：正常執行檢查

### 步驟一：更新現有資料

檢查現有資料是否有更新（遵循步驟零的跳過邏輯）：

| 資料類型 | 檢查方式 | 對應頁面 |
|----------|----------|----------|
| **課程標準** | 查詢 Common Standards Project API 是否有新版本 | Grade-4-Math, Grade-8-Math |
| **考試門檻** | 搜尋各國最新考試統計（學測、SAT、高考、UKMT、AMC） | exam-analysis.md |
| **題庫資料** | 檢查 HuggingFace datasets 更新日期 | exam-analysis.md |

**已驗證資料源**：

| 資料源 | URL | 用途 |
|--------|-----|------|
| Common Standards Project | https://www.commonstandardsproject.com | 美國 Common Core 課程標準 |
| College Board | https://collegereadiness.collegeboard.org/sat/scores | SAT 分數統計 |
| 大考中心 | https://www.ceec.edu.tw | 學測統計資料 |
| UKMT | https://www.ukmt.org.uk | 英國數學競賽資料 |
| AMC/MAA | https://maa.org/math-competitions | 美國數學競賽資料 |

執行方式：
1. 用 WebSearch 搜尋「{考試名稱} {年份} 統計」
2. 用 WebFetch 抓取官方資料
3. 比對現有數據，若有更新則更新對應頁面

### 步驟二：搜集更多資料

主動搜尋可補充的資料：

| 搜尋目標 | 搜尋關鍵字 | 歸類到 |
|----------|------------|--------|
| **更多年級** | "Common Core Grade {N} Math standards" | skill_alignment_map/ |
| **更多考試** | "{考試名稱} percentile scores statistics" | exam-analysis.md |
| **更多題目範例** | "{考試名稱} sample questions {認知層次}" | exam-analysis.md |
| **台灣課綱** | "十二年國教 數學 課程綱要" | 新增頁面 |

執行方式：
1. 用 WebSearch 搜尋上述關鍵字
2. 驗證資料來源可信度（官方 > 學術 > 媒體）
3. 萃取有用資訊，歸類到對應頁面
4. 新資料記錄到 `docs/explored.md`

### 步驟三：提出見解與結論

基於收集到的資料，嘗試產出新的分析：

| 分析類型 | 說明 | 產出位置 |
|----------|------|----------|
| **跨考試比較** | 同一認知層次在不同考試的表現差異 | exam-analysis.md |
| **年級對應** | 各國課程標準的年級對應關係 | methodology.md 或新頁面 |
| **題型趨勢** | 近年考試題型分布變化 | exam-analysis.md |
| **門檻變化** | 考試門檻的年度變化趨勢 | exam-analysis.md |

**產出原則**：
- 每個結論必須標註資料來源
- 比較類分析必須加警語：「本比較僅呈現數據差異，不構成評估建議」
- 不可提供學習建議或策略

### 步驟四：更新網站

1. **更新報告**
   - 修改對應的 `.md` 檔案
   - 更新頁面頂部的「更新時間」和「分析題數」
   - 確保所有表格格式正確

2. **更新 `docs/update-log.md`**（供步驟零使用）
   - 記錄本次更新的資料類型與日期
   - 格式見下方「更新日誌格式」

3. **提交變更**
   ```bash
   git status
   git add docs/
   git commit -m "chore: update reports (YYYY-MM-DD)"
   git push origin main
   ```

3. **等待部署**
   - GitHub Actions 自動建置 Jekyll
   - 部署到 GitHub Pages

### 步驟五：驗證連結

部署完成後，驗證所有頁面連結：

1. **用 WebFetch 檢查每個頁面**
   ```
   https://weiqi-kids.github.io/agent.claim-graph/
   https://weiqi-kids.github.io/agent.claim-graph/Narrator/skill_alignment_map/Grade-4-Math
   https://weiqi-kids.github.io/agent.claim-graph/Narrator/skill_alignment_map/Grade-8-Math
   https://weiqi-kids.github.io/agent.claim-graph/Narrator/exam-analysis
   https://weiqi-kids.github.io/agent.claim-graph/Narrator/methodology
   ```

2. **檢查項目**
   - 頁面是否正常載入（非 404）
   - 頁面內的連結是否都能點擊
   - 表格是否正確渲染

3. **修復問題**
   - 若有 404，檢查檔案路徑和 front matter
   - 若有斷連，更新連結指向

---

## 執行回報格式

完成後回報：

```
## 執行完整流程結果

### 步驟一：更新現有資料
- [ ] 課程標準：{有更新/無更新}
- [ ] 考試門檻：{有更新/無更新}
- [ ] 題庫資料：{有更新/無更新}

### 步驟二：搜集更多資料
- 新增資料：{列出新增的資料項目}
- 更新 explored.md：{是/否}

### 步驟三：新增見解
- {列出新增的分析或結論}

### 步驟四：網站更新
- 修改檔案：{列出修改的檔案}
- Git commit：{commit hash}
- 部署狀態：{成功/失敗}

### 步驟五：連結驗證
- [ ] 首頁：{✅/❌}
- [ ] 國小四年級數學：{✅/❌}
- [ ] 國中二年級數學：{✅/❌}
- [ ] 考試分析：{✅/❌}
- [ ] 方法論說明：{✅/❌}

### 需要人工處理
- {列出無法自動處理的項目}
```

---

## 禁止行為

1. **不可提供教育諮詢** — 不給學習建議、策略、優劣勢評估
2. **不可無中生有** — 所有數據必須有來源
3. **不可假設資料存在** — 先驗證 URL 可達再使用
4. **不可混淆推測與事實** — 推測必須明確標註

---

## 資料來源記錄

所有新發現的資料源記錄到 `docs/explored.md`，格式：

```markdown
## YYYY-MM-DD 探索紀錄

### 已驗證可用
| 資料源 | URL | 格式 | 用途 |
|--------|-----|------|------|
| {名稱} | {URL} | {格式} | {用途} |

### 已確認不可用
| 資料源 | 原因 |
|--------|------|
| {名稱} | {原因} |
```

---

## 更新日誌格式

`docs/update-log.md` 用於追蹤各資料類型的最後更新日期，供步驟零判斷是否跳過：

```markdown
---
nav_exclude: true
---

# 更新日誌

| 資料類型 | 上次更新 | 下次檢查 |
|----------|----------|----------|
| 課程標準 | 2026-02-06 | 2026-02-13 |
| 考試門檻 | 2026-02-08 | 2026-02-15 |
| 題庫資料 | 2026-02-04 | 2026-02-11 |
```

**規則**：
- 「下次檢查」= 上次更新 + 7 天
- 若今天 < 下次檢查，跳過該項
- 若有實際更新，更新「上次更新」欄位

---

End of CLAUDE.md
