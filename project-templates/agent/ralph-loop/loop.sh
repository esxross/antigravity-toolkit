#!/bin/bash
# Ralph Loop — 自律ループスクリプト
# 使い方: ./loop.sh [max_iterations]

set -euo pipefail

MAX_ITERATIONS=${1:-20}
FAIL_THRESHOLD=3
consecutive_failures=0

echo "🔄 Ralph Loop 開始 (最大 ${MAX_ITERATIONS} イテレーション)"

for i in $(seq 1 "$MAX_ITERATIONS"); do
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "▶ イテレーション $i / $MAX_ITERATIONS"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  # ステータス確認
  STATUS=$(node -e "const p=require('./progress.json');console.log(p.status)" 2>/dev/null || echo "not_started")
  ERROR_COUNT=$(node -e "const p=require('./progress.json');console.log(p.error_count)" 2>/dev/null || echo "0")

  if [ "$STATUS" = "done" ]; then
    echo "✅ 目標達成。ループ終了。"
    break
  fi

  if [ "$STATUS" = "blocked" ]; then
    echo "🚫 ブロッカー検出。人間の確認が必要です。"
    BLOCKERS=$(node -e "const p=require('./progress.json');console.log(JSON.stringify(p.blockers,null,2))" 2>/dev/null || echo "[]")
    echo "ブロッカー: $BLOCKERS"
    break
  fi

  if [ "$ERROR_COUNT" -ge 5 ]; then
    echo "⚠️ エラーが 5 回以上発生しました。ループを停止します。"
    break
  fi

  # Claude 実行
  if claude --dangerously-skip-permissions; then
    consecutive_failures=0
    echo "✔ イテレーション $i 完了"
  else
    consecutive_failures=$((consecutive_failures + 1))
    echo "✗ イテレーション $i 失敗 (連続失敗: $consecutive_failures / $FAIL_THRESHOLD)"

    # progress.json の error_count を更新
    node -e "
      const fs=require('fs');
      const p=JSON.parse(fs.readFileSync('./progress.json','utf8'));
      p.error_count=(p.error_count||0)+1;
      p.updated_at=new Date().toISOString();
      fs.writeFileSync('./progress.json',JSON.stringify(p,null,2));
    " 2>/dev/null || true

    if [ "$consecutive_failures" -ge "$FAIL_THRESHOLD" ]; then
      echo "🛑 Backpressure Gate: 連続 ${FAIL_THRESHOLD} 回失敗。ループを停止します。"
      break
    fi
  fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "ループ終了。最終ステータス:"
cat progress.json
