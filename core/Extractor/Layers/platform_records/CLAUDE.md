# platform_records Layer

## Layer 類型：Platform-OAuth

> **Phase 3** — 此 Layer 在 Phase 1-2 為 `.disabled` 狀態

---

## Layer 定義表

| 項目 | 內容 |
|------|------|
| **Layer name** | platform_records（平台學習紀錄） |
| **Layer type** | Platform-OAuth |
| **Engineering function** | 透過 OAuth 串接學習平台 API 取得學習紀錄 |
| **Data sources** | Google Classroom API |
| **Update frequency** | 每週（需要有效的 OAuth token） |
| **Output value** | 提供平台上的作業完成紀錄 |
| **Category enum** | `google_classroom` |
| **Reviewer persona** | 資料可信度審核員、使用者誤導風險審核員 |

---

## 資料來源

| 來源 | URL | 格式 | 狀態 |
|------|-----|------|------|
| Google Classroom API | https://developers.google.com/classroom | JSON API | ✅ 已驗證（需 OAuth） |

---

## OAuth 設定需求

執行此 Layer 前需要：

1. 在 `.env` 設定 `GOOGLE_CLIENT_ID` 和 `GOOGLE_CLIENT_SECRET`
2. 使用者完成 OAuth 授權流程
3. Token 存放在 `~/.config/student-learning-map/google_token.json`

---

## 隱私保護規則

- 只讀取課程名稱、作業標題、完成狀態
- 不讀取作業內容或評語
- 不讀取其他學生資料

---

## 萃取邏輯

（待 Phase 3 實作時定義）

---

## 自我審核 Checklist

- [ ] OAuth token 有效
- [ ] 只存取授權範圍內的資料
- [ ] 不含其他學生資訊

---

End of platform_records/CLAUDE.md
