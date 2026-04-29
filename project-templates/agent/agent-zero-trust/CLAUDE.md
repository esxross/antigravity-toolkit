# Agent Zero Trust — エージェント専用ゼロトラスト環境

## このテンプレートの目的
Claude エージェントがサーバー（EC2 等）で動作する際の、最小権限・最大監査のセキュリティ構成。
インバウンドを完全封鎖し、Tailscale VPN 経由のみでアクセスを許可する。

## セキュリティ原則

| 原則 | 内容 |
|------|------|
| **アカウント分離** | AI 専用の AWS/GCP アカウントを人間用アカウントと分ける |
| **インバウンド完全封鎖** | セキュリティグループのインバウンドルールをすべて空にする（SSH も不要） |
| **Tailscale のみ許可** | サーバーアクセスは Tailscale VPN 経由のみ |
| **シークレットは Keychain** | APIキー・トークンは OS の Keychain/Secrets Manager に保存 |
| **監査ログ分離** | AI の操作ログを人間の操作ログと別ストリームに記録 |

## ディレクトリ構造

```
agent-zero-trust/
├── CLAUDE.md          ← このファイル
├── AGENTS.md          ← エージェント役割定義
├── setup/
│   ├── tailscale.md   ← Tailscale セットアップ手順
│   ├── aws-iam.md     ← IAM 最小権限設定
│   └── keychain.md    ← シークレット管理手順
├── .claude/
│   ├── rules/
│   │   └── security.md
│   ├── settings.json
│   └── skills/
│       ├── security-scan/SKILL.md
│       └── audit-log/SKILL.md
└── task.md
```

## セッション開始時の必読
1. `setup/tailscale.md` — VPN 接続状態の確認
2. `.claude/rules/security.md` — 禁止操作の確認

## コマンド
```bash
# セキュリティスキャン
/security-scan

# 監査ログ確認
/audit-log

# Tailscale 接続確認
tailscale status
```

## ⚠️ 重要: 認証・権限のコードは必ず人間がレビュー
IAM ポリシー・Tailscale ACL・SSH 設定の変更は AI が単独で行わない。
