# Antigravity Toolkit

AIエージェント環境の設定・テンプレートを一元管理するリポジトリです。
新しいプロジェクトを30秒で立ち上げることを目標にしています。

## ディレクトリ構成

```
antigravity-toolkit/
├── antigravity/             # Antigravity 設定テンプレート
│   └── settings.json
├── claude-code/             # Claude Code 設定テンプレート
│   └── CLAUDE.md.template
├── project-templates/       # プロジェクトテンプレート
│   ├── nextjs-ai-app/       # Next.js + Claude API
│   │   ├── CLAUDE.md
│   │   └── AGENTS.md
│   └── landing-page/        # LP特化
│       ├── CLAUDE.md
│       └── AGENTS.md
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

| テンプレート | 用途 | スタック |
|---|---|---|
| `nextjs-ai-app` | AIを活用したWebアプリ | Next.js 14 + TypeScript + Claude API |
| `landing-page` | コンバージョン特化LP | Next.js 14 + TypeScript + Tailwind |

## 設定ファイルの使い方

### `antigravity/settings.json`
Antigravity の設定テンプレートです。新プロジェクトにコピーしてプロジェクト名・スタック等を変更してください。

### `claude-code/CLAUDE.md.template`
Claude Code 用の汎用指示書テンプレートです。`{{PROJECT_NAME}}` 等のプレースホルダーを置換して使います。
`make new-project` を使えば自動置換されます。
