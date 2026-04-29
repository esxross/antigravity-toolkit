# {{PROJECT_NAME}}

## 概要
- **目的**: {{PROJECT_DESCRIPTION}}
- **スタック**: Python / Claude API / Gemini API / Supabase / GitHub Actions
- **作成日**: {{CURRENT_DATE}}

## パイプライン構成

```
RSS収集
  → Claude API（タグ付け・要約）
  → Gemini API（コンテンツ生成）
  → Supabase（保存・重複排除）
```

## 出力フォーマット
- 記事（Markdown）
- X ポスト
- YouTube スクリプト
- ポッドキャスト原稿

## 実装ルール

### 重複排除
- Supabase で URL 単位の upsert を使う（`ON CONFLICT (url) DO UPDATE`）

### スケジュール
- GitHub Actions cron で定期実行する

### パイプライン制限
- 1回の実行で50件以上処理しない

## 禁止事項
- APIキーのハードコード（`.env` または GitHub Secrets のみ）
- 1回のパイプラインで50件以上処理する

## AIエージェントへの注意事項
- 作業前に `task.md` を確認・更新する
- API コスト確認後にバッチサイズを調整する
- Supabase の行数が上限（無料枠: 50万行）に近づいたらアーカイブ処理を追加する
