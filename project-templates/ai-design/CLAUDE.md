# {{PROJECT_NAME}} — AI Design System

## 概要
- **スタック**: {{TECH_STACK}}（Tailwind CSS前提）
- **目的**: {{PROJECT_DESCRIPTION}}
- **デザイン方針**: AIが読めるデザインシステムで品質を安定化

## デザインシステムの読み方

> **まずここを読む**: `design/CLAUDE-design.md`
> AIにUIを生成させる前に、必ずこのファイルをコンテキストに含めること。

```
design/
├── CLAUDE-design.md   # ← AIへのクイックリファレンス（最重要）
├── tokens.json        # デザイントークン SSOT（唯一の真実の源）
├── patterns/
│   ├── form.md        # フォーム系コンポーネント
│   ├── card.md        # カード系コンポーネント
│   ├── table.md       # テーブル系コンポーネント
│   └── lp-structure.md # LP骨組み（マーケター向け）
└── content/
    └── template.md    # コンテンツ原稿テンプレート（可変部分）
```

## コマンド
```bash
npm run dev    # 開発サーバー
npm run build  # ビルド
npm run lint   # Lint
```

## スキル
- UIレビュー → `/design-review`（禁止パターン違反を自動チェック）
- 禁止パターン追加 → `/ban-pattern`
- LP生成 → `/gen-lp`

## ⚠️ デザイン変更時の注意
色・スペーシング・フォントを変更する場合は `design/tokens.json` のみを変更する。
コードに直接 `#2250df` などのハードコードカラーを書かない。
