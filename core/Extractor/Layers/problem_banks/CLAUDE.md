# problem_banks Layer

## Layer 類型：Static-Knowledge

> **Phase 2** — 此 Layer 在 Phase 1 為 `.disabled` 狀態

---

## Layer 定義表

| 項目 | 內容 |
|------|------|
| **Layer name** | problem_banks（題庫索引） |
| **Layer type** | Static-Knowledge |
| **Engineering function** | 擷取數學競賽題庫的索引與元資料 |
| **Data sources** | AoPS（HuggingFace）、AMC/AIME（Kaggle） |
| **Update frequency** | 每季 |
| **Output value** | 提供依難度分級的練習題索引 |
| **Category enum** | `aops_problems`, `amc_problems`, `aime_problems` |
| **Reviewer persona** | 資料可信度審核員 |

---

## 資料來源

| 來源 | URL | 格式 | 狀態 |
|------|-----|------|------|
| AoPS 題庫 — HuggingFace | https://huggingface.co/datasets/bigdata-pw/aops | JSON | ✅ 已驗證 |
| AMC/AIME — Kaggle | https://www.kaggle.com/datasets/hemishveeraboina/aime-problem-set-1983-2024 | CSV | ✅ 已驗證 |

---

## Category Enum

| 英文 key | 中文 | 判定條件 |
|----------|------|----------|
| `aops_problems` | AoPS 題庫 | 來源為 Art of Problem Solving |
| `amc_problems` | AMC 競賽題 | 來源為 AMC 8/10/12 |
| `aime_problems` | AIME 競賽題 | 來源為 AIME |

---

## 萃取邏輯

（待 Phase 2 實作時定義）

---

## `[REVIEW_NEEDED]` 觸發規則

（待 Phase 2 實作時定義）

---

## 自我審核 Checklist

- [ ] 題目索引唯一
- [ ] 難度標籤來自原始資料
- [ ] 無新增的難度判斷

---

End of problem_banks/CLAUDE.md
