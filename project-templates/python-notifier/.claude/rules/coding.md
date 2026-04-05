# コーディングルール — Python Notifier

## 基本方針
- シンプル第一：最小限のコードで要件を満たす
- 早期リターンでネストを浅く保つ
- 1クラス・1関数 1責務

## Python スタイル
- 型アノテーションを必ず付ける
- `Optional[X]` より `X | None` を使う（Python 3.10+）
- f-string を使う（`%` フォーマット・`.format()` は使わない）
- `dataclass` または `pydantic.BaseModel` で設定・データを定義する

## 通知チャンネル
- `BaseChannel` を継承し `send(message: str) -> bool` を実装する
- 送信失敗は例外を外に漏らさない：`logger.error` に記録して `False` を返す
- HTTP タイムアウトは必ず設定する（`requests.post(..., timeout=10)`）

```python
# 良い例
def send(self, message: str) -> bool:
    try:
        resp = requests.post(self.webhook_url, json={"text": message}, timeout=10)
        resp.raise_for_status()
        return True
    except Exception as e:
        logger.error("Slack send failed: %s", e)
        return False
```

## 環境変数・設定
- `pydantic-settings` の `BaseSettings` で設定を一元管理する
- `.env` から自動読み込み、型チェック付き

```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    slack_webhook_url: str
    check_interval_seconds: int = 300

    model_config = {"env_file": ".env"}
```

## エラーハンドリング
- スケジューラーのジョブは必ず `try/except` で包む
- ユーザーへのエラーメッセージは具体的に（「失敗しました」より「Slack Webhook URL が無効です」）

## テスト
- 外部 API 呼び出しは `unittest.mock.patch` でモックする
- `BaseChannel` のサブクラスは必ず `send()` の成功・失敗両方をテストする
- `pytest-dotenv` または `monkeypatch` で環境変数をテスト用に差し替える
