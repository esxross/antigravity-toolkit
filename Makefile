.DEFAULT_GOAL := help

.PHONY: help new-project list-templates check

help: ## このヘルプを表示する
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

new-project: ## 新規プロジェクトを対話形式で作成する
	@./scripts/new-project.sh

list-templates: ## 利用可能なテンプレート一覧を表示する
	@echo "利用可能なテンプレート:"
	@ls -1 project-templates/

check: ## このツールキットの構成を確認する
	@echo "=== Antigravity Toolkit 構成確認 ==="
	@echo ""
	@echo "[テンプレート]"
	@find project-templates -name "*.md" | sort
	@echo ""
	@echo "[スクリプト]"
	@ls -1 scripts/
	@echo ""
	@echo "[設定ファイル]"
	@ls -1 antigravity/ claude-code/
