#!/bin/bash
# gen-mcp.sh - ~/.antigravity/secrets.env から .mcp.json を生成し、全プロジェクトにシンボリックリンクを張る
# Usage: ./scripts/gen-mcp.sh

set -e

TOOLKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SECRETS_FILE="$HOME/.antigravity/secrets.env"
TEMPLATE="$TOOLKIT_DIR/.mcp.json.template"
CENTRAL="$HOME/.antigravity/mcp.json"              # Claude Code 用一元管理ファイル
GEMINI_TEMPLATE="$TOOLKIT_DIR/gemini-mcp.json.template"
GEMINI_CENTRAL="$HOME/.antigravity/gemini-mcp.json" # Gemini/Antigravity 用一元管理ファイル
GEMINI_TARGET="$HOME/.gemini/antigravity/mcp_config.json"
SCAN_DIR="$HOME/Project"                            # シンボリックリンクを張るプロジェクトの検索先

if [ ! -f "$SECRETS_FILE" ]; then
  echo "エラー: $SECRETS_FILE が見つかりません。"
  exit 1
fi

# --- 1. ~/.antigravity/mcp.json を生成 ---
cp "$TEMPLATE" "$CENTRAL"

while IFS='=' read -r key value; do
  [[ "$key" =~ ^#.*$ ]] && continue
  [[ -z "$key" ]] && continue
  key="${key%"${key##*[![:space:]]}"}"
  value="${value%"${value##*[![:space:]]}"}"
  sed -i "" "s|{{${key}}}|${value}|g" "$CENTRAL"
done < "$SECRETS_FILE"

echo "✓ ~/.antigravity/mcp.json を生成しました"

# 未設定チェック
if grep -q '{{' "$CENTRAL"; then
  echo "⚠️  未設定のプレースホルダーが残っています:"
  grep -o '{{[^}]*}}' "$CENTRAL" | sort -u
fi

# --- 2. 全プロジェクトにシンボリックリンクを張る ---
echo ""
echo "シンボリックリンクを作成中..."

find "$SCAN_DIR" -name ".mcp.json" -not -path "*/node_modules/*" | while read -r target; do
  dir="$(dirname "$target")"
  # すでにシンボリックリンクなら skip
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$CENTRAL" ]; then
    echo "  スキップ（既にリンク済み）: $dir"
    continue
  fi
  # 実ファイルならバックアップ
  if [ -f "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "${target}.bak"
    echo "  バックアップ: ${target}.bak"
  fi
  ln -sf "$CENTRAL" "$target"
  echo "  ✓ リンク作成: $dir/.mcp.json → ~/.antigravity/mcp.json"
done

# toolkit 自身（.mcp.json がない場合も作成）
TOOLKIT_MCP="$TOOLKIT_DIR/.mcp.json"
if [ ! -L "$TOOLKIT_MCP" ] || [ "$(readlink "$TOOLKIT_MCP")" != "$CENTRAL" ]; then
  [ -f "$TOOLKIT_MCP" ] && [ ! -L "$TOOLKIT_MCP" ] && mv "$TOOLKIT_MCP" "${TOOLKIT_MCP}.bak"
  ln -sf "$CENTRAL" "$TOOLKIT_MCP"
  echo "  ✓ リンク作成: antigravity-toolkit/.mcp.json → ~/.antigravity/mcp.json"
fi

# --- 3. ~/.antigravity/gemini-mcp.json を生成 ---
cp "$GEMINI_TEMPLATE" "$GEMINI_CENTRAL"

while IFS='=' read -r key value; do
  [[ "$key" =~ ^#.*$ ]] && continue
  [[ -z "$key" ]] && continue
  key="${key%"${key##*[![:space:]]}"}"
  value="${value%"${value##*[![:space:]]}"}"
  sed -i "" "s|{{${key}}}|${value}|g" "$GEMINI_CENTRAL"
done < "$SECRETS_FILE"

echo "✓ ~/.antigravity/gemini-mcp.json を生成しました"

if grep -q '{{' "$GEMINI_CENTRAL"; then
  echo "⚠️  未設定のプレースホルダーが残っています:"
  grep -o '{{[^}]*}}' "$GEMINI_CENTRAL" | sort -u
fi

# --- 4. ~/.gemini/antigravity/mcp_config.json にシンボリックリンクを張る ---
echo ""
echo "Gemini シンボリックリンクを作成中..."

if [ -L "$GEMINI_TARGET" ] && [ "$(readlink "$GEMINI_TARGET")" = "$GEMINI_CENTRAL" ]; then
  echo "  スキップ（既にリンク済み）: $GEMINI_TARGET"
else
  [ -f "$GEMINI_TARGET" ] && [ ! -L "$GEMINI_TARGET" ] && mv "$GEMINI_TARGET" "${GEMINI_TARGET}.bak" && echo "  バックアップ: ${GEMINI_TARGET}.bak"
  ln -sf "$GEMINI_CENTRAL" "$GEMINI_TARGET"
  echo "  ✓ リンク作成: $GEMINI_TARGET → ~/.antigravity/gemini-mcp.json"
fi

echo ""
echo "完了。次回からキー更新は ~/.antigravity/secrets.env を編集して make gen-mcp を実行してください。"
