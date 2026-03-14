#!/bin/bash
# new-project.sh - 新規プロジェクト作成スクリプト
# Usage: ./scripts/new-project.sh

set -e

TOOLKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATES_DIR="$TOOLKIT_DIR/project-templates"
TODAY=$(date +%Y-%m-%d)

# ---- カラー出力 ----
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Antigravity 新規プロジェクト作成ツール${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# ---- プロジェクト名 ----
read -p "プロジェクト名（英数字・ハイフン）: " PROJECT_NAME
if [[ -z "$PROJECT_NAME" ]]; then
  echo "プロジェクト名を入力してください。"
  exit 1
fi

# ---- プロジェクトの説明 ----
read -p "プロジェクトの説明（1行）: " PROJECT_DESCRIPTION

# ---- テンプレート選択 ----
echo ""
echo "テンプレートを選択してください："
echo "  1) nextjs-ai-app  - Next.js + TypeScript + Claude API"
echo "  2) landing-page   - Next.js + TypeScript + Tailwind（LP特化）"
read -p "番号を入力 [1-2]: " TEMPLATE_CHOICE

case "$TEMPLATE_CHOICE" in
  1) TEMPLATE="nextjs-ai-app" ;;
  2) TEMPLATE="landing-page" ;;
  *)
    echo "無効な選択です。"
    exit 1
    ;;
esac

# ---- 出力先ディレクトリ ----
read -p "作成先ディレクトリ（デフォルト: ~/Project）: " OUTPUT_DIR
OUTPUT_DIR="${OUTPUT_DIR:-$HOME/Project}"
PROJECT_DIR="$OUTPUT_DIR/$PROJECT_NAME"

echo ""
echo -e "${YELLOW}以下の設定でプロジェクトを作成します：${NC}"
echo "  プロジェクト名  : $PROJECT_NAME"
echo "  説明           : $PROJECT_DESCRIPTION"
echo "  テンプレート    : $TEMPLATE"
echo "  作成先          : $PROJECT_DIR"
echo ""
read -p "続行しますか？ [y/N]: " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "キャンセルしました。"
  exit 0
fi

# ---- ディレクトリ作成 ----
mkdir -p "$PROJECT_DIR"

# ---- テンプレートファイルをコピー ----
cp "$TEMPLATES_DIR/$TEMPLATE/CLAUDE.md" "$PROJECT_DIR/CLAUDE.md"
cp "$TEMPLATES_DIR/$TEMPLATE/AGENTS.md" "$PROJECT_DIR/AGENTS.md"

# ---- CLAUDE.md テンプレート変数を置換 ----
sed -i '' \
  -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
  -e "s/{{PROJECT_DESCRIPTION}}/$PROJECT_DESCRIPTION/g" \
  -e "s/{{CURRENT_DATE}}/$TODAY/g" \
  "$PROJECT_DIR/CLAUDE.md"

# ---- task.md を作成 ----
cat > "$PROJECT_DIR/task.md" << EOF
# タスク管理: $PROJECT_NAME

作成日: $TODAY
テンプレート: $TEMPLATE

## 進行中のタスク
- [ ] プロジェクト初期セットアップ

## 完了したタスク

## メモ
EOF

# ---- Git 初期化 ----
cd "$PROJECT_DIR"
git init -q
git add .
git commit -q -m "chore: initial setup from $TEMPLATE template"

echo ""
echo -e "${GREEN}✓ プロジェクトを作成しました: $PROJECT_DIR${NC}"
echo ""
echo "次のステップ："
echo "  cd $PROJECT_DIR"
echo "  # Claude Code でプロジェクトを開く"
echo "  claude ."
