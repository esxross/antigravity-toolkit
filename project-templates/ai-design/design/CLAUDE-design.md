# デザインシステム クイックリファレンス

> このファイルを読むだけで基本的なUIが生成できるように設計されています。
> 詳細な値はすべて `tokens.json` が SSOT（唯一の真実の源）です。

---

## カラートークン

| トークン名 | 用途 |
|-----------|------|
| `primary-500` | メインアクション（ボタン・リンク） |
| `primary-100` | 薄い背景・ホバー状態 |
| `slate-900` | メインテキスト（`text-black` 禁止） |
| `slate-500` | サブテキスト・プレースホルダー |
| `slate-100` | 背景・ボーダー |
| `danger-500` | エラー・削除 |
| `success-500` | 成功・確認 |

## スペーシング

| トークン | px換算 | 用途 |
|---------|--------|------|
| `space-1` | 4px | 要素内の微調整 |
| `space-2` | 8px | アイコン+テキストの間隔 |
| `space-4` | 16px | コンポーネント内の余白 |
| `space-6` | 24px | コンポーネント間の余白 |
| `space-10` | 40px | セクション間の余白 |

## コンポーネント早見表

### ボタン
```html
<!-- Primary -->
<button class="btn-primary">ラベル</button>

<!-- Secondary -->
<button class="btn-secondary">ラベル</button>

<!-- Danger -->
<button class="btn-danger">削除</button>
```

### カード
```html
<div class="card">
  <div class="card-header">タイトル</div>
  <div class="card-body">コンテンツ</div>
</div>
```
※ カードヘッダーにカラーバー（border-l-4）は使わない

### フォーム
```html
<div class="form-group">
  <label class="form-label">ラベル</label>
  <input class="form-input" type="text" />
  <p class="form-error">エラーメッセージ</p>
</div>
```

### バッジ・ステータス
```html
<span class="badge-success">完了</span>
<span class="badge-warning">保留</span>
<span class="badge-danger">エラー</span>
```

---

## タスクベース読み込みガイド

| 作成するUI | 追加で読むファイル |
|-----------|----------------|
| フォーム画面 | `design/patterns/form.md` |
| 一覧・テーブル | `design/patterns/table.md` |
| ダッシュボード・カード | `design/patterns/card.md` |
| LP・マーケティングページ | `design/patterns/lp-structure.md` |

---

## 禁止パターン（重要）

完全リスト → `.claude/rules/design.md`

**絶対に使わない**:
- `text-black` → `text-slate-900`
- `shadow-lg` / `shadow-xl` → `shadow-sm`
- `border-l-4` カラーバー
- ハードコードカラー（`bg-blue-500` 等）
- 絵文字（指示がない限り）
- グラデーション（指示がない限り）
