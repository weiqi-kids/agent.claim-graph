#!/bin/bash
# opensat_hf 資料擷取腳本

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

source "$PROJECT_ROOT/lib/huggingface.sh"

LAYER_NAME="opensat_hf"
DATASET_ID="lmms-lab/OpenSAT"
RAW_DIR="$PROJECT_ROOT/docs/Extractor/$LAYER_NAME/raw"

mkdir -p "$RAW_DIR"

echo "📦 Fetching $LAYER_NAME from HuggingFace..."

# 下載資料集
hf_download "$DATASET_ID" "$RAW_DIR" "train" || {
  echo "⚠️  標準下載失敗，嘗試直接下載 parquet..."
  # 嘗試直接 URL
  curl -sf -L -o "$RAW_DIR/train.parquet" \
    "https://huggingface.co/datasets/$DATASET_ID/resolve/main/data/train-00000-of-00001.parquet" 2>/dev/null || true
}

echo "✅ Fetch completed: $LAYER_NAME"
ls -la "$RAW_DIR"
