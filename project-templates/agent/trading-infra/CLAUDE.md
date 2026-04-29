# {{PROJECT_NAME}}

## 概要
- **目的**: {{PROJECT_DESCRIPTION}}
- **スタック**: Python / FastAPI / SQLite / Streamlit / WSL2
- **作成日**: {{CURRENT_DATE}}

## データフロー

```
データソース（証券会社API）
  → bridge.py（データ受信・正規化）
  → FastAPI / SQLite（保存・配信）
  → Streamlit（ダッシュボード表示）
```

## シグナル定義
- VWAP（出来高加重平均価格）
- MACD（移動平均収束拡散）
- RSI（相対力指数）

## ローソク足
- tick データ → 3分足 OHLCV に変換

## バックテスト
- IS/OOS 分割を必ず行う
  - IS（In-Sample）: 学習・最適化期間
  - OOS（Out-of-Sample）: 検証期間（IS 期間と重複させない）

## 禁止事項
- 本番資金での未テスト実行
- API キーのログ出力
- 取引ロジックのハードコード（設定ファイルで管理する）

## AIエージェントへの注意事項
- 作業前に `task.md` を確認・更新する
- バックテスト結果が OOS で有効でない限り本番適用しない
- 取引パラメータは `config.yaml` で管理し、コードに直接書かない
