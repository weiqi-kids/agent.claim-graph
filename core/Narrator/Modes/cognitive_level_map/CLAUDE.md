# cognitive_level_map Mode

## Mode 可驗證性：Factual

## Mode 定義

| 項目 | 內容 |
|------|------|
| **Mode 名稱** | cognitive_level_map（認知層次地圖） |
| **目的** | 分析題庫中各題目的 Bloom 認知層次分布 |
| **產出價值** | 了解「練習品質」而非只看數量 |
| **資料來源** | 所有 Phase 1 Layer 的題目 |
| **執行頻率** | 每學期一次 |

---

## Bloom 認知層次分類

### 六個層次定義

| 層次 | 英文 | 定義 | 關鍵動詞 | 範例題型 |
|------|------|------|----------|----------|
| **1. 記憶** | Remember | 回憶事實、術語、概念 | 列出、定義、辨認、背誦 | 「下列何者為質數？」 |
| **2. 理解** | Understand | 解釋意義、轉換表達 | 解釋、摘要、舉例、分類 | 「請解釋畢氏定理的意義」 |
| **3. 應用** | Apply | 將知識用於新情境 | 計算、解決、執行、使用 | 「求此三角形的面積」 |
| **4. 分析** | Analyze | 拆解結構、找出關係 | 比較、對照、區分、推論 | 「比較兩種解法的優劣」 |
| **5. 評鑑** | Evaluate | 判斷、批評、驗證 | 評估、辯護、判斷、批評 | 「此證明是否正確？為什麼？」 |
| **6. 創造** | Create | 產生新想法、設計方案 | 設計、發明、建構、規劃 | 「設計一個滿足條件的函數」 |

### 分類規則

```python
def classify_bloom_level(question_text, answer_type, has_solution_steps):
    """
    分類單一題目的 Bloom 層次

    輸入：
    - question_text: 題目文字
    - answer_type: 'multiple_choice' | 'fill_in' | 'proof' | 'open_ended'
    - has_solution_steps: 是否需要解題過程

    輸出：
    - level: 1-6 (對應 Bloom 六層次)
    - confidence: 'high' | 'medium' | 'low'
    """

    # 關鍵詞對應
    keywords = {
        'remember': ['何者是', '定義', '列出', '背誦', '辨認'],
        'understand': ['解釋', '為什麼', '舉例', '摘要', '意義'],
        'apply': ['計算', '求', '解', '使用', '執行'],
        'analyze': ['比較', '分析', '區分', '推論', '關係'],
        'evaluate': ['判斷', '評估', '驗證', '批評', '正確嗎'],
        'create': ['設計', '建構', '發明', '規劃', '創造']
    }

    # 題型加權
    if answer_type == 'multiple_choice' and not has_solution_steps:
        # 選擇題通常偏向記憶/理解
        max_level = 3
    elif answer_type == 'proof':
        # 證明題至少是分析層次
        min_level = 4
    elif answer_type == 'open_ended':
        # 開放式題目可能到創造層次
        min_level = 4

    # 基於關鍵詞判斷
    # ...（實際分類邏輯）

    return level, confidence
```

---

## 分析邏輯

### 輸入

1. **題庫資料**：從各 Layer 讀取題目
   - `docs/Extractor/{layer}/raw/*.parquet`
   - `docs/Extractor/{layer}/raw/*.csv`
   - `docs/Extractor/{layer}/raw/*.jsonl`

2. **取樣策略**：
   - 每個 Layer 最多取樣 1000 題
   - 優先取樣有解題步驟的題目
   - 按難度分層取樣（若有難度標記）

### 處理步驟

1. **讀取題目**
   ```python
   for layer in active_layers:
       questions = load_questions(layer, max_samples=1000)
   ```

2. **分類每題的 Bloom 層次**
   ```python
   for q in questions:
       level, confidence = classify_bloom_level(q)
       results.append({
           'question_id': q.id,
           'layer': layer,
           'bloom_level': level,
           'confidence': confidence
       })
   ```

3. **統計分布**
   ```python
   distribution = {
       'remember': count_level(1),
       'understand': count_level(2),
       'apply': count_level(3),
       'analyze': count_level(4),
       'evaluate': count_level(5),
       'create': count_level(6)
   }
   ```

4. **跨國比較**（若有多國資料）
   ```python
   by_country = {
       '🇺🇸': distribution_for_country('US'),
       '🇨🇳': distribution_for_country('CN'),
       '🇹🇼': distribution_for_country('TW'),
       # ...
   }
   ```

### 輸出

產出 `analysis.json`，結構見 `schema.json`。

---

## 產出檔案

執行後產生：

```
docs/Narrator/cognitive_level_map/{YYYY}-S{semester}/
├── analysis.json      # 核心數據
├── report.md          # 人類可讀報告
├── dashboard.html     # 互動式儀表板
└── vectors/           # Qdrant 向量片段
```

---

## 自我審核 Checklist

產出前必須確認：

- [ ] 每個層次的分類都有範例題目佐證
- [ ] 統計數據有標註樣本數（N=xxx）
- [ ] 低信心度的分類有標註
- [ ] 跨國比較有說明取樣差異
- [ ] 不包含任何教育建議
- [ ] 資料來源完整列出

---

## 對話功能規範

### 可回答的問題類型

| 問題類型 | 範例 | 回答格式 |
|----------|------|----------|
| 數量 | 「有幾題是分析層次？」 | 「共 150 題（12%）」 |
| 列表 | 「列出分析層次的題目」 | 「1. xxx\n2. xxx\n...」 |
| 比較 | 「台灣和美國的分布差異？」 | 「台灣在記憶層次較高（+15%）」 |
| 趨勢 | 「跟上學期比如何？」 | 「分析層次增加 3%」 |

### 不回答的問題

回覆：「這個問題超出資料彙整範圍，建議諮詢教育專業人員。」

- 為什麼 xxx 比較弱？（需解釋原因）
- 應該怎麼加強？（教育建議）
- 這樣正常嗎？（價值判斷）

---

End of cognitive_level_map/CLAUDE.md
