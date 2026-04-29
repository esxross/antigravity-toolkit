# Agentic R&D — AI 駆動実験ループ

## このテンプレートの目的
AI と人間が協力して実験をガムシャラに回す。
「同じミスをしない」を積み上げていく **生きたガードレール** として CLAUDE.md を育てる。
実験結果は構造化 JSON で蓄積し、知見を横断的に参照できるようにする。

## ディレクトリ構造

```
agentic-rd/
├── CLAUDE.md          ← このファイル（ガードレール＋実験管理）
├── AGENTS.md          ← リサーチエージェントの役割定義
├── PROMPT.md          ← 現在の実験ゴール
├── experiments/
│   ├── EXP-001/       ← 実験ごとのディレクトリ
│   │   ├── PLAN.md    ← 実験計画
│   │   ├── run.sh     ← 実験実行スクリプト
│   │   └── results/
│   │       └── result.json  ← 構造化された実験結果
│   └── EXP-002/
│       └── ...
├── results/
│   └── summary.json   ← 全実験の横断サマリー
├── .claude/
│   ├── rules/research.md
│   ├── settings.json
│   └── skills/
│       ├── new-exp/SKILL.md
│       └── compile-results/SKILL.md
└── task.md
```

## 実験管理の仕組み

```
PROMPT.md（ゴール）
  └─ EXP-001: アプローチA を試す
  └─ EXP-002: アプローチB を試す（EXP-001 の学びを反映）
  └─ EXP-003: 最良のアプローチを改良
       └─ results/summary.json（横断知見）
```

**child-exp パターン**: 大きな実験の中に小実験を作る場合は `EXP-001/child-exp-1/` のように入れ子にする。

## ガードレール更新ルール

**AI が同じミスを繰り返したとき、このファイルに「二度とやるな」ルールを追記する。**

### 学習済みの禁止事項
<!-- 実験の中で発見したNG事項を追加していく -->
- (まだなし)

## コマンド
```bash
# 新しい実験を作成
/new-exp

# 全実験結果をコンパイル
/compile-results
```

## 完了の定義
`results/summary.json` に以下が揃ったとき：
- 仮説が検証・棄却された根拠
- 最良の手法とその指標
- 次の実験への提言
