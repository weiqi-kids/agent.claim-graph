---
layout: default
title: 設計教訓
nav_order: 6
---

# 學生學習地圖系統 — 探索階段教訓紀錄

> 紀錄時間：2026-02-02
> 背景：嘗試將現有「產業智慧分析系統」架構改造為「各國學生學習地圖」智能體

---

## 一、架構層面的錯誤假設

### 1.1 資料源性質錯配

**問題**：原系統設計用於 RSS/API 公開資料 feed（如資安新聞），假設 `fetch.sh` 可以全自動抓取。但教育場景的 7 個 Layer 中，大部分是私人或非結構化資料。

**實際情況**：

| Layer | 原假設 | 實際情況 |
|-------|--------|----------|
| L1 孩子學習紀錄 | 可從平台 API 抓取 | 私人資料，需手動輸入或 OAuth 串接每個平台 |
| L2 機構公開資訊 | 可爬取 | 台灣補習班無結構化公開資料 |
| L3 同地區替代方案 | 可爬取 | 同 L2，且需地理定位邏輯 |
| L4 正規體系基準 | 可抓課綱 API | 台灣課綱只有 PDF/HTML，無 API |
| L5 標準化測評框架 | 可下載公開資料 | ✅ 正確假設，資料最充裕 |
| L6 同儕分布 | 可從平台取得 | 隱私敏感，幾乎不可能自動取得 |
| L7 身心負荷訊號 | 可自動收集 | 純主觀量表，必須手動填寫 |

**教訓**：在規劃 Layer 前，必須先驗證每個資料源的**實際可取得性**，不能只憑直覺假設。

---

### 1.2 過度樂觀的自動化程度估計

**問題**：原始規劃暗示系統可以「全自動執行」，但實際上：

- **7 層中只有 L4（部分）和 L5 接近可自動化**
- L1、L6、L7 本質上是「使用者輸入介面」，不是「資料擷取管線」
- L2、L3 在台灣場景下幾乎無法自動化

**教訓**：Layer 架構應該區分：
1. **自動抓取層**（fetch.sh 可運作）
2. **使用者輸入層**（需要表單/介面設計）
3. **平台串接層**（需要 OAuth 認證流程）

---

### 1.3 Mode 的本質誤判

**問題**：原系統的 Modes 是「彙整事實 + 標注趨勢」，事實來源明確。但提議的 8 個 Modes 中，多個屬於**教育諮詢判斷**：

| Mode | 類型 | 風險 |
|------|------|------|
| M1 差異地圖 | 事實比對 | ✅ 適合自動化 |
| M2 優勢判定 | 主觀判斷 | ⚠️ 「優勢是遷移能力還是超前進度」無法驗證 |
| M3 缺口與後果 | 推測+判斷 | ⚠️ 「影響機制」難以驗證 |
| M4 最短路徑 | 建議 | ⚠️ 需限定在「內容建議」而非「方法建議」 |
| M5 不勉強策略 | 教育心理諮詢 | ❌ 超出 AI 適合自動化的範圍 |
| M6 資源配置 | 花費決策 | ⚠️ 涉及財務建議，需人工介入 |
| M7 壓力控制 | 心理健康 | ❌ 需要專業資格才能給建議 |
| M8 追蹤迭代 | 指標追蹤 | ✅ 適合自動化 |

**教訓**：Mode 設計需要先通過「可驗證性」檢查，問：「這個輸出能被事實驗證嗎？」如果不能，就觸犯了系統規範的「不可產出無法驗證的專業外觀聲明」。

---

## 二、資料源層面的錯誤假設

### 2.1 台灣課綱沒有 API

**發現**：國教院（NAER）有 161 個資料集在 data.gov.tw，但**課綱本體是 PDF/HTML**，沒有結構化 API。

**正確做法**：
- 需要 WebFetch 抓取網頁 + 萃取邏輯
- 或者下載 PDF 後用 Claude 萃取
- 或者聯繫 NAER 詢問是否有結構化資料

---

### 2.2 Khan Academy API 已停用

**發現**：Khan Academy 公開 API 在 **2020 年 7 月 1 日** 停用，官方聲明不再提供外部開發者 API 存取。

**教訓**：驗證 API 時，必須確認：
1. API 是否仍然運作
2. 最後更新時間
3. 是否有棄用公告

---

### 2.3 IB 課綱是專有授權

**發現**：International Baccalaureate 課綱是專有內容，需要 IB World School 授權才能存取，無公開 API。

**教訓**：不是所有教育標準都是公開的，部分是商業授權模式。

---

### 2.4 均一平台 API 狀態不明

**發現**：均一有 `open-data-iot` 頁面，但搜尋結果無法確認是否有公開 API。Kaggle 上有學習行為資料集，但非課程結構資料。

**教訓**：對於台灣在地平台，需要直接訪問網站或聯繫平台確認，搜尋結果可能不完整。

---

### 2.5 APCS 台灣無 open data

**發現**：APCS（大學程式設計先修檢測）有歷屆考題 PDF 和 ZeroJudge 練習平台，但**沒有結構化能力指標 API**。

**教訓**：考試/認證系統的能力框架往往沒有結構化公開資料，只有 PDF 文件。

---

## 三、範圍層面的問題

### 3.1「各國」範圍太大

**問題**：「各國學生學習地圖」隱含要處理多國課綱體系，但每個國家的課綱結構完全不同：

