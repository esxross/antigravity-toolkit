#!/bin/bash
# gen-mcp.sh - ~/.antigravity/secrets.env から .mcp.json を生成する
# Usage: ./scripts/gen-mcp.sh

set -e

TOOLKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SECRETS_FILE="$HOME/.antigravity/secrets.env"
TEMPLATE="$TOOLKIT_DIR/.mcp.json.template"
OUTPUT="$TOOLKIT_DIR/.mcp.json"

if [ ! -f "$SECRETS_FILE" ]; then
  echo "エラー: $SECRETS_FILE が見つかりません。"
  echo "以下のコマンドで作成してください:"
  echo "  cp $TOOLKIT_DIR/.mcp.json.template $SECRETS_FILE"
  echo "  # その後、各キーを実際の値に書き換えてください"
  exit 1
fi

# secrets.env を読み込む（コメント・空行を除く）
declare -A SECRETS
while IFS='=' read -r key value; do
  [[ "$key" =~ ^#.*$ ]] && continue
  [[ -z "$key" ]] && continue
  SECRETS["$key"]="$value"
done < "$SECRETS_FILE"

# テンプレートを読み込んでプレースホルダーを置換
content=$(cat "$TEMPLATE")
for key in "${!SECRETS[@]}"; do
  content="${content//\{\{$key\}\}/${SECRETS[$key]}}"
done

echo "$content" > "$OUTPUT"
echo "✓ .mcp.json を生成しました（${#SECRETS[@]} 個のシークレットを適用）"

# プレースホルダーが残っていたら警告
if grep -q '{{' "$OUTPUT"; then
  echo "⚠️  未設定のプレースホルダーが残っています:"
  grep -o '{{[^}]*}}' "$OUTPUT" | sort -u
fi
