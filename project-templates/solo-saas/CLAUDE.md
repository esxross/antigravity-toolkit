# {{PROJECT_NAME}}

## 概要
- **スタック**: {{TECH_STACK}}
- **目的**: {{PROJECT_DESCRIPTION}}

## ディレクトリ構成
```
src/
├── app/          # ルーティング・ページ
├── components/   # UIコンポーネント
├── lib/          # ビジネスロジック・外部API
└── types/        # 型定義
```

## 起動・テストコマンド
```bash
npm run dev      # 開発サーバー
npm run build    # ビルド
npm test         # テスト実行
npm run lint     # Lint
```

## AIエージェントへの注意事項
- コーディングルール → `.claude/rules/coding.md`
- コミット手順 → `/commit` スキルを使う
- 作業前に `task.md` を確認・更新する
- APIキーは `.env.local` のみ（コードにハードコード禁止）
