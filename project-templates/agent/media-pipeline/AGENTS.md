# AGENTS.md — media-pipeline

## Project Context
- Stack: Python / Claude API / Gemini API / Supabase / GitHub Actions
- Architecture: RSS収集 → AI処理 → Supabase保存 → 配信
- Testing: pytest

## Agent Rules

### 必須
- `main` への直接 push 禁止（ブランチで作業）
- API キーはコードにハードコードしない（`.env` または GitHub Secrets のみ）
- 1回のパイプラインで50件を超えて処理しない
- 完了前に `pytest` を実行して確認する

### データ管理ルール
- Supabase への保存は URL 単位で upsert する（重複排除）
- 処理済みコンテンツには `processed_at` タイムスタンプを付ける
- エラーが発生したアイテムはスキップしてログに記録し、パイプライン全体を止めない

### API コスト管理
- Claude API は Haiku モデルを優先する（タグ付け・要約用途）
- Gemini API は生成用途に使い、バッチ処理でレート制限を意識する
- バッチ処理前にトークン数を見積もる

## 優先順位
1. 動くこと（RSS → Supabase の基本フローが機能する）
2. 信頼性（エラーが出ても途中のデータが消えない）
3. コスト効率（無駄な API 呼び出しをしない）
4. 出力品質
