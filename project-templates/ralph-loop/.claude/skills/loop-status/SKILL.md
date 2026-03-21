---
name: loop-status
description: 現在のループ状態を可視化する。「ループの状態は？」「何イテレーション目？」と言われたときに使う。
---

# loop-status スキル

## 目的
`progress.json` を読み込み、ループの現在の状態を人間が読みやすい形式で表示する。

## 手順

1. `progress.json` を読む
2. `PROMPT.md` の完了条件セクションを読む
3. 現在の状態を以下のフォーマットで出力する

## 出力フォーマット

```
## ループステータス

**イテレーション**: N 回目
**ステータス**: 🔄 in_progress / ✅ done / 🚫 blocked
**最終更新**: {{updated_at}}

### 直近の完了タスク
- {{last_completed[0]}}
- {{last_completed[1]}}

### 次イテレーションのタスク
- {{next_tasks[0]}}
- {{next_tasks[1]}}

### ブロッカー
{{blockers が空なら「なし」、あれば内容}}

### エラー数
{{error_count}} / 5（5回でループ停止）
```
