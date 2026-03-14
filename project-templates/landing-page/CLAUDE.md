# {{PROJECT_NAME}} - Landing Page

## プロジェクト概要
- **スタック**: Next.js 14, TypeScript, Tailwind CSS
- **目的**: {{PROJECT_DESCRIPTION}}
- **ターゲット**: {{TARGET_AUDIENCE}}

## ディレクトリ構成
```
src/
├── app/
│   └── page.tsx    # メインLPページ
├── components/
│   ├── Hero.tsx
│   ├── Features.tsx
│   ├── Pricing.tsx
│   └── CTA.tsx
└── lib/
    └── analytics.ts
```

## デザイン規約
- モバイルファーストでレスポンシブ対応
- Tailwind CSS のユーティリティクラスを使用
- カラーパレットは `tailwind.config.ts` で定義
- フォントは Next.js の `next/font` で最適化

## AIエージェントへの指示
- SEO対応を必ず考慮する（メタタグ・OGP・構造化データ）
- Core Web Vitals（LCP・CLS・FID）を意識した実装をする
- 画像は `next/image` を使用して最適化する
- CTA（コール・トゥ・アクション）は明確に配置する
