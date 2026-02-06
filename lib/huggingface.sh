#!/usr/bin/env bash
# huggingface.sh - HuggingFace Datasets 下載工具
# 注意：預期被其他 script 用 `source` 載入
# 不在這裡 set -euo pipefail，交給呼叫端決定。

if [[ -n "${HUGGINGFACE_SH_LOADED:-}" ]]; then
  return 0 2>/dev/null || exit 0
fi
HUGGINGFACE_SH_LOADED=1

_hf_lib_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "${_hf_lib_dir}/core.sh"

########################################
# hf_download DATASET_ID OUTPUT_DIR [SPLIT]
#
# 功能：
#   - 從 HuggingFace Datasets 下載資料集
#
# 參數：
#   DATASET_ID: HuggingFace 資料集 ID（如 "bigdata-pw/aops"）
#   OUTPUT_DIR: 輸出目錄
#   SPLIT: 可選，指定要下載的 split（train/test/validation）
#
# 回傳值：
#   0  = 成功
#   >0 = 失敗
#
# 依賴：
#   curl, jq
#
# 說明：
#   HuggingFace Datasets 有多種存取方式：
#   1. Datasets Hub API（需要 HF_TOKEN）
#   2. 直接下載 Parquet/JSON 檔案
#   本函式嘗試方法 2，以避免認證需求
########################################
hf_download() {
  local dataset_id="$1"
  local output_dir="$2"
  local split="${3:-train}"

  require_cmd curl || return 1
  require_cmd jq || return 1

  if [[ -z "$dataset_id" || -z "$output_dir" ]]; then
    echo "❌ [hf_download] 用法：hf_download DATASET_ID OUTPUT_DIR [SPLIT]" >&2
    return 1
  fi

  mkdir -p "$output_dir"

  local base_url="https://huggingface.co/datasets/${dataset_id}"
  local api_url="https://huggingface.co/api/datasets/${dataset_id}"

  echo "📦 [hf_download] 下載資料集：$dataset_id" >&2

  # 嘗試取得資料集資訊
  local dataset_info
  dataset_info="$(curl -sf "$api_url" 2>/dev/null)" || {
    echo "⚠️  [hf_download] 無法取得資料集資訊，嘗試直接下載..." >&2
  }

  # 嘗試下載 Parquet 檔案（HuggingFace 預設格式）
  local parquet_url="${base_url}/resolve/main/data/${split}-00000-of-00001.parquet"
  local parquet_file="${output_dir}/${split}.parquet"

  if curl -sf -L -o "$parquet_file" "$parquet_url" 2>/dev/null; then
    echo "✅ [hf_download] Parquet 檔案下載成功：$parquet_file" >&2
    return 0
  fi

  # 嘗試下載 JSONL 檔案
  local jsonl_url="${base_url}/resolve/main/data/${split}.jsonl"
  local jsonl_file="${output_dir}/${split}.jsonl"

  if curl -sf -L -o "$jsonl_file" "$jsonl_url" 2>/dev/null; then
    echo "✅ [hf_download] JSONL 檔案下載成功：$jsonl_file" >&2
    return 0
  fi

  # 嘗試下載 JSON 檔案
  local json_url="${base_url}/resolve/main/data/${split}.json"
  local json_file="${output_dir}/${split}.json"

  if curl -sf -L -o "$json_file" "$json_url" 2>/dev/null; then
    echo "✅ [hf_download] JSON 檔案下載成功：$json_file" >&2
    # 轉換為 JSONL
    if [[ -f "$json_file" ]]; then
      jq -c '.[]' "$json_file" > "${output_dir}/${split}.jsonl" 2>/dev/null || true
    fi
    return 0
  fi

  echo "❌ [hf_download] 無法下載資料集：$dataset_id" >&2
  echo "   請確認資料集 ID 正確且為公開資料集" >&2
  return 1
}

