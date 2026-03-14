# AGENTS.md - Antigravity マルチエージェント構成

このドキュメントはAIエージェントが読むことを前提に書かれています。
プロジェクトに参加するすべてのエージェントはこのファイルを最初に読んでください。

---

## チーム構成

| 役割 | 担当 | ツール |
|------|------|--------|
| **Lead（Antigravity）** | 要件整理・設計・ファイル書き込み・テスト実行・コミット | Claude Code 標準ツール |
| **Teammate（GLM）** | コード生成・テスト生成・コードレビュー | MCP経由（下記参照） |

**基本方針: Leadは「計画・指示・検証」に集中し、コーディングはGLMに委譲する。**

---

## GLM MCPサーバー一覧

モデル: **GLM-4.6**（6インスタンス・TDD役割分担構成）

| インスタンス | ツール名 | 役割 | TDDフェーズ |
|---|---|---|---|
| glm-46 | `mcp__glm-46__ask_glm` | テスト生成A（正常系・仕様ベース） | 🔴 RED |
| glm-46b | `mcp__glm-46b__ask_glm` | テスト生成B（異常系・エッジケース） | 🔴 RED |
| glm-46c | `mcp__glm-46c__ask_glm` | 実装 Actor A（テストを通す最小実装） | 🟢 GREEN |
| glm-46d | `mcp__glm-46d__ask_glm` | 実装 Actor B（Best-of-N 別実装案） | 🟢 GREEN |
| glm-46e | `mcp__glm-46e__ask_glm` | Critic（テスト・実装の批評・改善提案） | 🔵 REFACTOR |
| glm-46f | `mcp__glm-46f__ask_glm` | セキュリティ・品質レビュー | 全フェーズ |

### 並列呼び出しの原則
- 依存関係のないタスクは**同時に**呼び出す（例: 実装とテストの並列生成）
- GLMは**ステートレス**。毎回必要なコンテキスト（ファイル内容・型定義・規約）を渡す
- GLMのエラーは握りつぶさず、必ず上位に伝播する

---

## 標準ワークフロー

```
1. [Lead]   要件整理・設計（プランモード）
2. [Lead]   関連ファイルを読み込み、GLMへのコンテキストを準備
3. [glm-46] 実装を生成 / [glm-46b] テストを生成（並列）
4. [Lead]   生成されたコードをレビューしてファイルに書き込む
5. [Lead]   テスト実行
6. テスト失敗時 → [glm-46] エラーログを渡して修正案を生成
7. [Lead]   修正適用 → 再テスト → コミット
```

## TDDワークフロー

```
🔴 RED
  [glm-46b] 仕様から失敗テストを生成
  [Lead]    テスト保存 → 実行（失敗を確認）

🟢 GREEN
  [glm-46]  テストを通す最小実装を生成
  [Lead]    実装保存 → テスト実行（成功を確認）

🔵 REFACTOR
  [glm-46c] レビュー・リファクタ案を生成
  [Lead]    適用 → 回帰テスト確認 → コミット
```

---

## GLMへの指示フォーマット（Faceted Prompting）

GLMへの指示はこの4層で構成する：

| 層 | 役割 | 内容例 |
|----|------|--------|
| **Persona** | 誰として振る舞うか | 「シニアTypeScriptエンジニアとして」 |
| **Policy** | 判断基準・禁止パターン | `any`禁止、早期リターン必須、未使用コード削除 |
| **Knowledge** | 前提知識・既存コード | 関連ファイルの内容、型定義、API仕様 |
| **Instruction** | 今回の具体的な作業 | 「○○を修正して△△を実装せよ」 |

- **Persona・PolicyはKnowledgeに含めて毎回渡す**（GLMはステートレスなため）
- Instructionは簡潔かつ具体的に書く

### 指示テンプレート
```
あなたはシニアTypeScriptエンジニアです。

【規約】
- any禁止、明示的な型定義を使う
- ネストは浅く、早期リターンを使う
- 未使用コード・コメントアウトは削除する

【コンテキスト】
<既存コードや型定義をここに貼る>

【タスク】
<具体的な実装指示をここに書く>

出力はコードのみ。説明は不要。
```

---

## その他MCPサーバー一覧

| サーバー | ツール名プレフィックス | 用途 |
|---|---|---|
| github-mcp-server | `mcp__github-mcp-server__` | GitHub ISSUE/PR操作 |
| notion | `mcp__notion__` | Notionページ読み書き |
| notion-mcp-server | `mcp__notion-mcp-server__` | Notion（代替） |
| notebooklm | `mcp__notebooklm__` | 仕様書Q&A・要約 |
| cocoindex-code | `mcp__cocoindex-code__` | コードベース横断検索 |
| StitchMCP | `mcp__StitchMCP__` | Google Stitch連携 |
| pencil | `mcp__pencil__` | UI/デザイン生成 |

### 使い分けの原則

| やりたいこと | 使うMCP |
|---|---|
| ISSUEを作成・取得する | `github-mcp-server` |
| PRを作成・レビューする | `github-mcp-server` |
| Notionに仕様を書く/読む | `notion` |
| 仕様書を要約・Q&Aする | `notebooklm` |
| コードベースを横断検索する | `cocoindex-code` |
| UIデザインを生成・編集する | `pencil` |

詳細ワークフロー:
- GitHub ISSUE/PR: `.agents/workflows/github.md`
- Notion: `.agents/workflows/notion.md`

---

## Git コミット・プッシュルール

### コミットの原則

**「1コミット = 1つの理由」**

```
feat: ログイン機能を追加        ✅ 良い例
fix: トークン期限切れ時のリダイレクトを修正  ✅ 良い例
いろいろ修正                   ❌ 悪い例
```

**コミットメッセージ形式（Conventional Commits）**

```
<type>(<scope>): <説明>

type: feat / fix / docs / refactor / test / chore / perf / ci
```

### プッシュのルール

- **`main` への直接 push は禁止**。必ず `feat/xxx` ブランチを作成してPRを出す
- **force push は禁止**（チームメンバーのローカルを破壊する）
- **ユーザーの明示的な承認なしに push しない**

### ブランチ戦略

```
main                  ← 常にデプロイ可能な状態を維持
  feat/feature-name   ← 機能追加
  fix/bug-description ← バグ修正
  refactor/xxx        ← リファクタリング
```

### AIエージェント環境での追加ルール

| ルール | 理由 |
|---|---|
| GLM生成コードはLeadがレビュー後にコミット | AI生成コードはセキュリティバグが1.5〜2倍多い |
| コミット前にテスト実行を必須とする | 壊れた状態をpushしない |
| worktreeブランチはPRマージ後に削除 | リポジトリの肥大化防止 |
| APIキー・シークレットは絶対にコミットしない | 環境変数を使う |

### Draft PR の活用

実装が完了する前でも早めにPRを出す（WIP段階でフィードバックをもらう）：

```
gh pr create --draft --title "feat: ○○機能" --body "WIP: ○○を実装中"
```

レビュー準備ができたら Draft を解除してレビューを依頼する。

---

## 詳細ガイド参照先

- GLMワークフロー詳細: `.agents/workflows/glm_parallel.md`
- GitHub ISSUE/PR: `.agents/workflows/github.md`
- Notion: `.agents/workflows/notion.md`
- Claude Codeツール全般: `~/.claude/mcp-claude.md`
- ワークフローパターン集: `~/.claude/workflow.md`
