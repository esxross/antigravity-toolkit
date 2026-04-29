# AGENTS.md — Solo SaaS

## Project Context
- Stack: {{TECH_STACK}}
- Architecture: シンプル・機能優先
- Testing: Vitest / Jest

## Agent Rules

### 必須
- `main` への直接 push 禁止（ブランチで作業）
- APIキーをコードにハードコードしない
- 完了前に `npm run build` を実行して確認

### コード品質
- 型 `any` は使わない
- 未使用のimport・変数は残さない
- エラーハンドリングを必ず行う

### Claude API 使用（使う場合）
- 軽量タスク: `claude-haiku-4-5`
- 標準タスク: `claude-sonnet-4-6`
- 複雑なタスク: `claude-opus-4-6`

## 優先順位
1. 動くこと（機能完成）
2. セキュリティ（認証・データ保護）
3. コード品質
4. パフォーマンス
