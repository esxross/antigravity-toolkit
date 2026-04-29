# AGENTS.md — AI Design System

## Design Philosophy
AIには「ルール」を与える。「いい感じに」は通じない。

## トークン参照の原則
- 色は必ず `tokens.json` のトークン名を使う（例: `primary-500`）
- ハードコードカラー（`#3B82F6`、`text-black`）は禁止
- スペーシングは `space-*` トークンを使う
- 影は `shadow-token-*` を使う（`shadow-lg` 直書き禁止）

## AI生成UIの禁止パターン（抜粋）
完全なリストは `.claude/rules/design.md` を参照。

### 色
- `text-black` → `text-slate-900` を使う
- `bg-indigo-*` / `bg-blue-*` ハードコード → `bg-primary-*` を使う
- グラデーション多用 → 原則フラットデザイン

### 装飾
- `shadow-lg` / `shadow-xl` → `shadow-sm` で十分
- `border-l-4` カラーバー → `border rounded-lg` で全周ボーダー
- カードヘッダーのカラーバー → 使用禁止
- 絵文字の多用 → 明示的に指示された場合のみ

### レイアウト
- 過度なアニメーション（`animate-bounce` 等）→ `transition-opacity` 程度に留める
- ネストしすぎたコンテナ → シンプルなフレックス/グリッドで解決

## Agent Rules
- UIを生成する前に `design/CLAUDE-design.md` を読む
- コンポーネントを追加・変更したら `/design-review` でチェックする
- 「AIっぽい」と感じたら `/ban-pattern` で禁止パターンに追加する
