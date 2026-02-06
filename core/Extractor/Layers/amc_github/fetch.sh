#!/bin/bash
# amc_github 資料擷取腳本

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

LAYER_NAME="amc_github"
RAW_DIR="$PROJECT_ROOT/docs/Extractor/$LAYER_NAME/raw"

mkdir -p "$RAW_DIR"

echo "📦 Fetching $LAYER_NAME from GitHub..."

# 下載 AMC 資料集
REPO_URL="https://raw.githubusercontent.com/ryanrudes/amc/main"

# 嘗試下載主要的 JSON 檔案
for file in amc8.json amc10.json amc12.json; do
  curl -sf -L -o "$RAW_DIR/$file" "$REPO_URL/$file" 2>/dev/null || {
    echo "⚠️  無法下載 $file"
  }
done

# 如果沒有找到檔案，嘗試下載整個 repo 的 data 目錄
if [[ ! -f "$RAW_DIR/amc8.json" ]]; then
  echo "嘗試下載 data 目錄..."
  for file in data/amc8.json data/amc10.json data/amc12.json; do
    curl -sf -L -o "$RAW_DIR/$(basename $file)" "$REPO_URL/$file" 2>/dev/null || true
  done
fi

echo "✅ Fetch completed: $LAYER_NAME"
ls -la "$RAW_DIR"
