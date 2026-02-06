# opensat_hf Layer

## Layer 類型：Static-Knowledge

## Layer 定義

| 項目 | 內容 |
|------|------|
| **Layer name** | opensat_hf（OpenSAT 題庫） |
| **資料源** | HuggingFace |
| **URL** | huggingface.co/datasets/lmms-lab/OpenSAT |
| **格式** | Parquet |
| **內容** | SAT 閱讀/寫作/數學題目 |

---

## fetch.sh 說明

使用 `lib/huggingface.sh` 的 `hf_download` 函式下載資料集。

---

## 輸出位置

- 原始資料：`docs/Extractor/opensat_hf/raw/`
- 萃取結果：`docs/Extractor/opensat_hf/{category}/`

---

End of opensat_hf/CLAUDE.md
