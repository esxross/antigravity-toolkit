---
name: commit
description: Conventional Commits形式でgit commitを作成する。コミットしたいとき、変更をまとめたいときに使う。
---

# commit スキル

## 手順

1. `git status` で変更ファイルを確認する
2. `git diff` で変更内容を確認する
3. 変更の性質を判断してコミットタイプを選ぶ：
   - `feat`: 新機能
   - `fix`: バグ修正
   - `docs`: ドキュメントのみ
   - `refactor`: 動作変更なしのリファクタリング
   - `test`: テストの追加・修正
   - `chore`: ビルド・設定の変更
4. `git add` で関連ファイルをステージング（`.env` 系は除外）
5. コミットメッセージを作成：
   ```
   <type>(<scope>): <日本語の説明（50字以内）>
   ```
6. `git commit -m "..."` でコミット

## 注意
- `.env`、`.env.local`、シークレットを含むファイルは絶対にコミットしない
- ビルド成果物（`dist/`、`.next/`）はコミットしない
- 1コミット1目的を守る
