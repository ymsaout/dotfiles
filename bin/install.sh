#!/bin/bash
set -e
set -o pipefail

# install.sh
#	macOS setup script — installs Homebrew, packages, and Rust

###############################################################################
# Helpers
###############################################################################

check_not_root() {
	if [ "$EUID" -eq 0 ]; then
		echo "Do not run as root. Homebrew doesn't like it."
		exit 1
	fi
}

###############################################################################
# Homebrew
###############################################################################

install_homebrew() {
	if ! command -v brew &>/dev/null; then
		echo "Installing Homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	else
		echo "Homebrew already installed, updating..."
		brew update
	fi
}

###############################################################################
# Base packages
###############################################################################

install_base() {
	install_homebrew

	# Xcode Command Line Tools (git, make, curl, etc.)
	xcode-select --install 2>/dev/null || true

	brew install \
		bash \
		bash-completion@2 \
		coreutils \
		findutils \
		gnupg \
		icdiff \
		jq \
		lolcat \
		lsof \
		ngrep \
		speedtest-cli \
		the_silver_searcher \
		tree \
		wget \
		xz

	brew cleanup

	# Set Homebrew bash as default shell
	local brew_bash
	brew_bash="$(brew --prefix)/bin/bash"
	if ! grep -qF "$brew_bash" /etc/shells; then
		echo "Adding $brew_bash to /etc/shells..."
		echo "$brew_bash" | sudo tee -a /etc/shells
	fi
	if [[ "$SHELL" != "$brew_bash" ]]; then
		echo "Changing default shell to Homebrew bash..."
		chsh -s "$brew_bash"
		echo "Done. Restart your terminal to use bash 5."
	fi
}

###############################################################################
# Node (nvm + LTS)
###############################################################################

install_node() {
	if ! command -v nvm &>/dev/null && [ ! -d "$HOME/.nvm" ]; then
		echo "Installing nvm..."
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | bash
	else
		echo "nvm already installed, updating..."
		(
			cd "$HOME/.nvm"
			git fetch --tags origin
			git checkout "$(git describe --abbrev=0 --tags --match 'v[0-9]*' "$(git rev-list --tags --max-count=1)")"
		)
	fi

	# Load nvm in current shell
	# shellcheck source=/dev/null
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

	echo "Installing Node LTS..."
	nvm install --lts
	nvm use --lts
	nvm alias default 'lts/*'
}

###############################################################################
# Rust
###############################################################################

install_rust() {
	if ! command -v rustup &>/dev/null; then
		echo "Installing Rust..."
		curl https://sh.rustup.rs -sSf | sh -s -- -y
		# shellcheck source=/dev/null
		. "$HOME/.cargo/env"
	else
		echo "Rust already installed, updating..."
		rustup update
	fi

	rustup component add rust-src
	rustup component add clippy
}

###############################################################################
# Usage / main
###############################################################################

usage() {
	echo -e "install.sh\\n\\tmacOS setup script\\n"
	echo "Usage:"
	echo "  base   - install Homebrew + base packages + bash 5"
	echo "  rust   - install Rust"
	echo "  node   - install nvm + Node LTS"
	echo "  all    - run everything (base + rust + node)"
}

main() {
	local cmd=$1

	if [[ -z "$cmd" ]]; then
		usage
		exit 1
	fi

	check_not_root

	case "$cmd" in
		base)
			install_base
			;;
		rust)
			install_rust
			;;
		node)
			install_node
			;;
		all)
			install_base
			install_rust
			install_node
			;;
		*)
			usage
			exit 1
			;;
	esac
}

main "$@"
