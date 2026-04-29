---
name: security-scan
description: Trivy + Semgrep + npm audit でセキュリティスキャンを実行する。「セキュリティスキャンして」「脆弱性チェックして」と言われたときに使う。
context: fork
---

# security-scan スキル

## 目的
デプロイ前のセキュリティスキャンを自動化する。
HIGH 以上の脆弱性がある場合はデプロイを止める。

## スキャン手順

### 1. npm 依存関係スキャン

```bash
npm audit --audit-level=high --json > /tmp/npm-audit.json
```

HIGH または CRITICAL の脆弱性があれば報告する。

### 2. Semgrep 静的解析

```bash
semgrep --config=auto --json --output=/tmp/semgrep-results.json .
```

ERROR レベルの検出項目があれば報告する。

### 3. Trivy コンテナスキャン（Dockerfile がある場合）

```bash
# イメージをビルド
docker build -t scan-target:latest .

# スキャン実行
trivy image --severity HIGH,CRITICAL --format json \
  --output /tmp/trivy-results.json scan-target:latest
```

### 4. シークレット漏洩チェック

```bash
# git-secrets でコミット済み内容をチェック
git secrets --scan

# trufflehog で履歴を確認（オプション）
trufflehog git file://. --only-verified
```

## 出力フォーマット

```
## セキュリティスキャン結果

### 🔴 CRITICAL（即座に対応必須）
- [npm] package-name@version: CVE-XXXX-XXXX
- [semgrep] src/auth.ts:42: SQL injection risk

### 🟠 HIGH（デプロイ前に対応）
- [trivy] base-image: CVE-XXXX-XXXX

### 🟡 MEDIUM（次スプリントで対応）
- 件数のみ報告

### ✅ 問題なし
スキャンをパスしました。デプロイ可能です。

### 判定
PASS / FAIL（HIGH以上があれば FAIL）
```
