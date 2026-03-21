---
name: new-exp
description: 新しい実験ディレクトリを作成する。「新しい実験作って」「EXP作って」と言われたときに使う。
---

# new-exp スキル

## 目的
次の実験番号を自動採番して、実験ディレクトリと必要なファイルを作成する。

## 手順

1. `experiments/` ディレクトリ内の最大 EXP 番号を確認する
2. 次の番号（N+1）を採番する
3. 以下のファイルを作成する：
   - `experiments/EXP-XXX/PLAN.md` — `experiments/EXP-000/PLAN.md` をコピーして仮説欄を空にする
   - `experiments/EXP-XXX/results/result.json` — `EXP-000` のテンプレートをコピーして `exp_id` を更新
4. ユーザーから仮説の入力を求める（または引数から取得する）
5. `PLAN.md` の仮説欄に記入する
6. 作成したファイルのパスを報告する

## 使い方

```
/new-exp
/new-exp RAGのチャンク戦略を比較する
```

## 出力

```
✅ EXP-003 を作成しました

ファイル:
- experiments/EXP-003/PLAN.md
- experiments/EXP-003/results/result.json

次のステップ:
1. experiments/EXP-003/PLAN.md の実験手順を記入する
2. run.sh を実装する
3. 実験を実行して result.json に結果を記録する
```
