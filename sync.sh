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

# relative paths in ~/.config
SYMLINKS=(
  "docker/config.json:$HOME/.docker/config.json"
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

run_links() {
  for pair in "${SYMLINKS[@]}"; do
    local src="$CONFIG_PATH/${pair%%:*}"
    local dst="${pair##*:}"
    
    if [[ ! -e "$src" ]]; then
      echo -e "${RED_CLR}Source not found: $src${NC_CLR}"
      continue
    fi

    mkdir -p "$(dirname "$dst")"

    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
      echo -e "${GREEN_CLR}Already linked: $dst${NC_CLR}"
    else
      [[ -e "$dst" || -L "$dst" ]] && rm "$dst"
      ln -s "$src" "$dst"
      echo -e "${CYAN_CLR}Symlinked: $dst -> $src${NC_CLR}"
    fi
  done
}

# ─── Main logic ────────────────────────
case "${1:-}" in
  sync-to)
    mkdir -p "$DOTFILES_PATH"
    run_sync "$CONFIG_PATH/" "$DOTFILES_PATH/"
    ;;
  sync-from)
    run_sync "$DOTFILES_PATH/" "$CONFIG_PATH/"
    run_links
    ;;
  *)
    echo "Usage: $0 [sync-to|sync-from]"
    echo "sync-to   — ~/.config → ~/dotfiles/dotconfig"
    echo "sync-from — ~/dotfiles/dotconfig → ~/.config"
    ;;
esac
