SHELL := bash

.PHONY: all
all: dotfiles ## Installs the dotfiles.

.PHONY: bootstrap
bootstrap: ## Full setup: Homebrew + packages + Rust (bin/install.sh all).
	bin/install.sh all

.PHONY: dotfiles
dotfiles: ## Creates symlinks for all dotfiles in $HOME.
	for file in $(shell find $(CURDIR) -maxdepth 1 -name ".*" \
		-not -name ".git" \
		-not -name ".gitignore" \
		-not -name ".github" \
		-not -name ".config" \
		-not -name ".gnupg" \
		-not -name ".*.swp" \
		-not -name ".extra" \
		-not -name ".extra.example"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done
	ln -sfn $(CURDIR)/gitignore $(HOME)/.gitignore
	git update-index --skip-worktree $(CURDIR)/.gitconfig

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
