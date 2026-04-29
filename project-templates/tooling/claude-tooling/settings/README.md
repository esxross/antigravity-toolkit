# settings.json の設定方法

## グローバル設定（全プロジェクト共通）

`~/.claude/settings.json` に設定する。

```bash
# global.json の内容を ~/.claude/settings.json にマージする
# ※ 既存の settings.json がある場合は手動でマージすること
cp global.json ~/.claude/settings.json
```

## statusLine の設定

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.py"
  }
}
```

スクリプトのコピーと権限設定：

```bash
# 好きなパターンを選ぶ
cp ../statusline/pattern5-braille.py ~/.claude/statusline.py
chmod +x ~/.claude/statusline.py
```

## 設定の確認

Claude Code を再起動すると反映される。ステータスバーに使用率が表示されれば成功。

表示されない場合：
1. `chmod +x ~/.claude/statusline.py` が設定されているか確認
2. スクリプトを直接実行して動作確認: `echo '{"model":{"display_name":"Claude"},"context_window":{"used_percentage":42},"rate_limits":{"five_hour":{"used_percentage":18},"seven_day":{"used_percentage":63}}}' | python3 ~/.claude/statusline.py`
