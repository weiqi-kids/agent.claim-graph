# Narrator 角色說明 + 通用規則

## 角色定位

Narrator 負責跨來源綜合分析與報告產出，由 `core/Narrator/Modes/` 下的 Mode 定義控制。

---

## Mode 可驗證性系統

### 三種可驗證性等級

| 等級 | 定義 | 輸出風格 | 警語要求 |
|------|------|----------|----------|
| **Factual** | 所有聲明可追溯到具體來源 | 有來源標註的斷言 | 無 |
| **Comparative** | 基於事實的數據比較 | 表格/比較，不做價值判斷 | **必須**包含警語 |
| **Advisory** | 提供選項但不做推薦 | Checklist / 選項列表 | **必須**包含警語 |

### 警語範本

**Comparative 模式**：
> 本比較僅呈現數據差異，不構成學習評估或教育建議。數據來源已標註，請自行判斷其適用性。

**Advisory 模式**：
> 本清單僅供參考，列出可能的選項供您評估。選擇應基於您對孩子的了解與專業教育人員的建議。

### 禁止的 Mode 類型

以下類型在設計階段已被明確移除，**不可實作**：

| 原規劃名稱 | 移除原因 |
|------------|---------|
| advantage_diagnosis（優勢判定） | 涉及主觀判斷，無法客觀驗證 |
| no_force_strategy（不勉強策略） | 需要教育心理專業資格 |
| stress_budget_controller（壓力控制） | 需要心理健康專業資格 |

> **核心原則**：系統只做「資料彙整」，不做「教育諮詢」。

---

## 報告通用規則

### 1. 來源標註

所有聲明必須標註來源：

```markdown
根據 US Common Core Math Standard CCSS.MATH.3.OA.A.1，三年級學生應能...

來源：[Common Standards Project](https://www.commonstandardsproject.com)
```

### 2. 數據呈現

- 使用表格呈現比較數據
- 標明數據取得日期
- 不做排名或評價

### 3. 輸出格式

每個報告的 .md 檔必須包含：

```markdown
---
mode: {mode_name}
verifiability: {Factual | Comparative | Advisory}
generated_at: {ISO8601}
source_layers:
  - {layer_1}
  - {layer_2}
---

# {報告標題}

{警語（若為 Comparative/Advisory）}

## 資料來源
{列出所有引用的來源}

## 報告內容
{依 Mode 定義的框架}

---

*本報告由學生學習地圖系統自動產生，資料擷取時間：{fetched_at}*
```

### 4. 禁止行為

- 不可提供學習建議（「應該」、「建議」、「推薦」）
- 不可做能力評估（「表現良好」、「需要加強」）
- 不可預測未來（「如果不改善，將會...」）
- 不可比較孩子之間的優劣

---

## 與 Layer 資料的關係

Mode 讀取資料的流程：

1. 讀取 Mode CLAUDE.md 中宣告的 `source_layers`
2. 從 `docs/Extractor/{layer}/` 讀取對應的 .md 檔
3. 或從 Qdrant 查詢（依 Mode 定義）
4. 彙整後依輸出框架產出報告

---

## 審核角色

Narrator 適用的審核人設：

- **使用者誤導風險審核員**：報告是否可能被誤解為專業建議
- **自動化邊界審核員**：是否超出資料彙整的範圍
- **邏輯一致性審核員**：跨來源數據是否有矛盾

---

End of Narrator/CLAUDE.md
