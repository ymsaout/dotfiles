# dotfiles

**macOS only.** Tested on Apple Silicon (M-series) with Homebrew.

**Table of Contents**

<!-- toc -->

- [About](#about)
  * [Requirements](#requirements)
  * [Installing](#installing)
  * [Customizing](#customizing)
  * [Utilities](#utilities)

<!-- tocstop -->

## About

My macOS dotfiles — bash config, aliases, functions, git settings, and more.

### Requirements

- macOS Apple Silicon (M-series)
- [Homebrew](https://brew.sh)
- Xcode Command Line Tools: `xcode-select --install`

### Installing

Clone the repo and create the symlinks:

```console
$ git clone git@github.com:ymsaout/dotfiles.git ~/dotfiles
$ cd ~/dotfiles
$ make
```

For a full setup from scratch (Homebrew packages, Rust, symlinks):

```console
$ cd ~/dotfiles
$ make           # create symlinks
$ make bootstrap # Homebrew + packages + Rust
```

Or step by step:

```console
$ bin/install.sh base  # Homebrew + packages + bash 5
$ bin/install.sh rust  # Rust
```

### Customizing

Save env vars, tokens, and machine-specific config in a `~/.extra` file (not committed). Use `.extra.example` as a template:

```console
$ cp ~/dotfiles/.extra.example ~/.extra
```

**Git identity is required** — it is not stored in `.gitconfig`:

```bash
export GIT_AUTHOR_NAME="Your Name"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
export GIT_AUTHOR_EMAIL="you@example.com"
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
export GITHUB_USER="your_github_username"
```

### Utilities

| Script | Description |
|--------|-------------|
| `bin/install.sh` | Full macOS setup (Homebrew, Rust, dotfiles) |
| `bin/macos-defaults` | Apply macOS system preferences. Run once after a fresh install. Usage: `COMPUTER_NAME="mymac" TIMEZONE="Europe/Paris" bin/macos-defaults` |
| `bin/update-repos` | `git pull` all repos found in `$HOME` |
