#!/bin/bash
# aops_hf 資料擷取腳本

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

source "$PROJECT_ROOT/lib/huggingface.sh"

LAYER_NAME="aops_hf"
DATASET_ID="bigdata-pw/aops"
RAW_DIR="$PROJECT_ROOT/docs/Extractor/$LAYER_NAME/raw"

mkdir -p "$RAW_DIR"

echo "📦 Fetching $LAYER_NAME from HuggingFace..."
echo "⚠️  此資料集很大，下載可能需要較長時間..."

# 先列出檔案結構
echo "檔案結構："
hf_list_files "$DATASET_ID" 2>/dev/null | head -20 || true

# 下載資料集
hf_download "$DATASET_ID" "$RAW_DIR" "train" || {
  echo "⚠️  標準下載失敗"
}

echo "✅ Fetch completed: $LAYER_NAME"
ls -la "$RAW_DIR"
