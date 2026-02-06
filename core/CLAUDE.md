# 系統維護指令

本文件定義 Claude CLI 在 `core/` 目錄下操作時的維護指令。

---

## Layer 管理

### 新增 Layer

使用者說：「新增一個 {名稱} Layer」

執行流程：
1. 確認 Layer 類型（Auto-Fetch / Static-Knowledge / User-Input / Platform-OAuth）
2. 確認資料來源 URL（必須已驗證可用）
3. 確認 category enum 清單
4. 確認 `[REVIEW_NEEDED]` 觸發規則
5. 建立目錄 `core/Extractor/Layers/{layer_name}/`
6. 產生 `CLAUDE.md`、`fetch.sh`（若適用）、`update.sh`
7. 若為 User-Input 類型，產生 `schema.json`
8. 建立 `docs/Extractor/{layer_name}/` 及 category 子目錄
9. 更新 `docs/explored.md`

### 暫停 Layer

在 Layer 目錄建立 `.disabled` 標記檔：

```bash
touch core/Extractor/Layers/{layer_name}/.disabled
```

### 啟用 Layer

移除 `.disabled` 標記檔：

```bash
rm core/Extractor/Layers/{layer_name}/.disabled
```

---

## Mode 管理

### 新增 Mode

使用者說：「新增一個 {名稱} Mode」

執行流程：
1. 確認可驗證性等級（Factual / Comparative / Advisory）
2. 確認來源 Layers
3. 若為 Comparative/Advisory，確認警語內容
4. 建立目錄 `core/Narrator/Modes/{mode_name}/`
5. 產生 `CLAUDE.md`
6. 建立 `docs/Narrator/{mode_name}/`

### 暫停 / 啟用 Mode

與 Layer 相同，使用 `.disabled` 標記檔。

---

## 資料源管理

### 評估新資料源

使用者說：「我找到一個新的資料源 {URL}」

執行流程：
1. 測試連線（curl 確認可達）
2. 確認資料格式（JSON API / RSS / CSV / PDF）
3. 若為 API，驗證 API 是否仍在運作、最後更新時間
4. 更新 `docs/explored.md`「評估中」表格
5. 詢問使用者要建立新 Layer 還是加入現有 Layer

### docs/explored.md 格式

```markdown
## 已採用
| 資料源 | 類型 | 對應 Layer | 採用日期 | 備註 |

## 評估中
| 資料源 | 類型 | URL | 格式 | 發現日期 | 狀態 |

## 已排除
| 資料源 | 排除原因 | 排除日期 |
```

---

## 系統巡檢

使用者說：「系統巡檢」

執行流程：
1. 列出所有 Layer 及其狀態（啟用/暫停/缺少資料）
2. 列出所有 Mode 及其狀態（啟用/暫停）
3. 檢查 `.env` 設定完整性
4. 檢查 `docs/Extractor/*/raw/` 是否有資料
5. 回報需要人工處理的項目

---

End of core/CLAUDE.md
