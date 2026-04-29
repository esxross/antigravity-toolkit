#!/bin/bash
# Claude Code Tooling セットアップスクリプト
# 使い方: ./setup.sh [pattern番号: 1-5]

set -euo pipefail

PATTERN=${1:-5}
CLAUDE_DIR="${HOME}/.claude"

echo "Claude Code Tooling セットアップ"
echo "================================"

# ~/.claude ディレクトリの確認
if [ ! -d "$CLAUDE_DIR" ]; then
  echo "エラー: $CLAUDE_DIR が存在しません。Claude Code をインストールしてください。"
  exit 1
fi

# statusline スクリプトのコピー
SCRIPT_SRC="statusline/pattern${PATTERN}-$(ls statusline/ | grep "^pattern${PATTERN}" | sed 's/pattern[0-9]*-//')"

if [ ! -f "$SCRIPT_SRC" ]; then
  echo "エラー: パターン $PATTERN が見つかりません (1-5 で指定してください)"
  exit 1
fi

echo "statusline: pattern${PATTERN} をインストール中..."
cp "$SCRIPT_SRC" "${CLAUDE_DIR}/statusline.py"
chmod +x "${CLAUDE_DIR}/statusline.py"
echo "  → ${CLAUDE_DIR}/statusline.py"

# settings.json の statusLine 設定を追加
SETTINGS_FILE="${CLAUDE_DIR}/settings.json"

if [ -f "$SETTINGS_FILE" ]; then
  # 既存の settings.json に statusLine が存在するか確認
  if python3 -c "import json,sys; d=json.load(open('$SETTINGS_FILE')); sys.exit(0 if 'statusLine' in d else 1)" 2>/dev/null; then
    echo "settings.json: statusLine は既に設定済みです（スキップ）"
  else
    echo "settings.json: statusLine を追加中..."
    python3 - <<'EOF'
import json

settings_file = "$SETTINGS_FILE"
with open(settings_file) as f:
    settings = json.load(f)

settings['statusLine'] = {
    'type': 'command',
    'command': '~/.claude/statusline.py'
}

with open(settings_file, 'w') as f:
    json.dump(settings, f, indent=2, ensure_ascii=False)
    f.write('\n')

print(f"  → {settings_file} を更新しました")
EOF
  fi
else
  echo "settings.json: 新規作成中..."
  python3 -c "
import json
settings = {'statusLine': {'type': 'command', 'command': '~/.claude/statusline.py'}}
with open('$SETTINGS_FILE', 'w') as f:
    json.dump(settings, f, indent=2, ensure_ascii=False)
    f.write('\n')
print('  → $SETTINGS_FILE を作成しました')
"
fi

echo ""
echo "完了。Claude Code を再起動するとステータスラインが表示されます。"
echo ""
echo "動作確認:"
echo "  echo '{\"model\":{\"display_name\":\"Claude\"},\"context_window\":{\"used_percentage\":42},\"rate_limits\":{\"five_hour\":{\"used_percentage\":18},\"seven_day\":{\"used_percentage\":63}}}' | python3 ~/.claude/statusline.py"
