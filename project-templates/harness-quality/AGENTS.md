# AGENTS.md — Harness Quality

## Quality Philosophy
AIへの「お願い」ではなく、決定論的ツールで品質を強制する。

## Harness構成

| ツール | タイミング | 役割 |
|--------|-----------|------|
| oxlint | PostToolUse(Edit) | リアルタイムLint |
| tsc --noEmit | PostToolUse(Edit) | 型チェック |
| vitest | Stop Hook | 完了時テスト確認 |
| pre-commit hook | git commit前 | 最終品質ゲート |

## Agent Rules

### 必須
- リンターエラーはすぐに修正する（スキップ禁止）
- 型エラーを放置しない
- テストが落ちたままコミットしない
- `eslint-disable` / `@ts-ignore` は理由コメントが必要

### テスト
- 新機能は必ずテストを追加する
- 回帰バグには必ずテストを追加してから修正する
- DBのモックは使わない（実際のDBを使うインテグレーションテスト）

### セキュリティ
- ユーザー入力は必ずバリデーション（zod）
- SQLはパラメータバインディング必須
- 認証・決済コードは人間が手動レビューする

## Minimum Viable Harness (MVH)
Week 1: oxlint + tsc のPostToolUse Hook
Week 2: vitest の Stop Hook + pre-commit
Month 2: E2E（Playwright）+ カバレッジ閾値
Month 3+: アーキテクチャガードレール（カスタムリンター）
