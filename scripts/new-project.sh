#!/bin/bash
# new-project.sh - 新規プロジェクト作成スクリプト
# Usage: ./scripts/new-project.sh

set -e

TOOLKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATES_DIR="$TOOLKIT_DIR/project-templates"
AI_CONFIG_DIR="$HOME/Project/ai-coding-config"
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

# ---- テンプレート選択（project-templates/category/name を自動検出）----
echo ""
echo "テンプレートを選択してください："

TEMPLATE_DIRS=()
i=1
while IFS= read -r dir; do
  category=$(basename "$(dirname "$dir")")
  tname=$(basename "$dir")
  rel_path="$category/$tname"
  tdesc=""
  if [[ -f "$dir/template.config.json" ]]; then
    tdesc=$(python3 -c "import json; d=json.load(open('$dir/template.config.json')); print(d.get('description',''))" 2>/dev/null)
  elif [[ -f "$dir/template.json" ]]; then
    tdesc=$(python3 -c "import json; d=json.load(open('$dir/template.json')); print(d.get('description',''))" 2>/dev/null)
  fi
  [[ -z "$tdesc" ]] && tdesc="$tname"
  echo "  $i) [$category] $tname  - $tdesc"
  TEMPLATE_DIRS+=("$rel_path")
  ((i++))
done < <(find "$TEMPLATES_DIR" -mindepth 2 -maxdepth 2 -type d ! -name '.*' | sort)

TEMPLATE_COUNT="${#TEMPLATE_DIRS[@]}"
read -p "番号を入力 [1-$TEMPLATE_COUNT]: " TEMPLATE_CHOICE

if ! [[ "$TEMPLATE_CHOICE" =~ ^[0-9]+$ ]] || \
   (( TEMPLATE_CHOICE < 1 || TEMPLATE_CHOICE > TEMPLATE_COUNT )); then
  echo "無効な選択です。"
  exit 1
fi

TEMPLATE="${TEMPLATE_DIRS[$((TEMPLATE_CHOICE - 1))]}"

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
cp -r "$TEMPLATES_DIR/.agent" "$PROJECT_DIR/.agent"

# ---- ai-coding-config セットアップ ----
if [[ -d "$AI_CONFIG_DIR" ]]; then
  # .mcp.json をコピー（単一正解ソース）
  cp "$AI_CONFIG_DIR/.mcp.json" "$PROJECT_DIR/.mcp.json"

  # .claude/rules/core/ シンボリックリンク
  mkdir -p "$PROJECT_DIR/.claude/rules/core" "$PROJECT_DIR/.claude/hooks"
  for rule in "$AI_CONFIG_DIR/rules/core/"*.md; do
    ln -s "$rule" "$PROJECT_DIR/.claude/rules/core/$(basename "$rule")"
  done

  # .claude/hooks/session-start.sh シンボリックリンク
  ln -s "$AI_CONFIG_DIR/hooks/session-start.sh" "$PROJECT_DIR/.claude/hooks/session-start.sh"

  # .claude/settings.json をコピー
  cp "$AI_CONFIG_DIR/templates/settings.json.template" "$PROJECT_DIR/.claude/settings.json"

  echo -e "${GREEN}✓ ai-coding-config をセットアップしました${NC}"
else
  echo -e "${YELLOW}⚠ ai-coding-config が見つかりません（$AI_CONFIG_DIR）${NC}"
  echo -e "${YELLOW}  .mcp.json はスキップされました${NC}"
fi

# ---- CLAUDE.md テンプレート変数を置換 ----
sed -i '' \
  -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
  -e "s/{{PROJECT_DESCRIPTION}}/$PROJECT_DESCRIPTION/g" \
  -e "s/{{CURRENT_DATE}}/$TODAY/g" \
  "$PROJECT_DIR/CLAUDE.md"

# ---- .gitignore を作成 ----
cat > "$PROJECT_DIR/.gitignore" << EOF
.mcp.json
.claude/settings.json
.env
.env.local
node_modules/
EOF

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
