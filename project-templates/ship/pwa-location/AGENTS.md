# AGENTS.md — pwa-location

## Project Context
- Stack: TypeScript / Vanilla JS / Google Places API (New) / Geolocation API / PWA
- Architecture: 静的ファイル構成（HTML + TS/JS + CSS）+ Service Worker
- Deploy: Cloudflare Pages + Workers（APIプロキシ）

## Agent Rules

### 必須
- `main` への直接 push 禁止（ブランチで作業）
- API キーはコードにハードコードしない（`localStorage` または環境変数のみ）
- 完了前にブラウザで動作確認する（Geolocation・PWA インストール動作を含む）

### Places API ルール
- FieldMask は `CLAUDE.md` 記載の必須フィールドのみ指定する（過剰取得しない）
- API レスポンスをキャッシュ・永続保存しない（利用規約違反）
- ソートロジックはフロントエンドで実装する

### PWA ルール
- `manifest.json` の `start_url` と `scope` を正しく設定する
- Service Worker は静的アセットのみキャッシュし、API レスポンスはキャッシュしない

## 優先順位
1. 動くこと（位置情報取得・スポット表示）
2. セキュリティ（API キーの保護）
3. PWA 対応（オフライン表示・インストール可能）
4. コード品質
