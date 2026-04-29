---
name: compile-results
description: 全実験の結果をコンパイルして横断サマリーを生成する。「結果まとめて」「何が分かった？」と言われたときに使う。
context: fork
---

# compile-results スキル

## 目的
全 EXP の `result.json` を読み込み、横断的な知見を抽出して `results/summary.json` を更新する。
研究の現時点の最良の知見と次の方向性を示す。

## 手順

1. `experiments/EXP-*/results/result.json` をすべて読む
2. 以下の集計を行う：
   - 実験数・成功数・失敗数
   - 各指標の最良値とその実験番号
   - 失敗した実験の共通原因
   - 学習のまとめ
3. `results/summary.json` を更新する
4. 人間向けの読みやすいレポートを出力する

## 出力フォーマット（人間向け）

```
## 実験コンパイル結果

### 統計
- 総実験数: N
- 成功: N | 失敗: N | 進行中: N

### 現時点の最良手法
**EXP-XXX**: {{手法の説明}}
- 指標: {{値}} (目標: {{目標値}})

### 主要な学び
1. {{最重要の学び（失敗含む）}}
2. {{2番目の学び}}
3. {{3番目の学び}}

### CLAUDE.md への追記候補
以下を禁止事項に追加することを推奨します：
- {{禁止事項}} — {{理由}}

### 次に試すべき実験
1. EXP-{{N+1}}: {{仮説}} （根拠: {{根拠}}）
2. EXP-{{N+2}}: {{仮説}} （根拠: {{根拠}}）

### 判定
{{ 目標達成 / さらなる実験が必要 / 方向転換が必要 }}
```

## summary.json 更新フォーマット

```json
{
  "research_question": "PROMPT.md から引用",
  "total_experiments": N,
  "completed": N,
  "successful": N,
  "failed": N,
  "best_approach": {
    "exp_id": "EXP-XXX",
    "description": "手法の説明",
    "key_metric": { "name": "指標名", "value": 値 }
  },
  "key_learnings": [
    "学び1",
    "学び2"
  ],
  "guardrail_candidates": [
    "禁止事項候補1",
    "禁止事項候補2"
  ],
  "next_experiments": [
    { "hypothesis": "仮説1", "rationale": "根拠1" }
  ],
  "updated_at": "ISO 8601"
}
```
