---
layout: default
title: 資料源紀錄
nav_exclude: true
---

# 資料源探索紀錄

## 2026-02-07 探索紀錄

### 已驗證可用

| 資料源 | URL | 格式 | 用途 |
|--------|-----|------|------|
| College Board SAT Percentiles | https://research.collegeboard.org/reports/sat-suite/understanding-scores/sat | HTML | SAT 2025 百分位分數 |
| College Board 2025 Annual Report | https://reports.collegeboard.org/media/pdf/2025-total-group-sat-suite-of-assessments-annual-report.pdf | PDF | SAT 年度統計報告 |
| MAA AMC/AIME Thresholds | https://maa.org/news/2025-26-aime-thresholds-are-now-available/ | HTML | AIME 資格分數線 |
| OECD PISA 2022 Results | https://www.oecd.org/en/publications/pisa-2022-results-volume-i_53f23881-en.html | HTML | 國際數學成績比較 |
| IMO Official Results | https://www.imo-official.org/results.aspx | HTML | 國際數學奧林匹亞成績 |
| UKMT Awards Info | https://ukmt.org.uk/senior-challenges/senior-mathematical-challenge-awards | HTML | 英國數學競賽獎項門檻 |

### 已確認不可用

| 資料源 | 原因 |
|--------|------|
| Common Standards Project API | 頁面僅有 JavaScript，無實際 API 端點可用 |
| 國家教育研究院課綱頁面 | 僅為導航頁，實際課綱在 PDF 檔案中 |

---

## 已採用（Phase 1 考試題庫）

| 資料源 | 類型 | 對應 Layer | 採用日期 | 檔案大小 | 備註 |
|--------|------|------------|----------|----------|------|
| NuminaMath-CoT | HuggingFace Parquet | numinamath_hf | 2026-02-04 | 162 KB (test) | 86 萬題，含解題步驟 |
| OlympiadBench | HuggingFace Parquet | olympiadbench_hf | 2026-02-04 | 5.8 MB | 數學/物理奧林匹克 |
| qwedsacf/competition_math | HuggingFace Parquet | math_dataset_hf | 2026-02-04 | 4.6 MB | 12,500 競賽數學題 |
| Maxwell-Jia/AIME_2024 | HuggingFace Parquet | amc_github | 2026-02-04 | 36 KB | AIME 2024 題目 |
| AI-MO/aimo-validation-aime | HuggingFace Parquet | amc_github | 2026-02-04 | 255 KB | AIME 2022-2024 |
| DeepStudentLlama/AoPS-Instruct | HuggingFace Parquet | aops_hf | 2026-02-04 | 403 MB | 1M+ 題，MIT 授權 |
| ndavidson/sat-math-chain-of-thought | HuggingFace Parquet | sat_math_hf | 2026-02-04 | 14 MB | SAT 數學含解題步驟 |
| hails/agieval-sat-math | HuggingFace Parquet | sat_math_hf | 2026-02-04 | 56 KB | AGIEval SAT 數學 |
| ikala/tmmluplus | HuggingFace CSV | tmmlu_tw | 2026-02-04 | 5.8 MB | 🇹🇼 台灣 67 科考試（完整） |
| TsukiOwO/TW-GSAT-Chinese | HuggingFace Parquet | gsat_tw | 2026-02-04 | 470 KB | 🇹🇼 台灣學測中文 |
| dmayhem93/agieval-gaokao-mathqa | HuggingFace Parquet | gaokao_cn | 2026-02-04 | 61 KB | 🇨🇳 中國高考數學 |
| TICK666/Basic-Math-Chinese-1M | HuggingFace JSON | math_chinese | 2026-02-04 | 116 MB | 🇨🇳 100 萬中文數學題 |
| Mxode/School-Math-R1-Distil-Chinese-220K | HuggingFace JSONL | math_chinese | 2026-02-04 | 212 MB | 🇨🇳 22 萬學校數學 |
| northwind07/ukmt_senior_2024 | HuggingFace CSV | ukmt_uk | 2026-02-04 | 8.7 KB | 🇬🇧 英國 UKMT 2024 |
| Cotum/MATH-500-french-thoughts | HuggingFace Parquet | math_french | 2026-02-04 | 1.2 MB | 🇫🇷 法文數學 500 題 |
| cais/mmlu | HuggingFace Parquet | mmlu | 2026-02-05 | 51 MB | 🇺🇸 57 學科 MMLU 基準測試 |
| derek-thomas/ScienceQA | HuggingFace Parquet | scienceqa | 2026-02-05 | 624 MB | 🌍 21K 科學問答題（含圖片） |
| open-r1/codeforces | HuggingFace Parquet | codeforces | 2026-02-05 | 2.5 GB | 🌍 10K+ 程式競賽題 |
| BoyuanJackchen/leetcode_free_questions_labeled | HuggingFace Parquet | leetcode | 2026-02-05 | 988 KB | 🌍 LeetCode 免費題 |
| chillies/IELTS-writing-task-2-evaluation | HuggingFace CSV | ielts_writing | 2026-02-05 | 45 MB | 🌍 IELTS 寫作評估資料 |

