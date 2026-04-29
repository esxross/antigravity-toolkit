# Antigravity Toolkit

AIエージェント環境の設定・テンプレートを一元管理するリポジトリです。
新しいプロジェクトを30秒で立ち上げることを目標にしています。

## ディレクトリ構成

```text
antigravity-toolkit/
├── antigravity/             # Antigravity 設定テンプレート
│   └── settings.json
├── claude-code/             # Claude Code 設定テンプレート
│   └── CLAUDE.md.template
├── project-templates/       # プロジェクトテンプレート（目的軸で分類）
│   ├── ship/                # 早くリリースしたい
│   │   ├── nextjs-ai-app/
│   │   ├── landing-page/
│   │   ├── solo-saas/
│   │   └── pwa-location/
│   ├── agent/               # AIエージェントを動かしたい
│   │   ├── multi-agent/
│   │   ├── ralph-loop/
│   │   ├── agentic-rd/
│   │   ├── agent-zero-trust/
│   │   ├── media-pipeline/
│   │   └── trading-infra/
│   ├── scale/               # チームで・大きく作りたい
│   │   ├── team-layered/
│   │   └── harness-quality/
│   ├── design/              # UIシステムを整えたい
│   │   └── ai-design/
│   └── tooling/             # 環境・自動化を整えたい
│       ├── claude-tooling/
│       └── python-notifier/
├── scripts/
│   └── new-project.sh       # プロジェクト作成スクリプト
├── .agents/workflows/       # AIエージェント用ワークフロー定義
├── Makefile                 # タスクショートカット
└── CLAUDE.md                # このリポジトリ自体のAI指示
```

## クイックスタート

### 新規プロジェクトを作成する

```bash
make new-project
```

対話形式でプロジェクト名・説明・テンプレートを選ぶと、以下が自動生成されます：

- `CLAUDE.md` / `AGENTS.md`（AIエージェント指示書）
- `task.md`（タスク管理ファイル）
- Git初期コミット

### その他のコマンド

```bash
make help           # コマンド一覧
make list-templates # 利用可能なテンプレート一覧
make check          # ツールキット構成確認
```

## テンプレート一覧

### 🚀 ship — 早くリリースしたい

| テンプレート | 用途 | 特徴 | 難易度 |
| --- | --- | --- | --- |
| `ship/nextjs-ai-app` | AIを活用したWebアプリ | Next.js 14 + TypeScript + Claude API | 🟡 intermediate |
| `ship/landing-page` | コンバージョン特化LP | 3ファイル構成（design-system / lp-structure / content） | 🟢 beginner |
| `ship/solo-saas` | ソロ開発者向けSaaS | 最小構成・セキュリティファースト・Conventional Commits自動化 | 🟡 intermediate |
| `ship/pwa-location` | 位置情報 × Google Places API × PWA | 現在地から近くのスポットをジャンル・ソートで検索 | 🟡 intermediate |

### 🤖 agent — AIエージェントを動かしたい

| テンプレート | 用途 | 特徴 | 難易度 |
| --- | --- | --- | --- |
| `agent/multi-agent` | マルチエージェント・BC分割 | Bounded Context ごとに責務分割、reviewer / tester サブエージェント内蔵 | 🟡 intermediate |
| `agent/ralph-loop` | 自律ループ型エージェント | `PROMPT.md` 目標仕様 + `progress.json` 状態管理 + Backpressure Gate | 🟡 intermediate |
| `agent/agentic-rd` | AI駆動実験ループ | EXP + child-exp 2段構成、`CLAUDE.md` を生きたガードレールとして更新 | 🟡 intermediate |
| `agent/agent-zero-trust` | エージェント専用ゼロトラスト環境 | AI専用アカウント + Tailscale VPN（インバウンド完全閉鎖）+ Keychain シークレット管理 | 🔴 advanced |
| `agent/media-pipeline` | 自動コンテンツ生成パイプライン | RSS → Claude APIタグ付け → Gemini API生成 → Supabase保存 | 🟡 intermediate |
| `agent/trading-infra` | アルゴリズムトレード基盤 | tick→OHLCV変換・VWAP/MACD/RSIシグナル・Streamlitダッシュボード | 🔴 advanced |

> **`agent/agent-zero-trust`** 🔴 上級者向け・Tailscale VPN環境が必要

### 🏗 scale — チームで・大きく作りたい

| テンプレート | 用途 | 特徴 | 難易度 |
| --- | --- | --- | --- |
| `scale/team-layered` | チーム開発・レイヤードアーキテクチャ | domain / application / infra / presentation の依存方向を強制 | 🟡 intermediate |
| `scale/harness-quality` | Harness Engineering 品質ゲート | oxlint + tsc + vitest をフックで自動実行、`--no-verify` を物理ブロック | 🟡 intermediate |

### 🎨 design — UIシステムを整えたい

| テンプレート | 用途 | 特徴 | 難易度 |
| --- | --- | --- | --- |
| `design/ai-design` | AIデザインシステム | `tokens.json` を SSOT に、76の禁止パターンをリアルタイム検出 | 🟡 intermediate |

### 🔧 tooling — 環境・自動化を整えたい

| テンプレート | 用途 | 特徴 | 難易度 |
| --- | --- | --- | --- |
| `tooling/claude-tooling` | Claude Code 環境カスタマイズ | statusline スクリプト 5パターン（rate_limits 対応）+ フックレシピ集 | 🟢 beginner |
| `tooling/python-notifier` | 通知・アラートアプリ | Slack/LINE/メール対応・`BaseChannel` 抽象化・schedule スケジューラー | 🟡 intermediate |

## 設定ファイルの使い方

### `antigravity/settings.json`

Antigravity の設定テンプレートです。新プロジェクトにコピーしてプロジェクト名・スタック等を変更してください。

### `claude-code/CLAUDE.md.template`

Claude Code 用の汎用指示書テンプレートです。`{{PROJECT_NAME}}` 等のプレースホルダーを置換して使います。
`make new-project` を使えば自動置換されます。
