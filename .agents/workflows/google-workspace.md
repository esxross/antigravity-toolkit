---
description: Google Workspace CLI（gws）を使ったDrive・Gmail・Calendar・Sheets操作ワークフロー
---

# Google Workspace ワークフロー

CLIツール: `gws`（Google Workspace CLI）
インストール: `npm install -g @googleworkspace/cli`
リポジトリ: https://github.com/googleworkspace/cli

**注意: gws はMCPサーバーではなく Bash CLI として使用する**

---

## セットアップ

### 初回認証

gwsのデフォルトOAuthクライアントはGoogleの審査が通っておらずブロックされる。
**自分のOAuthクライアントを使う必要がある。**

#### 1. Google Cloud Console でOAuthクライアントを作成

1. [Google Cloud Console](https://console.cloud.google.com/) → 「APIとサービス」→「認証情報」
2. 「認証情報を作成」→「OAuthクライアントID」→ **デスクトップアプリ** を選択
3. `client_secret_xxx.json` をダウンロード
4. 「OAuth同意画面」→「テストユーザー」に自分のGmailアドレスを追加

#### 2. gwsにクライアントを設定してログイン

```bash
gws auth setup --client-secret ~/Downloads/client_secret_xxx.json
gws auth login
```

ブラウザが開いたらGoogleアカウントでOAuth認証する（「未検証アプリ」警告が出ても続行可）。
認証情報は `~/.config/gws/credentials.enc` に暗号化保存される（リポジトリにコミットしない）。

### 認証状態の確認

```bash
gws auth status
```

`"token_valid": true` かつ `"scopes"` に drive/gmail/calendar/sheets が含まれていればOK。

---

## 基本コマンド構文

```
gws <service> <resource> [sub-resource] <method> [flags]
```

| オプション | 説明 |
|---|---|
| `--params '{"key": "val"}'` | URLパラメータ（GET時のフィルタ等） |
| `--json '{"key": "val"}'` | リクエストボディ（POST/PATCH/PUT） |
| `--format table` | 出力形式（json/table/yaml/csv） |
| `--page-all` | 全件取得（自動ページネーション） |
| `--upload ./file.pdf` | ファイルアップロード |
| `--dry-run` | 実際には実行せずプレビューのみ |

---

## サービス別ワークフロー

### Drive

```bash
# ファイル一覧を取得
gws drive files list --params '{"pageSize": 20}'

# ファイルを検索
gws drive files list --params '{"q": "name contains '\''議事録'\'' and mimeType='\''application/vnd.google-apps.document'\''"}'

# ファイルをアップロード
gws drive files create --upload ./report.pdf --json '{"name": "月次レポート.pdf"}'

# ファイルをダウンロード（バイナリ）
gws drive files get --params '{"fileId": "FILE_ID", "alt": "media"}' --output ./downloaded.pdf

# フォルダを作成
gws drive files create --json '{"name": "新規フォルダ", "mimeType": "application/vnd.google-apps.folder"}'
```

### Gmail

```bash
# 受信トレイの未読メールを取得
gws gmail users messages list --params '{"userId": "me", "q": "is:unread", "maxResults": 10}'

# メールの本文を取得
gws gmail users messages get --params '{"userId": "me", "id": "MESSAGE_ID", "format": "full"}'

# メールを送信
gws +send --to "recipient@example.com" --subject "件名" --body "本文テキスト"

# ラベル一覧を取得
gws gmail users labels list --params '{"userId": "me"}'
```

### Calendar

```bash
# 今日のスケジュールを確認
gws +agenda

# カレンダー一覧を取得
gws calendar calendarList list

# イベント一覧を取得（日付範囲指定）
gws calendar events list --params '{
  "calendarId": "primary",
  "timeMin": "2026-03-15T00:00:00Z",
  "timeMax": "2026-03-15T23:59:59Z",
  "singleEvents": true,
  "orderBy": "startTime"
}'

# イベントを作成
gws calendar events insert --params '{"calendarId": "primary"}' --json '{
  "summary": "ミーティング",
  "start": {"dateTime": "2026-03-16T10:00:00+09:00"},
  "end": {"dateTime": "2026-03-16T11:00:00+09:00"}
}'
```

### Sheets

```bash
# スプレッドシートの情報を取得
gws sheets spreadsheets get --params '{"spreadsheetId": "SPREADSHEET_ID"}'

# セル範囲の値を取得
gws sheets spreadsheets values get --params '{
  "spreadsheetId": "SPREADSHEET_ID",
  "range": "Sheet1!A1:D10"
}'

# セル範囲に値を書き込む
gws sheets spreadsheets values update \
  --params '{"spreadsheetId": "SPREADSHEET_ID", "range": "Sheet1!A1", "valueInputOption": "USER_ENTERED"}' \
  --json '{"values": [["名前", "金額", "日付"], ["田中", "10000", "2026-03-15"]]}'

# 行を追加（append）
gws sheets spreadsheets values append \
  --params '{"spreadsheetId": "SPREADSHEET_ID", "range": "Sheet1!A:A", "valueInputOption": "USER_ENTERED"}' \
  --json '{"values": [["新しいデータ", "値", "2026-03-15"]]}'
```

---

## Antigravity ワークフローでの使い方

### Lead（Antigravity）から呼び出す

gws は `Bash(gws ...)` として Lead が直接実行する。

```
[Lead] gws drive files list でファイルを検索
[Lead] 結果をコンテキストに組み込み → GLMに渡す
[Lead] gws sheets spreadsheets values update で結果を記録
```

### 典型的なユースケース

| やりたいこと | コマンド例 |
|---|---|
| 仕様書をDriveから取得 | `gws drive files list --params '{"q": "name contains '仕様'"}'` |
| 結果をSheetsに記録 | `gws sheets spreadsheets values append ...` |
| Calendarにタスクを登録 | `gws calendar events insert ...` |
| レポートをGmailで送信 | `gws +send --to ...` |

### プロジェクト固有設定（CLAUDE.mdに追記）

このプロジェクトでgwsを使う場合、以下をCLAUDE.mdに追記する：

```markdown
## Google Workspace
- 仕様書Drive フォルダID: <FOLDER_ID>
- 進捗管理 Spreadsheet ID: <SPREADSHEET_ID>
- カレンダーID: primary
```

---

## セキュリティ

- `~/.config/gws/` の認証情報はリポジトリにコミットしない
- `gws auth status` で認証方法を定期確認する
- 不要になったOAuth認可は Google アカウントの「アプリのアクセス権」から削除する
- 本番データへの書き込みは `--dry-run` で事前確認する

---

## スキーマ確認

利用可能なパラメータは `gws schema` で確認できる：

```bash
# drive.files.list のパラメータを確認
gws schema drive.files.list

# sheets の値書き込みスキーマを確認
gws schema sheets.spreadsheets.values.update --resolve-refs
```
