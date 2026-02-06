#!/bin/bash
# standards_frameworks 資料擷取腳本
# Layer 類型：Auto-Fetch
# 資料來源：US Common Core (Common Standards Project API)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

source "$PROJECT_ROOT/lib/args.sh"
source "$PROJECT_ROOT/lib/core.sh"

LAYER_NAME="standards_frameworks"
RAW_DIR="$PROJECT_ROOT/docs/Extractor/$LAYER_NAME/raw"

mkdir -p "$RAW_DIR"

# === US Common Core 資料擷取 ===

echo "Fetching US Common Core standards from Common Standards Project API..."

API_BASE="https://commonstandardsproject.com/api/v1"
CCSS_JURISDICTION_ID="67810E9EF6944F9383DCC602A3484C23"

# 下載 jurisdiction 資料（包含所有 standard sets）
echo "Downloading jurisdiction data..."
JURISDICTION_FILE="$RAW_DIR/ccss_jurisdiction.json"
if curl -sf "$API_BASE/jurisdictions/$CCSS_JURISDICTION_ID" -o "$JURISDICTION_FILE"; then
    echo "Jurisdiction data saved"
else
    echo "Error: Failed to download jurisdiction data"
    exit 1
fi

# 解析出 Math 和 ELA 標準集
echo "Extracting Math standard sets..."
MATH_FILE="$RAW_DIR/us_common_core_math.jsonl"
jq -c '.data.standardSets[] | select(.subject == "Common Core Mathematics")' "$JURISDICTION_FILE" > "$MATH_FILE"

echo "Extracting ELA standard sets..."
ELA_FILE="$RAW_DIR/us_common_core_ela.jsonl"
jq -c '.data.standardSets[] | select(.subject == "Common Core English/Language Arts")' "$JURISDICTION_FILE" > "$ELA_FILE"

# 對每個標準集，嘗試取得詳細標準（如果 API 支援）
echo "Fetching detailed standards for each set..."

# 取得 Math 標準集 IDs
MATH_SET_IDS=$(jq -r '.id' "$MATH_FILE" 2>/dev/null | head -5)
MATH_STANDARDS_FILE="$RAW_DIR/us_common_core_math_standards.jsonl"
> "$MATH_STANDARDS_FILE"

for set_id in $MATH_SET_IDS; do
    echo "  Fetching standards for set: $set_id"
    if curl -sf "$API_BASE/standard_sets/$set_id" -o "$RAW_DIR/temp_set.json" 2>/dev/null; then
        jq -c '.data.standards[]?' "$RAW_DIR/temp_set.json" >> "$MATH_STANDARDS_FILE" 2>/dev/null || true
    fi
done
rm -f "$RAW_DIR/temp_set.json"

# 取得 ELA 標準集 IDs
ELA_SET_IDS=$(jq -r '.id' "$ELA_FILE" 2>/dev/null | head -5)
ELA_STANDARDS_FILE="$RAW_DIR/us_common_core_ela_standards.jsonl"
> "$ELA_STANDARDS_FILE"

for set_id in $ELA_SET_IDS; do
    echo "  Fetching standards for set: $set_id"
    if curl -sf "$API_BASE/standard_sets/$set_id" -o "$RAW_DIR/temp_set.json" 2>/dev/null; then
        jq -c '.data.standards[]?' "$RAW_DIR/temp_set.json" >> "$ELA_STANDARDS_FILE" 2>/dev/null || true
    fi
done
rm -f "$RAW_DIR/temp_set.json"

# 記錄最後擷取時間
date -u +"%Y-%m-%dT%H:%M:%SZ" > "$RAW_DIR/.last_fetch"

# 統計
MATH_SET_COUNT=$(wc -l < "$MATH_FILE" 2>/dev/null | tr -d ' ' || echo "0")
ELA_SET_COUNT=$(wc -l < "$ELA_FILE" 2>/dev/null | tr -d ' ' || echo "0")
MATH_STD_COUNT=$(wc -l < "$MATH_STANDARDS_FILE" 2>/dev/null | tr -d ' ' || echo "0")
ELA_STD_COUNT=$(wc -l < "$ELA_STANDARDS_FILE" 2>/dev/null | tr -d ' ' || echo "0")

echo ""
echo "=== Fetch Summary ==="
echo "Math standard sets: $MATH_SET_COUNT"
echo "Math standards: $MATH_STD_COUNT"
echo "ELA standard sets: $ELA_SET_COUNT"
echo "ELA standards: $ELA_STD_COUNT"
echo "Last fetch: $(cat "$RAW_DIR/.last_fetch")"
echo ""

echo "Fetch completed: $LAYER_NAME"
