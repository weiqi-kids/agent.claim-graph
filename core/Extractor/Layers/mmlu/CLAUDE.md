# mmlu Layer

## Layer 類型：Static-Knowledge

## Layer 定義

| 項目 | 內容 |
|------|------|
| **Layer name** | mmlu（Massive Multitask Language Understanding） |
| **Layer type** | Static-Knowledge |
| **資料源** | HuggingFace |
| **URL** | huggingface.co/datasets/cais/mmlu |
| **格式** | Parquet |
| **內容** | 多科目多選題，涵蓋 57 個學科領域 |
| **國家** | 🇺🇸 美國 |
| **認知層次特色** | 記憶 + 理解為主（測試知識廣度） |

---

## 輸出位置

- 原始資料：`docs/Extractor/mmlu/raw/`
- 資料格式：
  - `all-test-0000.parquet`
  - `all-dev-0000.parquet`
  - `all-validation-0000.parquet`
  - `all-auxiliary_train-0000.parquet`

---

## 認知層次分析用途

此 Layer 用於分析美國多科目考試的認知層次分布，補充 SAT 的資料。

---

End of mmlu/CLAUDE.md
