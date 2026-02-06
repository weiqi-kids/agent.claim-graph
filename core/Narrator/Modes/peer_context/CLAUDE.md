# peer_context Mode

## Mode 可驗證性：Comparative

> **Phase 3** — 此 Mode 在 Phase 1-2 為 `.disabled` 狀態

---

## Mode 定義表

| 項目 | 內容 |
|------|------|
| **Mode name** | peer_context（同儕脈絡） |
| **Verifiability** | Comparative |
| **Purpose and audience** | 提供同年齡學生的統計分布參照 |
| **Source layers** | L6 peer_benchmarks |
| **Required disclaimer** | ✅ 必須（見下方警語） |
| **Reviewer persona** | 使用者誤導風險審核員 |

---

## 必要警語

> **重要提示**
>
> 本報告呈現的是 PISA/TIMSS 等國際測評的統計分布資料。
>
> - 這些是群體統計數據，不適用於評估個別學生
> - 不同測評的評量標準和對象不同，不可直接比較
> - 統計分布僅供了解整體趨勢，不代表「正常」或「標準」
>
> 每個孩子都是獨特的，不應以統計數據判斷個別表現。

---

## 資料來源定義

| 來源 | 路徑 | 用途 |
|------|------|------|
| PISA 資料 | `docs/Extractor/peer_benchmarks/pisa_*` | 國際測評統計 |
| TIMSS 資料 | `docs/Extractor/peer_benchmarks/timss_*` | 國際測評統計 |

---

## 輸出框架

```markdown
# 同年齡學生能力分布參照

> **重要提示**
> 本報告呈現的是國際測評的統計分布資料，不適用於評估個別學生。

## PISA 數學能力分布（{year}）

| 百分位 | 分數 |
|--------|------|
| 10th | {score} |
| 25th | {score} |
| 50th (中位數) | {score} |
| 75th | {score} |
| 90th | {score} |

## 資料說明

- 資料來源：OECD PISA {year}
- 測評對象：15 歲學生
- 參與國家/地區數：{count}

---

*本報告僅供參考，不可用於個別學生評估*
```

---

## 禁止行為

- 不可將孩子「放入」百分位
- 不可暗示「應該」達到某個水準
- 不可比較不同孩子
- 不可使用「高於平均」或「低於平均」等描述

---

## 自我審核 Checklist

- [ ] 警語完整
- [ ] 來源和年份正確標註
- [ ] 無個別評估語句
- [ ] 無「平均」相關比較

---

End of peer_context/CLAUDE.md
