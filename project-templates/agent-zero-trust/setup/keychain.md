# シークレット管理 — AI エージェント環境

## 原則
**AIエージェントが使うシークレットはコードに書かない。**
環境変数への直接設定も避け、OS/クラウドの Secrets Manager を使う。

## macOS ローカル開発（Keychain）

```bash
# シークレットを保存
security add-generic-password \
  -a "claude-agent" \
  -s "OPENAI_API_KEY" \
  -w "sk-..." \
  -T ""

# シークレットを取得（スクリプト内）
OPENAI_API_KEY=$(security find-generic-password \
  -a "claude-agent" \
  -s "OPENAI_API_KEY" \
  -w)

export OPENAI_API_KEY
```

## 本番環境（AWS Secrets Manager）

```bash
# シークレットを保存
aws secretsmanager create-secret \
  --name "claude-agent/openai-api-key" \
  --secret-string "sk-..."

# アプリケーションから取得
import boto3
client = boto3.client("secretsmanager", region_name="ap-northeast-1")
secret = client.get_secret_value(SecretId="claude-agent/openai-api-key")
api_key = secret["SecretString"]
```

## 管理すべきシークレット一覧

| シークレット名 | 用途 | ローテーション |
|-------------|------|-------------|
| `openai-api-key` | OpenAI API | 90日 |
| `anthropic-api-key` | Claude API | 90日 |
| `github-pat` | GitHub アクセス | 90日 |
| `tailscale-auth-key` | Tailscale VPN | 90日 |
| `db-password` | データベース | 30日 |

## シークレット漏洩時の対応

1. **即座に無効化** — 該当サービスのダッシュボードでキーを無効化
2. **ログ確認** — CloudTrail/監査ログで不正利用がないか確認
3. **新しいキーを発行** — Secrets Manager に新しい値をセット
4. **原因調査** — どこで漏洩したか特定（コミット履歴を確認）
5. **git-secrets で再発防止** — `git secrets --install` でコミット時チェックを有効化

## .env ファイルの扱い

```
.env           ← 実際の値（.gitignore に追加必須）
.env.example   ← プレースホルダーのみ（コミットOK）
```

`.env` を誤ってコミットした場合:
```bash
# git-filter-repo で履歴から削除
pip install git-filter-repo
git filter-repo --path .env --invert-paths
```
