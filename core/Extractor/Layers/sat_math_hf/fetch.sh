#!/bin/bash
# sat_math_hf 資料擷取腳本

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

source "$PROJECT_ROOT/lib/huggingface.sh"

LAYER_NAME="sat_math_hf"
DATASET_ID="jeggers/SAT-Math"
RAW_DIR="$PROJECT_ROOT/docs/Extractor/$LAYER_NAME/raw"

mkdir -p "$RAW_DIR"

echo "📦 Fetching $LAYER_NAME from HuggingFace..."

hf_download "$DATASET_ID" "$RAW_DIR" "train" || {
  echo "⚠️  標準下載失敗，嘗試列出檔案..."
  hf_list_files "$DATASET_ID" 2>/dev/null || true
}

echo "✅ Fetch completed: $LAYER_NAME"
ls -la "$RAW_DIR"
