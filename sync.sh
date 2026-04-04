#!/usr/bin/env bash

# ─── Configuration ────────────────────────────────
DOTFILES_PATH="$HOME/dotfiles/dotconfig"
CONFIG_PATH="$HOME/.config"

# relative paths in ~/.config
EXCLUDE_PATHS=(
  "tmux/plugins"
  "fish/fish_variables"
  "io.datasette.llm"
)

# ─── Arguments composition ────────────────────────
EXCLUDE_ARGS=()
for path in "${EXCLUDE_PATHS[@]}"; do
  EXCLUDE_ARGS+=(--exclude="$path")
done

# ─── Helpers ──────────────────────────────────────
GREEN_CLR='\033[0;32m'
CYAN_CLR='\033[0;36m'
NC_CLR='\033[0m'
 
run_sync() {
  local src="$1" dst="$2"
  output=$(rsync -a --delete --out-format="%n" "${EXCLUDE_ARGS[@]}" "$src" "$dst")
  if [[ -z "$output" ]]; then
    echo -e "${GREEN_CLR}No need to perform sync operation${NC_CLR}"
  else
    echo -e "${CYAN_CLR}$output${NC_CLR}"
  fi
}

# ─── Main logic ────────────────────────
case "${1:-}" in
  sync-to)
    mkdir -p "$DOTFILES_PATH"
    run_sync "$CONFIG_PATH/" "$DOTFILES_PATH/"
    ;;
  sync-from)
    run_sync "$DOTFILES_PATH/" "$CONFIG_PATH/"
    ;;
  *)
    echo "Usage: $0 [sync-to|sync-from]"
    echo "sync-to   — ~/.config → ~/dotfiles/dotconfig"
    echo "sync-from — ~/dotfiles/dotconfig → ~/.config"
    ;;
esac
