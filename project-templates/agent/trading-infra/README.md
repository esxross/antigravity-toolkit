# trading-infra テンプレート

アルゴリズムトレード基盤。tick → OHLCV 変換・シグナル生成・Streamlit ダッシュボードを含む Python ベースのトレーディングシステムです。

## システム構成

```
証券会社API（MarketSpeed II 等）
  → bridge.py（WebSocket/API 受信）
  → FastAPI（REST API）
  → SQLite（tick・OHLCV 保存）
  → Streamlit（リアルタイムダッシュボード）
```

## セットアップ

### 必要なもの
- 証券会社 API アクセス（MarketSpeed II 等）
- WSL2 環境（Windows の場合）
- Python 3.11+

### 手順
1. `.env` に API 認証情報を設定
2. `config.yaml` でトレーディングパラメータを設定
3. `bridge.py` でデータソース接続を確認
4. `python backtest.py` でバックテスト実行
5. OOS 結果を確認してから本番起動

## バックテスト

```bash
python backtest.py --start 2023-01-01 --end 2023-06-30 --oos-start 2023-07-01
```

- IS 期間でパラメータ最適化
- OOS 期間で検証（IS と重複させない）

## 起動

```bash
# FastAPI サーバー
uvicorn api:app --reload

# Streamlit ダッシュボード
streamlit run dashboard.py

# データブリッジ
python bridge.py
```

## 注意事項

- **本番資金での未テスト実行は絶対禁止**
- バックテスト → ペーパートレード → 少額実弾 の順で検証する
