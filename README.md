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
├── project-templates/       # プロジェクトテンプレート
│   ├── nextjs-ai-app/       # Next.js + Claude API
│   ├── landing-page/        # LP特化
│   ├── solo-saas/           # ソロ開発SaaS
│   ├── team-layered/        # チーム・レイヤードアーキテクチャ
│   ├── multi-agent/         # マルチエージェント
│   ├── harness-quality/     # 品質ゲート
│   ├── ai-design/           # AIデザインシステム
│   ├── ralph-loop/          # 自律ループエージェント
│   ├── agent-zero-trust/    # ゼロトラスト環境
│   ├── agentic-rd/          # AI駆動実験ループ
│   └── claude-tooling/      # Claude Code 環境カスタマイズ
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

### アプリケーション開発

| テンプレート | 用途 | 特徴 |
| --- | --- | --- |
| `nextjs-ai-app` | AIを活用したWebアプリ | Next.js 14 + TypeScript + Claude API |
| `landing-page` | コンバージョン特化LP | 3ファイル構成（design-system / lp-structure / content） |
| `solo-saas` | ソロ開発者向けSaaS | 最小構成・セキュリティファースト・Conventional Commits自動化 |
| `team-layered` | チーム開発・レイヤードアーキテクチャ | domain / application / infra / presentation の依存方向を強制 |
| `multi-agent` | マルチエージェント・BC分割 | Bounded Context ごとに責務分割、reviewer / tester サブエージェント内蔵 |

### 品質・設計

| テンプレート | 用途 | 特徴 |
| --- | --- | --- |
| `harness-quality` | Harness Engineering 品質ゲート | oxlint + tsc + vitest をフックで自動実行、`--no-verify` を物理ブロック |
| `ai-design` | AIデザインシステム | `tokens.json` を SSOT に、76の禁止パターンをリアルタイム検出 |

### エージェント・自動化

| テンプレート | 用途 | 特徴 |
| --- | --- | --- |
| `ralph-loop` | 自律ループ型エージェント | `PROMPT.md` 目標仕様 + `progress.json` 状態管理 + Backpressure Gate |
| `agent-zero-trust` | エージェント専用ゼロトラスト環境 | AI専用アカウント + Tailscale VPN（インバウンド完全閉鎖）+ Keychain シークレット管理 |
| `agentic-rd` | AI駆動実験ループ | EXP + child-exp 2段構成、`CLAUDE.md` を生きたガードレールとして更新 |

### ツール・環境設定

| テンプレート | 用途 | 特徴 |
| --- | --- | --- |
| `claude-tooling` | Claude Code 環境カスタマイズ | statusline スクリプト 5パターン（rate_limits 対応）+ フックレシピ集 |

## 設定ファイルの使い方

### `antigravity/settings.json`

Antigravity の設定テンプレートです。新プロジェクトにコピーしてプロジェクト名・スタック等を変更してください。

### `claude-code/CLAUDE.md.template`

Claude Code 用の汎用指示書テンプレートです。`{{PROJECT_NAME}}` 等のプレースホルダーを置換して使います。
`make new-project` を使えば自動置換されます。
