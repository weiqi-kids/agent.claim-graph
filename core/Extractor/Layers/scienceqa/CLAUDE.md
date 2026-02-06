# scienceqa Layer

## Layer 類型：Static-Knowledge

## Layer 定義

| 項目 | 內容 |
|------|------|
| **Layer name** | scienceqa（科學問答題庫） |
| **Layer type** | Static-Knowledge |
| **資料源** | HuggingFace |
| **URL** | huggingface.co/datasets/derek-thomas/ScienceQA |
| **格式** | Parquet |
| **內容** | K-12 科學問答題，包含圖片和解釋 |
| **國家** | 🇺🇸 美國 |
| **認知層次特色** | 理解 + 應用為主 |

---

## 輸出位置

- 原始資料：`docs/Extractor/scienceqa/raw/`
- 資料格式：
  - `train-*.parquet`
  - `validation-*.parquet`

---

## 認知層次分析用途

此 Layer 用於分析美國科學教育的認知層次分布，補充 MMLU 的資料。

---

End of scienceqa/CLAUDE.md
