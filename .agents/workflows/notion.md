---
description: Notion MCPを使った仕様書・ドキュメント管理ワークフロー
---

# Notion ワークフロー

MCPサーバー: `notion`
ツールプレフィックス: `mcp__notion__`

---

## 基本方針

- Notionは**仕様・設計・ナレッジの保管場所**として使う
- 実装前に仕様をNotionで確認 → 実装後に結果をNotionに反映
- NotebookLM（`mcp__notebooklm__`）と組み合わせて仕様書のQ&Aも可能

---

## 主要操作

### ページを取得する

```
mcp__notion__retrieve_page
  - page_id: NotionページのID（URLの末尾32文字）
```

### ページのブロック（内容）を取得する

```
mcp__notion__retrieve_block_children
  - block_id: ページIDまたはブロックID
```

### ページを検索する

```
mcp__notion__search
  - query: 検索キーワード
  - filter: { "property": "object", "value": "page" }
```

### ページを作成する

```
mcp__notion__create_page
  - parent: { "database_id": "データベースID" } or { "page_id": "親ページID" }
  - properties: { "title": [{ "text": { "content": "タイトル" } }] }
  - children: ページのブロック内容
```

### ページを更新する

```
mcp__notion__append_block_children
  - block_id: 追記先ページID
  - children: 追加するブロック
```

---

## 標準ワークフロー

### 実装前：仕様を確認する

```
1. [Lead] mcp__notion__search で関連仕様ページを検索
2. [Lead] mcp__notion__retrieve_block_children でページ内容を取得
3. [Lead] 仕様を理解してGLMへのコンテキストに含める
```

### 実装後：Notionに結果を記録する

```
1. [Lead] 実装完了後、該当仕様ページに実装結果・変更点を追記
2. [Lead] mcp__notion__append_block_children で記録
```

### NotebookLMと連携する

```
1. [Lead] 複雑な仕様はNotebookLM（mcp__notebooklm__）にQ&Aを投げる
2. [Lead] 回答をGLMへの指示に組み込む
```

---

## プロジェクト固有の設定

各プロジェクトの `CLAUDE.md` に以下を追記して使うNotionページを明示する：

```markdown
## Notion
- 仕様書ページID: <PAGE_ID>
- データベースID: <DATABASE_ID>
- 用途: 機能仕様・設計メモ
```
