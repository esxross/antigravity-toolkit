# AGENTS.md — Team Layered

## Project Context
- Architecture: レイヤードアーキテクチャ（server/client 分離）
- Dependency direction: presentation → application → domain ← infra

## レイヤー責務（厳守）

| レイヤー | 何を置くか | 依存してよいもの |
|---------|-----------|----------------|
| domain | モデル・値オブジェクト・ドメインサービス | なし |
| application | ユースケース・DTOインターフェース | domain |
| infra | DBクライアント・外部API実装 | domain |
| presentation | ルート・コントローラー | application |

## Agent Rules

### 必須
- レイヤーを越えた依存は作らない（domain→infraは禁止）
- ユースケースは1つの責務のみ持つ
- `main` への直接 push 禁止
- テストなしで新機能を追加しない

### コードレビュー観点
- レイヤー境界の違反がないか
- ドメインロジックがinfraに漏れていないか
- テストカバレッジが重要パスに対して十分か

## Agent Role Design
```
Lead Agent (Opus)      → アーキテクチャ判断・PRレビュー
Feature Agents (Sonnet) → 各BC（境界コンテキスト）の実装
Test Agent (Sonnet)    → テスト生成・カバレッジ確認
```
