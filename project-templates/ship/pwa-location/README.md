# pwa-location テンプレート

位置情報 × Google Places API (New) × PWA。現在地から近くのスポットをジャンル・ソートで検索できる Web アプリのテンプレートです。

## セットアップ

### 必要なもの
- Google Maps Platform アカウント
- Places API (New) を有効化した API キー

### 手順
1. [Google Cloud Console](https://console.cloud.google.com/) で Places API (New) を有効化
2. API キーを取得
3. アプリを開き、設定画面で API キーを入力（localStorage に保存）

## コスト試算

| 機能 | 単価 | 月100リクエスト |
|------|------|----------------|
| Nearby Search | $0.032/req | ~$3.2 |
| Place Photos | $0.007/req | ~$0.7 |

- 月 $200 まで無料枠あり（約6,200 リクエスト相当）

## デプロイ

### Cloudflare Pages（推奨）
```bash
# ビルド不要（静的ファイル）
# Cloudflare Workers で API キーをプロキシする
wrangler deploy
```

### 本番環境の注意
- API キーは Cloudflare Workers 経由でプロキシし、フロントエンドに露出させない
- API レスポンスのキャッシュ・保存は Places API 利用規約違反のため禁止