########################################
# hf_download_file DATASET_ID FILE_PATH OUTPUT_FILE
#
# 功能：
#   - 從 HuggingFace 下載特定檔案
#
# 參數：
#   DATASET_ID: HuggingFace 資料集 ID
#   FILE_PATH: 資料集內的檔案路徑
#   OUTPUT_FILE: 輸出檔案路徑
#
# 回傳值：
#   0  = 成功
#   >0 = 失敗
########################################
hf_download_file() {
  local dataset_id="$1"
  local file_path="$2"
  local output_file="$3"

  require_cmd curl || return 1

  if [[ -z "$dataset_id" || -z "$file_path" || -z "$output_file" ]]; then
    echo "❌ [hf_download_file] 用法：hf_download_file DATASET_ID FILE_PATH OUTPUT_FILE" >&2
    return 1
  fi

  local url="https://huggingface.co/datasets/${dataset_id}/resolve/main/${file_path}"

  local max_retries=3
  local retry_delay=2

  for ((attempt=1; attempt<=max_retries; attempt++)); do
    if curl -sf -L -o "$output_file" "$url" 2>/dev/null; then
      echo "✅ [hf_download_file] 下載成功：$output_file" >&2
      return 0
    fi

    if [[ $attempt -lt $max_retries ]]; then
      echo "⚠️  [hf_download_file] 下載失敗，重試 $attempt/$max_retries..." >&2
      sleep $retry_delay
    fi
  done

  echo "❌ [hf_download_file] 無法下載：$url" >&2
  return 1
}

########################################
# hf_list_files DATASET_ID
#
# 功能：
#   - 列出 HuggingFace 資料集中的檔案
#
# 參數：
#   DATASET_ID: HuggingFace 資料集 ID
#
# stdout:
#   檔案列表（每行一個）
########################################
hf_list_files() {
  local dataset_id="$1"

  require_cmd curl || return 1
  require_cmd jq || return 1

  if [[ -z "$dataset_id" ]]; then
    echo "❌ [hf_list_files] 用法：hf_list_files DATASET_ID" >&2
    return 1
  fi

  local api_url="https://huggingface.co/api/datasets/${dataset_id}/tree/main"

  curl -sf "$api_url" 2>/dev/null | jq -r '.[].path' 2>/dev/null || {
    echo "❌ [hf_list_files] 無法取得檔案列表：$dataset_id" >&2
    return 1
  }
}

########################################
# hf_dataset_info DATASET_ID
#
# 功能：
#   - 取得 HuggingFace 資料集的基本資訊
#
# 參數：
#   DATASET_ID: HuggingFace 資料集 ID
#
# stdout:
#   JSON 格式的資料集資訊
########################################
hf_dataset_info() {
  local dataset_id="$1"

  require_cmd curl || return 1

  if [[ -z "$dataset_id" ]]; then
    echo "❌ [hf_dataset_info] 用法：hf_dataset_info DATASET_ID" >&2
    return 1
  fi

  local api_url="https://huggingface.co/api/datasets/${dataset_id}"

  curl -sf "$api_url" 2>/dev/null || {
    echo "❌ [hf_dataset_info] 無法取得資料集資訊：$dataset_id" >&2
    return 1
  }
}

########################################
# hf_parquet_to_jsonl PARQUET_FILE JSONL_FILE
#
# 功能：
#   - 將 Parquet 檔案轉換為 JSONL
#
# 參數：
#   PARQUET_FILE: 輸入 Parquet 檔案
#   JSONL_FILE: 輸出 JSONL 檔案
#
# 依賴：
#   Python 3 + pyarrow 或 pandas
#
# 回傳值：
#   0  = 成功
#   >0 = 失敗
########################################
hf_parquet_to_jsonl() {
  local parquet_file="$1"
  local jsonl_file="$2"

  if [[ -z "$parquet_file" || -z "$jsonl_file" ]]; then
    echo "❌ [hf_parquet_to_jsonl] 用法：hf_parquet_to_jsonl PARQUET_FILE JSONL_FILE" >&2
    return 1
  fi

  if [[ ! -f "$parquet_file" ]]; then
    echo "❌ [hf_parquet_to_jsonl] 檔案不存在：$parquet_file" >&2
    return 1
  fi

  # 嘗試使用 Python 轉換
  if command -v python3 >/dev/null 2>&1; then
    python3 - "$parquet_file" "$jsonl_file" << 'PYTHON_SCRIPT' 2>/dev/null && return 0
import sys
import json

parquet_file = sys.argv[1]
jsonl_file = sys.argv[2]

try:
    import pyarrow.parquet as pq
    table = pq.read_table(parquet_file)
    df = table.to_pandas()
except ImportError:
    try:
        import pandas as pd
        df = pd.read_parquet(parquet_file)
    except ImportError:
        print("❌ 需要安裝 pyarrow 或 pandas", file=sys.stderr)
        sys.exit(1)

with open(jsonl_file, 'w', encoding='utf-8') as f:
    for _, row in df.iterrows():
        f.write(json.dumps(row.to_dict(), ensure_ascii=False) + '\n')

print(f"✅ 轉換成功：{jsonl_file}", file=sys.stderr)
PYTHON_SCRIPT
  fi

  echo "❌ [hf_parquet_to_jsonl] 需要 Python 3 + pyarrow 或 pandas" >&2
  return 1
}
