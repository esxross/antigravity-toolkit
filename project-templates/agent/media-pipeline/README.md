# media-pipeline テンプレート

RSS → AI処理 → マルチフォーマット出力の自動コンテンツ生成パイプラインです。

## パイプライン概要

```
RSS フィード
  → Python スクリプト（収集）
  → Claude API（タグ付け・要約）
  → Gemini API（記事・ポスト・スクリプト生成）
  → Supabase（保存・重複排除）
  → 各プラットフォームへ配信
```

## セットアップ

### 必要なもの
- Anthropic API キー
- Google AI Studio API キー（Gemini）
- Supabase プロジェクト

### 手順
1. Supabase でテーブルを作成（`schema.sql` を実行）
2. `.env` に API キーを設定
3. `rss_feeds.yaml` に収集対象 RSS フィードを登録
4. GitHub Actions の Secrets に API キーを登録

## スケジュール設定

`.github/workflows/pipeline.yml` で cron を設定：

```yaml
schedule:
  - cron: '0 8 * * *'  # 毎日 08:00 UTC
```

## コスト目安

| API | 単価目安 | 月50件処理 |
|-----|---------|-----------|
| Claude API（Haiku） | ~$0.25/1M tokens | ~$1–5 |
| Gemini API | 無料枠あり | $0（無料枠内） |
| Supabase | 無料枠あり | $0（50万行以内） |
