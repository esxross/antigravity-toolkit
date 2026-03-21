# Ralph Loop — 自律ループ型エージェント

## このテンプレートの目的
Claude が「目標仕様 → 実装 → コミット → 再起動」のループを自律的に回す。
コンテキストが満杯になるか目標を達成すると終了し、`loop.sh` が新鮮なコンテキストで次イテレーションを自動起動する。

## セッション開始時の必読ファイル
1. `PROMPT.md` — 目標仕様（何を達成すべきか）
2. `progress.json` — 前イテレーションの状態・完了タスク・ブロッカー
3. `task.md` — 現在のイテレーション計画

## ループの仕組み

```
loop.sh
  └─ claude --resume PROMPT.md を渡す
       └─ 1イテレーション分の作業を実行
            └─ git commit（チェックポイント）
                 └─ progress.json を更新して終了
                      └─ loop.sh が次のイテレーションを起動
```

**終了条件（loop.sh が停止する条件）：**
- `progress.json` の `status: "done"` を検出
- テストが連続 3 回失敗（Backpressure Gate）
- `progress.json` の `error_count >= 5`

## ルールポインタ
- ループ挙動: `.claude/rules/loop.md`
- コーディング規約: `.claude/rules/coding.md`（必要に応じて追加）

## スキル
- `/anti-human-bottleneck` — 人間に聞く前に自己解決する
- `/loop-status` — 現在のループ状態を可視化する

## コマンド
```bash
# ループ開始
./loop.sh

# 手動で1イテレーション実行
claude --dangerously-skip-permissions

# 状態確認
cat progress.json
```

## 重要: ループエチケット
- 1イテレーションで変更するファイルは **最大 10 ファイル** まで
- イテレーション終了時は必ず `git commit` する
- ブロッカーは `progress.json` の `blockers` に記録してループを終了する
- **絶対に人間を待たせない**（anti-human-bottleneck の原則）
