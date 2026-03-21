# {{PROJECT_NAME}} — Harness Quality

## 概要
- **スタック**: {{TECH_STACK}}
- **目的**: {{PROJECT_DESCRIPTION}}
- **品質戦略**: Harness Engineering（決定論的ツールで品質を強制）

## ディレクトリ構成
```
src/           # アプリケーションコード
tests/         # テスト（unit / integration / e2e）
docs/
└── adr/       # アーキテクチャ決定記録
```

## コマンド
```bash
npm run dev         # 開発サーバー
npm test            # 全テスト実行
npm run test:unit   # ユニットテストのみ
npm run test:e2e    # E2Eテスト
npm run lint        # Lint（oxlint）
npm run typecheck   # 型チェック
npm run build       # ビルド
```

## 品質ルール
- コーディング規約 → `.claude/rules/coding.md`
- セキュリティ基準 → `.claude/rules/security.md`
- テスト方針 → `.claude/rules/testing.md`

## スキル
- テスト生成 → `/test-gen`
- 脆弱性スキャン → `/vuln-scan`
- コードレビュー → `/code-review`

## ADR
設計上の重要な決定は `docs/adr/` に記録する。
フォーマット: `docs/adr/NNNN-title.md`
