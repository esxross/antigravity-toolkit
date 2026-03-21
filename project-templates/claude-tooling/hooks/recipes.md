# Hooks レシピ集

Claude Code の Hooks は `~/.claude/settings.json` または `.claude/settings.json` に設定する。
グローバル（全プロジェクト共通）は `~/.claude/settings.json`、プロジェクト固有は `.claude/settings.json`。

## Hook の種類

| Hook | タイミング | 主な用途 |
|------|----------|---------|
| `PreToolUse` | ツール実行前 | Safety Gate（危険コマンドのブロック） |
| `PostToolUse` | ツール実行後 | Quality Loop（lint・フォーマット・ルール違反検出） |
| `Stop` | セッション終了前 | Completion Gate（テスト・記録の確認） |
| `Notification` | 入力待ち時 | macOS 通知 |

---

## Recipe 1: 危険コマンドの Safety Gate（PreToolUse）

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash -c '\nCMD=\"$CLAUDE_TOOL_INPUT_COMMAND\"\nif echo \"$CMD\" | grep -qE \"(rm -rf /|git push --force|DROP TABLE|format C:)\"; then\n  echo \"{\\\"decision\\\": \\\"block\\\", \\\"reason\\\": \\\"危険なコマンドをブロックしました: $CMD\\\"}\"\nfi\n'"
          }
        ]
      }
    ]
  }
}
```

**ポイント:** `decision: block` を返すとツールの実行がキャンセルされる。

---

## Recipe 2: lint 自動実行（PostToolUse）

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash -c '\nFILE=\"$CLAUDE_TOOL_INPUT_FILE_PATH\"\nif [[ \"$FILE\" == *.ts || \"$FILE\" == *.tsx ]]; then\n  RESULT=$(npx oxlint \"$FILE\" --format json 2>/dev/null)\n  ERRORS=$(echo \"$RESULT\" | jq \".errors // 0\")\n  if [ \"$ERRORS\" -gt 0 ]; then\n    echo \"{\\\"hookSpecificOutput\\\": {\\\"additionalContext\\\": \\\"oxlint エラー: $RESULT\\\"}}\"\n  fi\nfi\n'"
          }
        ]
      }
    ]
  }
}
```

**ポイント:** `hookSpecificOutput.additionalContext` に文字列を返すと、Claude のコンテキストにフィードバックが注入される。

---

## Recipe 3: テスト完了確認 Stop Gate

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash -c '\nif git diff --quiet HEAD 2>/dev/null; then\n  exit 0\nfi\nif ! npm test --passWithNoTests 2>/dev/null; then\n  echo \"{\\\"decision\\\": \\\"block\\\", \\\"reason\\\": \\\"テストが失敗しています。修正してから終了してください。\\\"}\"\nfi\n'"
          }
        ]
      }
    ]
  }
}
```

---

## Recipe 4: macOS 通知（Notification）

```json
{
  "hooks": {
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e 'display notification \"Claude Code が入力待ちです\" with title \"Claude Code\"' 2>/dev/null || true"
          }
        ]
      }
    ]
  }
}
```

---

## フィードバックの返し方

| 返値 | 効果 |
|-----|------|
| `{"decision": "block", "reason": "..."}` | ツールをキャンセルして理由を表示 |
| `{"hookSpecificOutput": {"additionalContext": "..."}}` | Claude のコンテキストにフィードバックを注入（ツールは実行される） |
| 何も返さない | 何も起きない |
