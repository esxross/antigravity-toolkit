# タスク管理 — Agent Zero Trust

## セットアップチェックリスト

### フェーズ 1: アカウント分離
- [ ] AI 専用 AWS アカウント作成
- [ ] IAM ロール `ClaudeAgentRole` 作成（`setup/aws-iam.md` 参照）
- [ ] CloudTrail 監査ログ設定

### フェーズ 2: ネットワーク設定
- [ ] EC2 セキュリティグループのインバウンドをすべて削除
- [ ] Tailscale インストール（`setup/tailscale.md` 参照）
- [ ] Tailscale ACL 設定（tag:human のみ許可）
- [ ] 接続テスト（`tailscale ping`）

### フェーズ 3: シークレット管理
- [ ] AWS Secrets Manager にシークレット移行（`setup/keychain.md` 参照）
- [ ] `.env` ファイルを `.gitignore` に追加
- [ ] `git secrets --install` で漏洩防止フック設定

### フェーズ 4: スキャン整備
- [ ] Trivy インストール・動作確認
- [ ] Semgrep インストール・動作確認
- [ ] CI パイプラインにスキャン追加

## 現在の作業

<!-- 作業開始時に記入 -->

## セキュリティインシデント記録

| 日付 | 内容 | 対応 |
|------|------|------|
| | | |
