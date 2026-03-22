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
  echo "  mkdir -p ~/.antigravity"
  echo "  # その後、各キーを実際の値に書き換えてください"
  exit 1
fi

# テンプレートをコピーしてから sed で置換
cp "$TEMPLATE" "$OUTPUT"

# secrets.env を1行ずつ読んでプレースホルダーを置換
while IFS='=' read -r key value; do
  # コメント・空行をスキップ
  [[ "$key" =~ ^#.*$ ]] && continue
  [[ -z "$key" ]] && continue
  # 末尾の空白を除去
  key="${key%"${key##*[![:space:]]}"}"
  value="${value%"${value##*[![:space:]]}"}"
  # sed で {{KEY}} を value に置換（macOS 互換）
  sed -i "" "s|{{${key}}}|${value}|g" "$OUTPUT"
done < "$SECRETS_FILE"

echo "✓ .mcp.json を生成しました"

# プレースホルダーが残っていたら警告
if grep -q '{{' "$OUTPUT"; then
  echo "⚠️  未設定のプレースホルダーが残っています:"
  grep -o '{{[^}]*}}' "$OUTPUT" | sort -u
fi
