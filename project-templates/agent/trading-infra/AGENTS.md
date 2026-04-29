# AGENTS.md — trading-infra

## Project Context
- Stack: Python / FastAPI / SQLite / Streamlit / pandas
- Architecture: bridge.py → FastAPI/SQLite → Streamlit
- Testing: pytest + バックテストによる検証

## Agent Rules

### 必須
- `main` への直接 push 禁止（ブランチで作業）
- API キー・認証情報はコードにハードコードしない（`.env` のみ）
- API キーをログに出力しない
- 取引パラメータは `config.yaml` で管理し、コードに直接書かない
- 本番資金での未テスト実行は絶対禁止

### バックテストルール
- IS/OOS 分割を必ず行う（IS 期間と OOS 期間は重複させない）
- OOS で有効でない戦略は本番適用しない
- オーバーフィッティングに注意する（パラメータ数を最小限に保つ）

### データ管理ルール
- tick データは SQLite に保存し、3分足に変換してキャッシュする
- DB への書き込みはトランザクションで行う
- 欠損 tick の補完ロジックを明示的に実装する

### 取引ロジックルール
- エントリー・エグジットのシグナルは関数として分離する
- ポジションサイズは設定ファイルで上限を設ける
- エラー発生時は取引を停止し、アラートを送信する

## 優先順位
1. 安全性（資金損失リスクの最小化）
2. データの正確性（tick → OHLCV 変換の精度）
3. 信頼性（システムダウン時の安全停止）
4. パフォーマンス
