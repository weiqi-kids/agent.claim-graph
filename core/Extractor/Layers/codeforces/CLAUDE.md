# codeforces Layer

## Layer 類型：Static-Knowledge

## Layer 定義

| 項目 | 內容 |
|------|------|
| **Layer name** | codeforces（Codeforces 程式競賽題庫） |
| **Layer type** | Static-Knowledge |
| **資料源** | HuggingFace |
| **URL** | huggingface.co/datasets |
| **格式** | Parquet |
| **內容** | Codeforces 程式競賽題目，含難度評級（800-3500） |
| **國家** | 🌍 國際 |
| **認知層次特色** | 分析（45%）+ 創造（15%）為主，高階認知導向 |

---

## 輸出位置

- 原始資料：`docs/Extractor/codeforces/raw/`
- 資料格式：
  - `test-*.parquet`
  - `train-*.parquet`（多個分片）

---

## 認知層次分析用途

此 Layer 用於分析程式競賽的認知層次分布，作為國際競賽類別的資料來源之一。

---

## 難度對照

| 評級範圍 | 難度描述 |
|----------|----------|
| 800-1200 | 入門級 |
| 1200-1600 | 中級 |
| 1600-2000 | 進階 |
| 2000-2400 | 高級 |
| 2400+ | 專家級 |

---

End of codeforces/CLAUDE.md
