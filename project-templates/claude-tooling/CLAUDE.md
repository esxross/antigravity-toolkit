# Claude Code Tooling — Claude Code 環境カスタマイズ

## このテンプレートの目的
他のテンプレートが「Claude Code でプロジェクトを作る」のに対して、
このテンプレートは **Claude Code 自体の体験をカスタマイズする** ためのレシピ集。

## 含まれるもの

| ディレクトリ | 内容 |
|------------|------|
| `statusline/` | 使用量・コンテキスト使用率の可視化スクリプト（5パターン） |
| `hooks/` | PreToolUse / PostToolUse / Stop / Notification フックレシピ |
| `settings/` | 用途別 settings.json テンプレート |
| `skills/` | グローバルスキル（全プロジェクト共通） |

## インストール

```bash
# 選んだファイルを ~/.claude/ にコピーする
./setup.sh
```

または個別に配置する：

```bash
# statusline のみ
cp statusline/pattern5-braille.py ~/.claude/statusline.py
chmod +x ~/.claude/statusline.py

# ~/.claude/settings.json に statusLine を追加
# → settings/README を参照
```

## statusline の仕組み

Claude Code v2.1.80 以降、ステータスラインに以下のフィールドが渡される：

```json
{
  "model": { "display_name": "Claude Sonnet 4.6" },
  "context_window": { "used_percentage": 42.3 },
  "rate_limits": {
    "five_hour": { "used_percentage": 18.5, "resets_at": 1774036800 },
    "seven_day": { "used_percentage": 63.2, "resets_at": 1774580400 }
  }
}
```

表示したいフィールドを Python スクリプトで整形して stdout に出力するだけ。

## セッション開始時の確認
- `~/.claude/settings.json` の `statusLine` 設定が有効になっているか確認
- `chmod +x ~/.claude/statusline.py` が設定されているか確認
