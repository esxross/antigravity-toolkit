# AGENTS.md — Python Notifier

## Project Context
- Stack: Python 3.11+ / pytest / schedule or APScheduler
- Architecture: チャンネル抽象化 + モニター分離
- Testing: pytest

## Agent Rules

### 必須
- `main` への直接 push 禁止（ブランチで作業）
- APIキー・Webhook URL はコードにハードコードしない（`.env` のみ）
- 完了前に `pytest` を実行して確認する
- 新しいチャンネルを追加するときは `tests/test_channels.py` にテストを追加する

### コード品質
- 型アノテーションを必ず付ける（`str`, `bool`, `list[...]`, etc.）
- 未使用のimport・変数は残さない
- `BaseChannel.send()` は成功時 `True`、失敗時 `False` を返す（例外を外に漏らさない）
- HTTP リクエストは timeout を必ず設定する（デフォルト: 10秒）

### 通知チャンネルの実装ルール
- `BaseChannel` を継承して `send(message: str) -> bool` を実装する
- 送信失敗は例外を握りつぶさず `logger.error` に記録してから `False` を返す
- レート制限・リトライは各チャンネルクラス内で処理する

### スケジューラーのルール
- ジョブはべき等にする（何度実行しても副作用が安全）
- ジョブ内で例外が発生しても scheduler を止めない（try/except で包む）
- アラート重複送信を防ぐ cooldown ロジックを入れる（デフォルト: 同一アラートは 1時間に1回）

## 優先順位
1. 動くこと（通知が確実に届く）
2. セキュリティ（APIキー・Webhook URLの保護）
3. 信頼性（失敗しても scheduler が止まらない）
4. コード品質
