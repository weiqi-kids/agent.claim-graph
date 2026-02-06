#!/bin/bash
# assessment_benchmarks 資料擷取腳本
# Layer 類型：Static-Knowledge
# 資料來源：AMC/AIME (GitHub), CEFR (HuggingFace)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

source "$PROJECT_ROOT/lib/args.sh"
source "$PROJECT_ROOT/lib/core.sh"

LAYER_NAME="assessment_benchmarks"
RAW_DIR="$PROJECT_ROOT/docs/Extractor/$LAYER_NAME/raw"

mkdir -p "$RAW_DIR"

# === Static-Knowledge 檢查 ===
# 如果 raw/ 目錄已有資料且 .last_fetch 存在，詢問是否要重新下載
if [[ -f "$RAW_DIR/.last_fetch" ]]; then
    LAST_FETCH=$(cat "$RAW_DIR/.last_fetch")
    echo "Data was last fetched at: $LAST_FETCH"
    echo "This is a Static-Knowledge layer. Re-fetching is optional."
    echo "Set FORCE_FETCH=1 to re-download."

    if [[ "${FORCE_FETCH:-0}" != "1" ]]; then
        # 檢查是否有資料
        if ls "$RAW_DIR"/*.jsonl >/dev/null 2>&1; then
            echo "Using existing data. Skipping fetch."
            exit 0
        fi
    fi
fi

echo "Fetching assessment benchmarks..."

# === AMC/AIME 資料擷取 ===
echo "Downloading AMC/AIME data..."
AMC_FILE="$RAW_DIR/amc_math.jsonl"

# 從 GitHub 下載 AMC 資料
AMC_REPO="https://raw.githubusercontent.com/ryanrudes/amc/main"
if curl -sf "$AMC_REPO/data/problems.json" -o "$RAW_DIR/amc_raw.json"; then
    # 轉換為 JSONL 格式
    jq -c '.[]' "$RAW_DIR/amc_raw.json" > "$AMC_FILE" 2>/dev/null || {
        # 如果結構不同，嘗試其他格式
        cat "$RAW_DIR/amc_raw.json" | jq -c '.. | objects | select(.competition? and .year?)' > "$AMC_FILE" 2>/dev/null || true
    }
    rm -f "$RAW_DIR/amc_raw.json"
    echo "AMC data saved to $AMC_FILE"
else
    echo "Warning: Failed to download AMC data from GitHub"
    # 建立空檔案以避免後續處理錯誤
    echo "" > "$AMC_FILE"
fi

# === CEFR 資料擷取 ===
echo "Downloading CEFR data..."
CEFR_FILE="$RAW_DIR/cefr_english.jsonl"

# 使用 huggingface.sh 下載（如果存在）
if [[ -f "$PROJECT_ROOT/lib/huggingface.sh" ]]; then
    source "$PROJECT_ROOT/lib/huggingface.sh"
    # hf_download "UniversalCEFR" "$RAW_DIR/cefr_raw"
fi

# 備用方案：從 CEFR-J GitHub 下載
CEFRJ_REPO="https://raw.githubusercontent.com/openlanguageprofiles/olp-en-cefrj/main"
if curl -sf "$CEFRJ_REPO/vocabulary/cefr-j-vocabulary.csv" -o "$RAW_DIR/cefrj_vocab.csv"; then
    echo "CEFR-J vocabulary data downloaded"
fi

# 從 CEFR 官方描述建立基準資料
cat > "$CEFR_FILE" << 'EOF'
{"level":"A1","domain":"reading","descriptor":"Can understand familiar names, words and very simple sentences","can_do_statements":["Can understand very short, simple texts a single phrase at a time"]}
{"level":"A2","domain":"reading","descriptor":"Can read very short, simple texts","can_do_statements":["Can understand short simple texts containing the highest frequency vocabulary"]}
{"level":"B1","domain":"reading","descriptor":"Can understand texts that consist mainly of high frequency everyday or job-related language","can_do_statements":["Can understand the description of events, feelings and wishes in personal letters"]}
{"level":"B2","domain":"reading","descriptor":"Can read with a large degree of independence","can_do_statements":["Can read articles and reports concerned with contemporary problems"]}
{"level":"C1","domain":"reading","descriptor":"Can understand long and complex factual and literary texts","can_do_statements":["Can understand specialized articles and longer technical instructions"]}
{"level":"C2","domain":"reading","descriptor":"Can read with ease virtually all forms of the written language","can_do_statements":["Can understand any kind of text including those written in a very colloquial style"]}
EOF

echo "CEFR data saved to $CEFR_FILE"

# 記錄最後擷取時間
date -u +"%Y-%m-%dT%H:%M:%SZ" > "$RAW_DIR/.last_fetch"

# 統計
AMC_COUNT=$(wc -l < "$AMC_FILE" 2>/dev/null | tr -d ' ' || echo "0")
CEFR_COUNT=$(wc -l < "$CEFR_FILE" 2>/dev/null | tr -d ' ' || echo "0")

echo ""
echo "=== Fetch Summary ==="
echo "AMC benchmarks: $AMC_COUNT"
echo "CEFR benchmarks: $CEFR_COUNT"
echo "Last fetch: $(cat "$RAW_DIR/.last_fetch")"
echo ""

echo "Fetch completed: $LAYER_NAME"
