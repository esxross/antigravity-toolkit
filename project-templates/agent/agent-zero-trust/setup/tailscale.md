# Tailscale セットアップ — AI エージェント環境

## 設計思想
SSH を含むすべてのインバウンドポートを閉じ、Tailscale VPN 経由のみでサーバーにアクセスする。
インターネットから直接接続できるポートは存在しない。

## セキュリティグループ設定（EC2）

```
インバウンドルール: なし（完全に空）
アウトバウンドルール: 0.0.0.0/0 (すべて許可)
```

Tailscale はアウトバウンド接続を使って VPN を確立するため、インバウンドは不要。

## EC2 へのインストール

```bash
# Amazon Linux 2023 / Ubuntu の場合
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up --authkey=<TAILSCALE_AUTH_KEY> --hostname=claude-agent-prod
```

## Tailscale ACL 設定

`tailscale.com/admin/acls` で以下を設定する：

```json
{
  "acls": [
    {
      "action": "accept",
      "src": ["tag:human"],
      "dst": ["tag:ai-agent:22", "tag:ai-agent:8080"]
    },
    {
      "action": "deny",
      "src": ["*"],
      "dst": ["tag:ai-agent:*"]
    }
  ],
  "tagOwners": {
    "tag:ai-agent": ["autogroup:admin"],
    "tag:human": ["autogroup:admin"]
  }
}
```

**解説:**
- `tag:human` タグのデバイスのみ `tag:ai-agent` への SSH (22) と API (8080) を許可
- それ以外はすべて deny

## AI エージェントの Tailscale 認証キー管理

```bash
# 認証キーは AWS Secrets Manager に保存
aws secretsmanager create-secret \
  --name "claude-agent/tailscale-auth-key" \
  --secret-string "<TAILSCALE_AUTH_KEY>"

# EC2 UserData で取得して使用
AUTH_KEY=$(aws secretsmanager get-secret-value \
  --secret-id "claude-agent/tailscale-auth-key" \
  --query SecretString --output text)
sudo tailscale up --authkey="$AUTH_KEY"
```

## 接続確認

```bash
# Tailscale ネットワーク内のデバイス一覧
tailscale status

# 特定のデバイスへの接続確認
tailscale ping claude-agent-prod

# Tailscale IP で SSH
ssh ubuntu@100.x.x.x
```

## ローテーション手順

Tailscale 認証キーは 90 日ごとにローテーションする：

1. `tailscale.com/admin/settings/keys` で新しいキーを生成
2. AWS Secrets Manager の値を更新
3. `sudo tailscale logout && sudo tailscale up --authkey=<NEW_KEY>` で再認証
4. 古いキーを無効化
