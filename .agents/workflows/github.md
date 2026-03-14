---
description: GitHub MCP を使ったISSUE・PR操作の標準ワークフロー
---

# GitHub ワークフロー

MCPサーバー: `github-mcp-server`
ツールプレフィックス: `mcp__github-mcp-server__`

---

## ISSUE 操作

### ISSUEを作成する

```
mcp__github-mcp-server__create_issue
  - owner: リポジトリオーナー名
  - repo: リポジトリ名
  - title: ISSUEタイトル（英語 or 日本語）
  - body: 再現手順 or 受け入れ条件を必ず含める
  - labels: ["bug"] / ["enhancement"] / ["documentation"]
```

**ISSUEのbodyテンプレート（バグ）:**
```markdown
## 概要
<何が起きているか>

## 再現手順
1. 〇〇を開く
2. △△をクリック
3. エラーが発生する

## 期待する動作
<本来どうなるべきか>

## 環境
- OS: macOS
- Node: x.x.x
```

**ISSUEのbodyテンプレート（機能追加）:**
```markdown
## 概要
<何を実現したいか>

## 受け入れ条件
- [ ] 〇〇ができる
- [ ] △△が表示される
- [ ] テストが通る

## 背景・理由
<なぜ必要か>
```

### ISSUEを取得・調査する

```
mcp__github-mcp-server__get_issue
  - owner: オーナー名
  - repo: リポジトリ名
  - issue_number: ISSUE番号
```

### ISSUEを調査して実装する（標準フロー）

```
1. [Lead] get_issue でISSUEの内容を確認
2. [Lead] 関連ファイルを読み込んで原因・実装方針を把握
3. [GLM]  glm-46 で実装案を生成
4. [Lead] ブランチを作成して変更を適用
5. [Lead] テスト実行
6. [Lead] create_pull_request でPRを作成
```

---

## PR 操作

### PRを作成する

```
mcp__github-mcp-server__create_pull_request
  - owner: オーナー名
  - repo: リポジトリ名
  - title: PRタイトル（Conventional Commits形式）
  - body: 変更内容・テスト方法を含める
  - head: 作業ブランチ名
  - base: "main"
  - draft: false（レビュー準備ができていない場合は true）
```

**PRタイトル形式:**
```
feat: ○○機能を追加
fix: △△のバグを修正
docs: □□のドキュメントを更新
refactor: ◇◇をリファクタリング
```

**PRのbodyテンプレート:**
```markdown
## 変更内容
- 〇〇を実装した
- △△のバグを修正した

## 変更理由
closes #ISSUE番号

## テスト方法
- [ ] ○○の動作確認
- [ ] テスト実行: `npm test`
- [ ] ビルド確認: `npm run build`

## スクリーンショット（UIの変更がある場合）
```

### PRをレビューする

```
mcp__github-mcp-server__get_pull_request
mcp__github-mcp-server__list_pull_request_files
mcp__github-mcp-server__create_pull_request_review
```

---

## 運用ルール

- **mainへの直接pushは禁止**。必ず`feat/xxx`ブランチを作ってPRを出す
- ISSUEには再現手順 or 受け入れ条件を必ず含める
- PRは1機能・1バグ修正の単位で作成する（大きすぎるPRはレビューしにくい）
- PRを出す前にテストを実行して通っていることを確認する
- `closes #ISSUE番号` をPR本文に書くとマージ時にISSUEが自動クローズされる

## gh CLI との使い分け

| 用途 | 推奨 |
|---|---|
| 単純なPR作成・ISSUE作成 | `gh` CLI（軽量・高速） |
| コードベース横断検索 | `github-mcp-server` |
| 自動化フロー（エージェントから呼び出す） | `github-mcp-server` |
