# {{PROJECT_NAME}}

## 概要
- **スタック**: {{TECH_STACK}}
- **目的**: {{PROJECT_DESCRIPTION}}
- **アーキテクチャ**: レイヤードアーキテクチャ（DDD風）

## ディレクトリ構成
```
src/
├── server/
│   ├── domain/       # ドメインモデル・ビジネスルール
│   ├── application/  # ユースケース（UseCase層）
│   ├── infra/        # DB・外部APIの実装
│   └── presentation/ # ルート・コントローラー
└── client/
    ├── components/   # UIコンポーネント
    ├── hooks/        # カスタムフック
    └── lib/          # クライアントユーティリティ
```

## コマンド
```bash
npm run dev    # 開発サーバー
npm test       # テスト
npm run lint   # Lint（oxlint）
npm run build  # ビルド
```

## ルールと参照先
- アーキテクチャルール → `.claude/rules/architecture.md`
- テスト方針 → `.claude/rules/testing.md`
- コードレビュー → `/code-review` スキル
- ADR（設計決定記録） → `docs/adr/`
