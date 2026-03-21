# AWS IAM 最小権限設定 — AI エージェント環境

## AI エージェント用 IAM ロール

AI エージェントには専用の IAM ロールを作成し、必要最小限の権限のみを付与する。

## IAM ロール作成

```json
{
  "RoleName": "ClaudeAgentRole",
  "AssumeRolePolicyDocument": {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
}
```

## 最小権限ポリシー例

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowSecretsRead",
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue"
      ],
      "Resource": "arn:aws:secretsmanager:ap-northeast-1:*:secret:claude-agent/*"
    },
    {
      "Sid": "AllowS3WorkdirAccess",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::claude-agent-workdir",
        "arn:aws:s3:::claude-agent-workdir/*"
      ]
    },
    {
      "Sid": "AllowCloudWatchLogging",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:ap-northeast-1:*:log-group:/claude-agent/*"
    }
  ]
}
```

## 明示的に拒否するアクション

```json
{
  "Sid": "DenyDangerousActions",
  "Effect": "Deny",
  "Action": [
    "iam:*",
    "ec2:AuthorizeSecurityGroupIngress",
    "ec2:CreateKeyPair",
    "s3:DeleteBucket",
    "cloudtrail:StopLogging",
    "cloudtrail:DeleteTrail",
    "sts:AssumeRole"
  ],
  "Resource": "*"
}
```

## CloudTrail 設定（AI 専用監査ログ）

```bash
aws cloudtrail create-trail \
  --name "claude-agent-audit" \
  --s3-bucket-name "claude-agent-audit-logs" \
  --is-multi-region-trail \
  --include-global-service-events

aws cloudtrail start-logging --name "claude-agent-audit"
```

## 権限レビュー（定期チェック）

```bash
# IAM Access Analyzer でポリシーを分析
aws accessanalyzer create-analyzer \
  --analyzer-name "claude-agent-analyzer" \
  --type ACCOUNT

# 未使用の権限を検出
aws accessanalyzer list-findings \
  --analyzer-arn "arn:aws:access-analyzer:..."
```