## 已採用（舊架構，待遷移）

| 資料源 | 類型 | 對應 Layer | 採用日期 | 備註 |
|--------|------|------------|----------|------|
| US Common Core — Common Standards Project | JSON API | standards_frameworks | 2026-02-02 | 待確認 API 狀態 |
| US Common Core — GitHub (SirFizX) | JSON files | standards_frameworks | 2026-02-02 | 備用資料源 |
| CEFR — UniversalCEFR | HuggingFace | assessment_benchmarks | 2026-02-02 | 待驗證 |
| PISA — OECD | SAS/SPSS/CSV | peer_benchmarks | 2026-02-02 | Phase 3 |
| TIMSS | Data files | peer_benchmarks | 2026-02-02 | Phase 3 |
| Google Classroom API | JSON API | platform_records | 2026-02-02 | Phase 3，需 OAuth |

## 評估中

| 資料源 | 類型 | URL | 格式 | 發現日期 | 狀態 |
|--------|------|-----|------|----------|------|
| 台灣課綱 — NAER | 課綱 | https://www.naer.edu.tw/PageSyllabus?fid=52 | PDF/HTML | 2026-02-02 | 待萃取方案 |
| 台灣 data.gov.tw 教育類 | 開放資料 | https://data.gov.tw/datasets/agency/教育部 | Various | 2026-02-02 | 待挖掘 |
| 均一平台 open data | 學習平台 | https://www.junyiacademy.org/open-data-iot | Unknown | 2026-02-02 | 需驗證 API |
| CEFR-J 詞彙/語法 | GitHub | https://github.com/openlanguageprofiles/olp-en-cefrj | CSV/JSON | 2026-02-02 | 可作為 L2 補充 |
| Canvas LMS API | 學習平台 | https://www.canvas.instructure.com/doc/api/ | JSON API | 2026-02-02 | 需 OAuth |

## 已排除

| 資料源 | 排除原因 | 排除日期 |
|--------|---------|----------|
| Khan Academy API | 2020/7/1 官方停用 | 2026-02-02 |
| IB Curriculum | 專有授權，需 IB World School 資格 | 2026-02-02 |
| APCS 台灣 | 無結構化 API，只有 PDF | 2026-02-02 |
| lmms-lab/OpenSAT | 資料集不存在（OpenSAT 是衛星圖像資料） | 2026-02-04 |
| jeggers/SAT-Math | 無法存取，可能已移除 | 2026-02-04 |
| bigdata-pw/aops | gated dataset，需要 HF 認證 | 2026-02-04 |
| ryanrudes/amc | 只有 PNG 圖片，無結構化 JSON | 2026-02-04 |
| hendrycks/competition_math | 需要認證才能下載 | 2026-02-04 |
