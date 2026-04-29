---
description: ゼロトラスト環境でのセキュリティルール
---

# セキュリティルール — Zero Trust

## 絶対禁止

- APIキー・パスワードをコードにハードコードする
- セキュリティグループのインバウンドルールを追加する
- IAM ロールに `*` 権限を付与する
- スキャン結果（Trivy/Semgrep）にエラーがある状態でデプロイする
- `sudo` コマンドを使わずに済む方法があるのに使う
- 監査ログを停止・削除する

## シークレット管理

```bash
# 正しい: Keychain/Secrets Manager から取得
OPENAI_API_KEY=$(security find-generic-password -a claude-agent -s OPENAI_API_KEY -w)

# 間違い: コードに直書き
OPENAI_API_KEY="sk-..."  # ← 禁止

# 間違い: .env ファイルをコミット
git add .env  # ← 禁止
```

## コード変更前のスキャン義務

セキュリティに関わるコードを変更する前後に必ずスキャンを実行する：

```bash
# コンテナイメージのスキャン
trivy image <IMAGE_NAME>

# ソースコードの静的解析
semgrep --config=auto .

# npm 依存関係の脆弱性チェック
npm audit --audit-level=high
```

HIGH 以上の脆弱性がある場合はデプロイしない。

## ネットワーク変更時の必須確認

以下を変更する場合は **必ず人間のレビューを得る**：
- セキュリティグループのルール
- Tailscale ACL
- IAM ポリシー
- VPC ルーティング設定

## 監査ログの記録義務

AI が実行した以下の操作は CloudWatch Logs に記録される：
- ファイル作成・変更・削除
- 外部 API コール
- データベース操作
- git 操作

ログは 90 日間保存し、削除・改ざんは禁止。
