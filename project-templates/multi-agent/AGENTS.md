# AGENTS.md — Multi-Agent

## Shared Rules（全エージェント共通）
- `main` への直接 push 禁止
- BC間の直接依存禁止（shared/ 経由のみ）
- 他BCのファイルを勝手に変更しない
- 変更前に担当BCを明確に宣言する

## BC境界（Bounded Context）
各BCは独立したディレクトリで管理。
BC同士が通信する場合は shared/ のインターフェースを使う。

## エージェントメッセージング（Agent Teams使用時）
- オーケストレーターが全体タスクを分解して各BCエージェントに送信
- 各BCエージェントは完了後にオーケストレーターに報告
- コンフリクトが起きた場合はオーケストレーターが調停

## Dependency Rules
```
features/{{BC_A}} → shared/  ✅
features/{{BC_A}} → features/{{BC_B}}  ❌ (直接依存禁止)
shared/ → features/  ❌ (逆依存禁止)
```
