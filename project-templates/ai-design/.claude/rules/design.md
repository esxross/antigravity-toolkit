---
description: デザインルールと禁止パターン（UI生成・コンポーネント作成時に適用）
paths:
  - "src/components/**"
  - "src/app/**"
  - "**/*.tsx"
  - "**/*.css"
---

# デザインルールと禁止パターン

## 基本原則
1. デザイントークンは `design/tokens.json` から参照する（SSOT）
2. Tailwindクラスに直接カラーコードを書かない
3. 疑問があれば `design/CLAUDE-design.md` を確認する

---

## ❌ 禁止パターン（AIが生成しがちなNG例）

### 色
| 禁止 | 代替 |
|------|------|
| `text-black` | `text-slate-900` |
| `text-gray-*` (任意指定) | `text-slate-500` または `text-slate-700` |
| `bg-blue-500` ハードコード | `bg-primary-500` |
| `bg-indigo-*` ハードコード | `bg-primary-*` |
| `text-white` on 薄背景 | コントラスト比を確認する |

### 影
| 禁止 | 代替 |
|------|------|
| `shadow-lg` | `shadow-sm` |
| `shadow-xl` | `shadow-sm`（特別な場合のみ `shadow-md`） |
| `shadow-2xl` | 使用禁止 |

### 装飾
| 禁止 | 代替 |
|------|------|
| `border-l-4` カラーバー（カード上部・左） | `border rounded-lg` 全周ボーダー |
| カードヘッダーのカラーバー | フラットなカード |
| グラデーション（`bg-gradient-*`） | 指示がある場合のみ |
| `animate-bounce` / `animate-pulse` 多用 | `transition-opacity` 程度に留める |
| 絵文字の多用 | 明示的に指示された場合のみ |

### レイアウト
| 禁止 | 代替 |
|------|------|
| 過度なネスト（5層以上） | フレックス/グリッドでシンプルに |
| `min-h-screen` の乱用 | 必要な箇所のみ |

---

## ✅ 推奨パターン

### ボタン
```tsx
// Primary: bg-primary-500 text-white shadow-sm rounded-md
// Secondary: border border-slate-200 text-slate-700 rounded-md
// Danger: bg-danger-500 text-white rounded-md
```

### カード
```tsx
// border border-slate-200 rounded-lg bg-white p-4
// ✗ shadow-lg は使わない → shadow-sm まで
```

### テキスト
```tsx
// 見出し: text-slate-900 font-semibold
// 本文: text-slate-700
// サブ: text-slate-500
// ✗ text-black は使わない
```

---

## 禁止パターンの追加方法
「AIっぽい」と感じたら `/ban-pattern` スキルを実行して追加する。
