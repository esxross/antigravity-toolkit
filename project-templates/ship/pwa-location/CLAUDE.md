# {{PROJECT_NAME}}

## 概要
- **目的**: {{PROJECT_DESCRIPTION}}
- **スタック**: TypeScript / Vanilla JS / Google Places API (New) / PWA
- **作成日**: {{CURRENT_DATE}}

## 必須API
- Places API (New)（Nearby Search）

## FieldMask 必須フィールド

```
places.id,places.displayName,places.rating,places.userRatingCount,places.formattedAddress,places.types,places.primaryType,places.currentOpeningHours,places.photos,places.googleMapsUri,places.location
```

## 実装ルール

### ソート
- ソートはフロントエンド側で実装する（Places APIはソート順指定不可）

### APIキー管理
- 開発時: `localStorage` に保存
- 本番: **Cloudflare Workers プロキシ必須**（APIキーをフロントエンドに露出しない）

### PWA要件
- `manifest.json` を含める
- Service Worker で静的アセット（HTML/CSS/JS）をキャッシュする

## 禁止事項
- APIレスポンスのキャッシュ・永続保存（Places API利用規約違反）
- APIキーのハードコード

## AIエージェントへの注意事項
- 作業前に `task.md` を確認・更新する
- FieldMask の変更は必ずコスト影響を確認する
- 本番デプロイ時は必ず Cloudflare Workers プロキシを経由する