- 台灣：十二年國教，科目能力指標
- 美國：Common Core（州級標準）
- 英國：National Curriculum（Key Stage）
- 新加坡：MOE Syllabus
- 日本：學習指導要領

**教訓**：應該先聚焦單一教育體系（例如台灣），驗證核心價值後再擴展。

---

### 3.2 補習班/機構資料是結構性盲區

**發現**：台灣補習班沒有公開結構化資料。L2/L3 在台灣場景下需要重新定義資料取得方式：
- 可能需要使用者手動輸入
- 或者爬取招生網頁後萃取
- 或者與機構合作取得

**教訓**：有些資料在結構上就不存在公開格式，需要設計替代取得方式。

---

## 四、建議的修正方向

### 4.1 先從資料最成熟的 Layer 開始

**優先順序**：
1. **L5 standardized_frameworks** — CEFR datasets (HuggingFace)、AMC/AIME (Kaggle/GitHub)、PISA 資料
2. **L4 school_system_benchmark** — 先做 US Common Core (API 最成熟)，再做台灣課綱萃取
3. **L6 peer_distribution** — PISA/TIMSS 下載檔、OECD API

### 4.2 重新分類 Layer 性質

```
自動抓取層（fetch.sh 可運作）：
  - L4 正規體系基準（部分）
  - L5 標準化測評框架

使用者輸入層（需要表單設計）：
  - L1 孩子學習紀錄
  - L7 身心負荷訊號

平台串接層（需要 OAuth 認證）：
  - L1 孩子學習紀錄（若用 Google Classroom/Canvas）

手動/爬取層（需要萃取邏輯）：
  - L2 機構公開資訊
  - L3 同地區替代方案
  - L4 台灣課綱
```

### 4.3 Mode 加上可驗證性邊界

```
事實比對類（適合自動化）：
  - M1 差異地圖
  - M8 追蹤迭代

需標註「AI 推論」類（需加警語）：
  - M2 優勢判定
  - M3 缺口與後果

降級為「選項列表」類（不做判斷，只列選項）：
  - M4 最短路徑 → 改為「可能的補強選項」
  - M5 不勉強策略 → 改為「低衝突選項清單」
  - M6 資源配置 → 改為「選項比較表」

不建議自動化類（改為 checklist）：
  - M7 壓力控制 → 改為「家長自評檢核清單」
```

---

## 五、關鍵資料源 URL 備忘

### 立即可用（已驗證）

| 資料源 | URL | 格式 |
|--------|-----|------|
| US Common Core — Common Standards Project API | https://www.commonstandardsproject.com/developers | JSON API |
| US Common Core — GitHub | https://github.com/SirFizX/standards-data | JSON |
| CEFR — UniversalCEFR | https://huggingface.co/UniversalCEFR | JSON |
| CEFR-J 詞彙/語法 | https://github.com/openlanguageprofiles/olp-en-cefrj | CSV/JSON |
| AMC/AIME — GitHub | https://github.com/ryanrudes/amc | 結構化 |
| AMC/AIME — Kaggle | https://www.kaggle.com/datasets/hemishveeraboina/aime-problem-set-1983-2024 | CSV |
| AoPS 題庫 — HuggingFace | https://huggingface.co/datasets/bigdata-pw/aops | JSON |
| PISA 資料 | https://www.oecd.org/en/about/programmes/pisa/pisa-data.html | SAS/SPSS/CSV |
| TIMSS 資料 | https://timssandpirls.bc.edu/ | 資料檔 |
| OECD Education API | https://data.oecd.org/api/ | JSON/XML |
| Google Classroom API | https://developers.google.com/classroom | JSON API |
| Canvas LMS API | https://www.canvas.instructure.com/doc/api/ | JSON API |

### 需萃取或驗證

| 資料源 | URL | 狀態 |
|--------|-----|------|
| 台灣課綱 — NAER | https://www.naer.edu.tw/PageSyllabus?fid=52 | PDF/HTML 需萃取 |
| 台灣 data.gov.tw 教育類 | https://data.gov.tw/datasets/agency/教育部 | 需進一步挖掘 |
| 均一平台 open data | https://www.junyiacademy.org/open-data-iot | 需驗證 |
| APCS 台灣 | https://apcs.csie.ntnu.edu.tw/ | 只有 PDF |

### 已確認不可用

| 資料源 | 原因 |
|--------|------|
| Khan Academy API | 2020/7/1 停用 |
| IB Curriculum | 專有授權 |

---

## 六、下次規劃時的檢查清單

在提出新的 Layer/Mode 前，對每一項回答：

### 資料源檢查
- [ ] 資料源 URL 是什麼？（不是「應該有」，而是實際 URL）
- [ ] 資料格式是什麼？（RSS/JSON/API/PDF/HTML）
- [ ] 是否需要認證？（公開/API key/OAuth/付費）
- [ ] 是否實際測試過 curl 或 fetch？
- [ ] API 最後更新時間？是否有棄用公告？

### 自動化程度檢查
- [ ] `fetch.sh` 能否直接抓取？
- [ ] 是否需要使用者輸入？
- [ ] 是否需要平台串接（OAuth）？
- [ ] 是否需要爬取+萃取？

### Mode 可驗證性檢查
- [ ] 輸出的每一個聲明能被事實驗證嗎？
- [ ] 如果不能驗證，是否屬於「教育諮詢」而非「資料彙整」？
- [ ] 是否涉及專業領域（心理、法律、財務）需要人工介入？
- [ ] 是否需要加上「此為 AI 推論」警語？

---

*本文件應隨專案演進持續更新*
