# {{PROJECT_NAME}}

## 概要
- **目的**: {{PROJECT_DESCRIPTION}}
- **スタック**: Python 3.11+ / pytest / schedule or APScheduler
- **作成日**: {{CURRENT_DATE}}

## ディレクトリ構成

```
src/
├── notifier/
│   ├── __init__.py
│   ├── channels/          # 通知チャンネル実装
│   │   ├── __init__.py
│   │   ├── base.py        # BaseChannel (ABC)
│   │   ├── slack.py       # Slack Webhook
│   │   ├── line.py        # LINE Notify / Messaging API
│   │   └── email.py       # SMTP メール
│   ├── monitors/          # 監視・条件チェック
│   │   ├── __init__.py
│   │   ├── base.py        # BaseMonitor (ABC)
│   │   └── http.py        # HTTP ヘルスチェック例
│   ├── rules.py           # アラートルール・閾値定義
│   ├── scheduler.py       # ジョブスケジューラー
│   └── config.py          # 設定管理（pydantic-settings 推奨）
├── main.py                # エントリーポイント
tests/
├── test_channels.py
└── test_monitors.py
.env.example               # 環境変数サンプル
pyproject.toml             # 依存関係・ツール設定
```

## 設計パターン

### チャンネル抽象化

すべての通知チャンネルは `BaseChannel` を継承し、`send(message: str) -> bool` を実装する。

```python
from abc import ABC, abstractmethod

class BaseChannel(ABC):
    @abstractmethod
    def send(self, message: str) -> bool: ...
```

複数チャンネルへの同時送信は `MultiChannel` でラップする：

```python
class MultiChannel:
    def __init__(self, channels: list[BaseChannel]) -> None:
        self.channels = channels

    def send(self, message: str) -> dict[str, bool]:
        return {ch.__class__.__name__: ch.send(message) for ch in self.channels}
```

### モニター抽象化

監視ロジックは `BaseMonitor` を継承し、`check() -> AlertResult | None` を実装する。
`None` を返すと正常、`AlertResult` を返すとアラートをトリガーする。

### スケジューラー

```python
import schedule

schedule.every(5).minutes.do(run_monitors)
```

## 起動・テストコマンド

```bash
python -m venv .venv && source .venv/bin/activate
pip install -e ".[dev]"

python src/main.py          # 起動
pytest                      # テスト実行
pytest --cov=src/notifier   # カバレッジ付き
```

## 環境変数

APIキーは `.env`（`.gitignore` 済み）で管理する。`.env.example` を参照。

```bash
cp .env.example .env
# .env に実際のキーを設定
```

## AIエージェントへの注意事項

- APIキーは絶対にコードにハードコードしない（`.env` のみ）
- `BaseChannel` / `BaseMonitor` の抽象インターフェースを壊さない
- 新しいチャンネル追加時は `tests/test_channels.py` にテストを追加する
- スケジューラーのジョブはべき等（何度実行しても安全）にする
- 作業前に `task.md` を確認・更新する
