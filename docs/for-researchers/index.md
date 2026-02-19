---
layout: default
title: 研究者專區
nav_order: 13
has_children: true
description: 資料來源索引、PISA 統計數據、資料可追溯性說明。
---

# 研究者專區

資料來源索引、PISA 統計數據、資料可追溯性說明。

---

## 快速導覽

### 1. 已驗證資料來源

本系統使用的所有資料均來自以下已驗證的官方來源：

#### 課程標準

| 國家 | 資料來源 | 官方連結 | 資料格式 |
|------|----------|----------|----------|
| 🇺🇸 美國 | Common Core State Standards | [corestandards.org](http://www.corestandards.org/) | HTML |
| 🇹🇼 台灣 | 十二年國民基本教育課程綱要 | [naer.edu.tw](https://www.naer.edu.tw/) | PDF |
| 🇸🇬 新加坡 | MOE Mathematics Syllabus | [moe.gov.sg](https://www.moe.gov.sg/) | PDF |
| 🇬🇧 英國 | National Curriculum | [gov.uk](https://www.gov.uk/national-curriculum) | HTML |
| 🇯🇵 日本 | MEXT 學習指導要領 | [mext.go.jp](https://www.mext.go.jp/) | PDF |
| 🇨🇦 加拿大 | Ontario Math Curriculum | [ontario.ca](https://www.ontario.ca/page/math-curriculum-grades-1-8) | HTML |
| 🇦🇺 澳洲 | Australian Curriculum | [australiancurriculum.edu.au](https://www.australiancurriculum.edu.au/) | HTML |

#### 考試統計

| 考試 | 資料來源 | 官方連結 | 資料格式 |
|------|----------|----------|----------|
| SAT | College Board | [research.collegeboard.org](https://research.collegeboard.org/reports/sat-suite) | PDF |
| AP | College Board | [collegeboard.org](https://apcentral.collegeboard.org/) | PDF |
| 學測 | 大考中心 | [ceec.edu.tw](https://www.ceec.edu.tw/) | HTML |
| AMC/AIME | MAA | [maa.org](https://maa.org/math-competitions) | HTML |
| UKMT | UKMT | [ukmt.org.uk](https://www.ukmt.org.uk/) | HTML |
| IMO | IMO Official | [imo-official.org](https://www.imo-official.org/) | HTML |

#### 國際評量

| 評量 | 資料來源 | 官方連結 | 最新年度 |
|------|----------|----------|----------|
| PISA | OECD | [oecd.org/pisa](https://www.oecd.org/pisa) | 2022 |
| TIMSS | IEA | [timssandpirls.bc.edu](https://timssandpirls.bc.edu/) | 2019 |
| NAPLAN | ACARA | [acara.edu.au](https://www.acara.edu.au/) | 2023 |

---

### 2. PISA 2022 統計數據

#### 數學素養排名（部分）

| 排名 | 國家/地區 | 平均分數 |
|------|-----------|----------|
| 1 | 新加坡 | 575 |
| 2 | 澳門 | 552 |
| 3 | 台灣 | 547 |
| 4 | 香港 | 540 |
| 5 | 日本 | 536 |
| 6 | 韓國 | 527 |
| — | OECD 平均 | 472 |

> 資料來源：[OECD PISA 2022 Results](https://www.oecd.org/pisa/publications/pisa-2022-results.htm)

---

### 3. 資料更新紀錄

| 資料類型 | 上次更新 | 下次檢查 |
|----------|----------|----------|
| 課程標準 | 2026-02-18 | 2026-02-25 |
| 考試門檻 | 2026-02-18 | 2026-02-25 |
| 題庫資料 | 2026-02-08 | 2026-02-15 |

→ [查看完整更新日誌](../update-log)

---

### 4. 已確認不可用的資料源

以下資料源經評估後確認不可用：

| 資料源 | 原因 |
|--------|------|
| Common Standards Project API | 頁面僅有 JavaScript，無 API 端點 |
| 台灣課綱 JSON/API | 官方僅提供 PDF 格式 |

→ [查看完整探索紀錄](../explored)

---

### 5. 引用格式

如需引用本系統的資料，建議格式：

```
學生學習地圖系統. (2026). {頁面標題}.
取自 https://learn.weiqi.kids/{路徑}
```

---

## 方法論

本系統的分析方法說明：

- **資料擷取**：從官方來源提取結構化資料
- **Bloom 分類**：依 Bloom's Taxonomy 分類題目認知層次
- **跨國對照**：基於年齡和技能領域進行對應

→ [完整方法論說明](../Narrator/methodology)

---

## 重要說明

> **本系統只做「資料彙整」，不做「教育諮詢」。**
>
> 所有資料來自公開來源。統計數據僅供參考，不構成評估建議。
