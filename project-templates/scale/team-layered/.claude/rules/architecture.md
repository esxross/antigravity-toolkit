---
description: アーキテクチャルール（server/以下のファイルを編集する際に適用）
paths:
  - "src/server/**"
---

# アーキテクチャルール

## レイヤー依存の方向
```
presentation → application → domain
                 infra     → domain
```

## 禁止事項
- `domain/` から `infra/` や `presentation/` を import しない
- `application/` から `infra/` の具体実装を直接 import しない
  （必ずインターフェース経由でDI）
- `presentation/` にビジネスロジックを書かない

## 命名規約
- ドメインモデル: `PascalCase`（例: `UserAccount`）
- ユースケース: `動詞 + 名詞 + UseCase`（例: `CreateUserUseCase`）
- リポジトリインターフェース: `I + 名前 + Repository`
- リポジトリ実装: `名前 + Repository`（Prisma, DynamoDB など接尾辞可）

## ファイル配置の原則
新機能を追加する際は以下の順に作成する：
1. `domain/` にモデルとゲートウェイインターフェースを定義
2. `application/` にユースケースを作成
3. `infra/` にリポジトリ実装を作成
4. `presentation/` にルートを追加

これにより複数のエージェントが並列に実装できる。
