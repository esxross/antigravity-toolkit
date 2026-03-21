---
name: audit-log
description: AI エージェントの操作監査ログをレビューする。「監査ログ確認して」「何か異常な操作があったか見て」と言われたときに使う。
context: fork
---

# audit-log スキル

## 目的
AI エージェントが実行した操作を CloudWatch Logs またはローカルログから取得し、
異常な操作（権限昇格・シークレットアクセス・大量削除等）を検出する。

## 手順

### 1. CloudWatch Logs から取得（本番環境）

```bash
# 直近 24 時間の AI エージェントのログを取得
aws logs filter-log-events \
  --log-group-name "/claude-agent/actions" \
  --start-time $(date -d '24 hours ago' +%s000) \
  --filter-pattern "ERROR OR WARN OR secretsmanager OR iam OR security-group"
```

### 2. ローカルログから取得（開発環境）

```bash
# Claude Code のアクティビティログ
cat ~/.claude/logs/$(date +%Y-%m-%d).log 2>/dev/null | tail -200
```

### 3. 異常検出チェックリスト

以下のパターンを確認する：

| 検出パターン | リスクレベル | 説明 |
|------------|------------|------|
| IAM 操作 | 🔴 HIGH | 権限の自己変更の可能性 |
| セキュリティグループ変更 | 🔴 HIGH | ネットワーク開口の可能性 |
| シークレット大量アクセス | 🟠 MEDIUM | シークレット収集の可能性 |
| 深夜帯の大量 API コール | 🟠 MEDIUM | 不審なアクティビティ |
| 削除操作の集中 | 🟠 MEDIUM | データ削除の可能性 |

## 出力フォーマット

```
## 監査ログレビュー — {{対象期間}}

### 🔴 要調査
- {{タイムスタンプ}} [{{操作}}]: {{詳細}}

### 📊 サマリー
- 総操作数: N
- API コール: N 回
- ファイル変更: N 件
- エラー: N 件

### ✅ 異常なし
通常の操作範囲内です。
```
