---
layout: default
title: 基準資料
nav_order: 4
has_children: true
permalink: /benchmarks/
---

# 基準資料

提供各國考試的基準資料，包含分數標準、認知層次基準線、跨國對照。

## 可用報告

| 報告 | 說明 |
|------|------|
| [跨國對照報告](cross_country_comparison/2026-S1/report) | 各國考試門檻與認知層次對照 |
| [方法論說明](methodology) | 資料來源與分析方法 |

## 資料結構

```
benchmarks/
├── cognitive_level/          # 各國認知層次基準線
│   ├── taiwan.json
│   ├── usa.json
│   ├── china.json
│   ├── uk.json
│   ├── france.json
│   └── international.json
├── score_standards/          # 各考試分數標準
│   └── 2026-S1/
├── level_score_mapping/      # 認知層次與分數對照
│   └── 2026-S1/
└── cross_country_comparison/ # 跨國對照報告
    └── 2026-S1/
```

## 涵蓋考試

| 國家 | 考試 |
|------|------|
| 台灣 | 學測 |
| 美國 | SAT |
| 中國 | 高考 |
| 英國 | UKMT |
| 國際 | AMC/AIME、Codeforces |
