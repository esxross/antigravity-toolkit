# {{PROJECT_NAME}} — Multi-Agent Setup

## 概要
- **スタック**: {{TECH_STACK}}
- **目的**: {{PROJECT_DESCRIPTION}}
- **開発スタイル**: サブエージェント・Agent Teams 活用

## ディレクトリ構成
```
src/
├── features/         # 機能別境界コンテキスト（BC）
│   ├── {{BC_NAME}}/  # 各BCは独立（並列実装可能）
│   │   ├── domain/
│   │   ├── application/
│   │   ├── infra/
│   │   └── presentation/
└── shared/           # 共有モジュール（触るときは要注意）
```

## エージェント構成
→ `.claude/agents/` に各エージェント定義

| エージェント | モデル | 役割 |
|------------|--------|------|
| orchestrator | Opus | 全体計画・コンテキスト管理 |
| implementer | Sonnet | 各BC実装 |
| reviewer | Sonnet | コードレビュー・品質確認 |
| tester | Sonnet | テスト生成・実行 |

## 並列開発フロー
1. `/plan` でタスクを設計・BC間インターフェースを決める
2. BC単位でサブエージェントに割り当て（並列実行）
3. 各BCが完成したら reviewer エージェントでレビュー
4. 統合して E2E テスト

## コマンド
```bash
npm run dev    # 開発サーバー
npm test       # テスト
npm run lint   # Lint
```
