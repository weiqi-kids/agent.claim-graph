# exam_threshold_map Mode

## Mode 可驗證性：Factual

---

## Mode 定義表

| 項目 | 內容 |
|------|------|
| **Mode name** | exam_threshold_map（考試門檻地圖） |
| **Verifiability** | Factual |
| **Purpose and audience** | 彙整各國考試的百分位門檻數據，供家長和自學者參考 |
| **Source layers** | assessment_benchmarks, peer_benchmarks |
| **Required disclaimer** | 無（Factual 模式不需警語） |
| **Reviewer persona** | 資料可信度審核員 |

---

## 資料來源定義

| 來源 | 路徑 | 用途 |
|------|------|------|
| 考試統計 | `docs/Narrator/benchmarks/score_standards/` | 各考試的百分位門檻 |
| 認知層次 | `docs/Narrator/benchmarks/cognitive_level/` | 題型分布 |

---

## 輸入參數

| 參數 | 必填 | 說明 |
|------|------|------|
| `exam_type` | ✅ | 考試類型（entrance / competition） |
| `exam_id` | ✅ | 考試識別碼（如 sat, gsat, amc） |
| `country` | ❌ | 國家代碼（省略則為全部） |

---

## 輸出框架

### 升學考試（entrance）

```markdown
---
mode: exam_threshold_map
verifiability: Factual
generated_at: {ISO8601}
parameters:
  exam_type: entrance
  exam_id: {exam_id}
source_layers:
  - assessment_benchmarks
---

# {考試名稱} 門檻數據

## 基本資訊

| 項目 | 內容 |
|------|------|
| 考試名稱 | {exam_name} |
| 主辦單位 | {organization} |
| 考試對象 | {target_audience} |
| 滿分 | {max_score} |
| 資料年度 | {year} |

## 百分位門檻

| 百分位 | 分數 | 說明 |
|--------|------|------|
| 前 50% | {score} | {description} |
| 前 25% | {score} | {description} |
| 前 10% | {score} | {description} |
| 前 1% | {score} | {description} |

## 歷年趨勢

| 年度 | 前 50% | 前 10% | 前 1% |
|------|--------|--------|-------|
| {year} | {score} | {score} | {score} |

## 資料來源

- {official_source_url}
- 資料擷取時間：{fetched_at}

---

*本報告由學生學習地圖系統自動產生*
```

### 數學競賽（competition）

```markdown
---
mode: exam_threshold_map
verifiability: Factual
generated_at: {ISO8601}
parameters:
  exam_type: competition
  exam_id: {exam_id}
source_layers:
  - assessment_benchmarks
---

# {競賽名稱} 門檻數據

## 基本資訊

| 項目 | 內容 |
|------|------|
| 競賽名稱 | {competition_name} |
| 主辦單位 | {organization} |
| 參賽對象 | {target_audience} |
| 滿分 | {max_score} |

## 入門門檻

> 「從零開始」準備此競賽需達到的基本水準

| 前置條件 | 說明 |
|----------|------|
| 數學程度 | {prerequisite_level} |
| 對應課綱 | {corresponding_curriculum} |

## 晉級/獎牌門檻

| 門檻 | 分數 | 百分位約 | 說明 |
|------|------|----------|------|
| 參賽 | — | — | {description} |
| 入門獎 | {score} | 前 50% | {description} |
| 晉級門檻 | {score} | 前 5% | {description} |
| 頂尖獎項 | {score} | 前 1% | {description} |

## 歷年門檻變化

| 年度 | 晉級門檻 | 變化 |
|------|----------|------|
| {year} | {score} | {change} |

## 資料來源

- {official_source_url}
- 資料擷取時間：{fetched_at}

---

*本報告由學生學習地圖系統自動產生*
```

---

## 輸出位置

```
docs/Narrator/exam_threshold_map/
├── index.md                    # 總覽頁面
├── entrance/                   # 升學考試
│   ├── taiwan-gsat.md         # 台灣學測
│   ├── us-sat.md              # 美國 SAT
│   ├── us-ap-calc.md          # 美國 AP Calculus
│   ├── china-gaokao.md        # 中國高考
│   ├── australia-naplan.md    # 澳洲 NAPLAN
│   └── uk-alevel.md           # 英國 A-Level
└── competition/                # 數學競賽
    ├── amc-aime.md            # AMC/AIME
    ├── imo.md                 # IMO
    ├── ukmt.md                # UKMT
    └── entry-thresholds.md    # 入門門檻總覽
```

---

## 產出規則

1. **只呈現數據**：不評論分數高低優劣
2. **來源標註**：每個數據都必須標明來源
3. **百分位優先**：優先使用百分位，其次使用絕對分數
4. **歷年對比**：盡量提供歷年數據以呈現趨勢
5. **入門門檻**：競賽類必須說明「從零開始」需要的前置條件

---

## 禁止行為

- 不可建議準備策略
- 不可評論考試難度優劣
- 不可比較不同考試（如「SAT 比學測難」）
- 不可預測未來門檻
- 不可推薦目標分數

---

## 自我審核 Checklist

輸出前必須確認：

- [ ] 所有門檻數據有官方來源
- [ ] 百分位計算方式已說明
- [ ] 歷年數據年份正確
- [ ] 無任何評價性用語
- [ ] 競賽類有入門門檻說明
- [ ] 資料來源 URL 可存取

---

End of exam_threshold_map/CLAUDE.md
