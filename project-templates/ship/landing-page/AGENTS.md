# AGENTS.md - Landing Page

## Project Context
- Stack: Next.js 14, TypeScript, Tailwind CSS
- Goal: 高コンバージョンのランディングページ
- SEO: 必須対応

## Agent Rules

### 必須ルール
- モバイルファーストで実装する
- 全ページで Lighthouse スコア 90+ を維持する
- `main` への直接 push 禁止

### コンテンツ生成ルール
- ヘッドコピーは価値提案を明確に伝える
- CTAボタンのテキストは行動を促す動詞から始める（例: 「今すぐ試す」「無料で始める」）
- 社会的証明（お客様の声・実績数値）は必ず含める

### 実装ルール
- アニメーションは `prefers-reduced-motion` を考慮する
- 外部スクリプトは `strategy="lazyOnload"` で遅延ロード
- フォームバリデーションはサーバーサイドも実施する

## Agent Role Design
```
Lead Agent (Sonnet)    → コンテンツ設計・UX判断
Teammate Agents (Haiku) → コンポーネント実装・SEO設定
```
