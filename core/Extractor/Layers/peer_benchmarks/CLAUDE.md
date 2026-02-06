# peer_benchmarks Layer

## Layer 類型：Static-Knowledge

> **Phase 3** — 此 Layer 在 Phase 1-2 為 `.disabled` 狀態

---

## Layer 定義表

| 項目 | 內容 |
|------|------|
| **Layer name** | peer_benchmarks（同儕統計基準） |
| **Layer type** | Static-Knowledge |
| **Engineering function** | 擷取 PISA/TIMSS 等國際測評的百分位數資料 |
| **Data sources** | PISA（OECD）、TIMSS |
| **Update frequency** | 每年（配合測評發布週期） |
| **Output value** | 提供客觀的同年齡能力分布參照 |
| **Category enum** | `pisa_math`, `pisa_reading`, `timss_math` |
| **Reviewer persona** | 資料可信度審核員、使用者誤導風險審核員 |

---

## 資料來源

| 來源 | URL | 格式 | 狀態 |
|------|-----|------|------|
| PISA 資料 | https://www.oecd.org/en/about/programmes/pisa/pisa-data.html | SAS/SPSS/CSV | ✅ 已驗證 |
| TIMSS 資料 | https://timssandpirls.bc.edu/ | Data files | ✅ 已驗證 |
| OECD Education API | https://data.oecd.org/api/ | JSON/XML | ✅ 已驗證 |

---

## 重要警示

此 Layer 的輸出必須包含以下警語：

> 本數據為國際測評的統計分布資料，僅供參考。不可用於判斷個別學生的相對位置或進行排名比較。

---

## 萃取邏輯

（待 Phase 3 實作時定義）

---

## 自我審核 Checklist

- [ ] 資料來自官方發布的測評報告
- [ ] 不含個別學生資料
- [ ] 已加上適當警語

---

End of peer_benchmarks/CLAUDE.md
