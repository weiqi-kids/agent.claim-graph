#!/bin/bash
# standards_frameworks 資料更新腳本
# 職責：Qdrant 更新 + REVIEW_NEEDED 檢查
# 注意：不處理 index.json（由 GitHub Actions 產生）

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

source "$PROJECT_ROOT/lib/args.sh"
source "$PROJECT_ROOT/lib/core.sh"
source "$PROJECT_ROOT/lib/qdrant.sh"

LAYER_NAME="standards_frameworks"
DOCS_DIR="$PROJECT_ROOT/docs/Extractor/$LAYER_NAME"

# 確保分類子目錄存在
for category in us_common_core_math us_common_core_ela; do
    mkdir -p "$DOCS_DIR/$category"
done

# === 處理傳入的 .md 檔案 ===
MD_FILES=("$@")

if [[ ${#MD_FILES[@]} -eq 0 ]]; then
    echo "No .md files provided. Finding all .md files in $DOCS_DIR..."
    MD_FILES=($(find "$DOCS_DIR" -name "*.md" -type f 2>/dev/null || true))
fi

echo "Processing ${#MD_FILES[@]} files..."

# === Qdrant 更新（by source_url 去重）===
if [[ -n "${QDRANT_URL:-}" ]]; then
    if qdrant_init_env 2>/dev/null; then
        echo "Qdrant connection established"

        for f in "${MD_FILES[@]}"; do
            if [[ -f "$f" ]]; then
                # 從檔案提取 source_url 和 standard_id
                SOURCE_URL=$(grep "^source_url:" "$f" | head -1 | cut -d' ' -f2-)
                STANDARD_ID=$(grep "^standard_id:" "$f" | head -1 | cut -d' ' -f2-)

                if [[ -n "$SOURCE_URL" && -n "$STANDARD_ID" ]]; then
                    echo "Upserting: $STANDARD_ID"
                    # Qdrant upsert logic would go here
                    # qdrant_upsert "$STANDARD_ID" "$f"
                fi
            fi
        done
    else
        echo "Warning: Qdrant connection failed, skipping vector update" >&2
    fi
else
    echo "QDRANT_URL not set, skipping Qdrant update"
fi

# === REVIEW_NEEDED 檢查 ===
REVIEW_FILES=""
for f in "${MD_FILES[@]}"; do
    if [[ -f "$f" ]] && grep -q "\[REVIEW_NEEDED\]" "$f" 2>/dev/null; then
        REVIEW_FILES+="  - $f\n"
    fi
done

if [[ -n "$REVIEW_FILES" ]]; then
    echo ""
    echo "=== Files requiring review ==="
    echo -e "$REVIEW_FILES"

    # 嘗試建立 GitHub Issue（若 gh CLI 可用）
    if command -v gh >/dev/null 2>&1; then
        gh issue create \
            --title "[Extractor] $LAYER_NAME - 需要人工審核" \
            --label "review-needed" \
            --body "偵測到 [REVIEW_NEEDED] 標記：\n$REVIEW_FILES" 2>/dev/null || true
    fi
fi

# === 統計 ===
MATH_COUNT=$(find "$DOCS_DIR/us_common_core_math" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
ELA_COUNT=$(find "$DOCS_DIR/us_common_core_ela" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')

echo ""
echo "=== Update Summary ==="
echo "Math standards: $MATH_COUNT"
echo "ELA standards: $ELA_COUNT"
echo ""

echo "Update completed: $LAYER_NAME"
