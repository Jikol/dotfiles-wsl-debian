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
  "claude/CLAUDE.md:$HOME/.local/share/claude/CLAUDE.md"
  "claude/settings.json:$HOME/.local/share/claude/settings.json"
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

run_cron() {
  local jobs_file="$CONFIG_PATH/cron/crontab.jobs"
  local begin_marker="# >>> dotfiles-managed cron jobs >>>"
  local end_marker="# <<< dotfiles-managed cron jobs <<<"

  if [[ ! -f "$jobs_file" ]]; then
    return
  fi

  local current stripped merged
  current=$(crontab -l 2>/dev/null || true)
  stripped=$(printf '%s\n' "$current" | sed "/^${begin_marker}\$/,/^${end_marker}\$/d")
  merged=$(printf '%s\n%s\n%s\n%s\n' "$stripped" "$begin_marker" "$(cat "$jobs_file")" "$end_marker")

  printf '%s\n' "$merged" | crontab -
  echo -e "${CYAN_CLR}Cron jobs synced from $jobs_file${NC_CLR}"
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
    run_cron
    ;;
  *)
    echo "Usage: $0 [sync-to|sync-from]"
    echo "sync-to   — ~/.config → ~/dotfiles/dotconfig"
    echo "sync-from — ~/dotfiles/dotconfig → ~/.config"
    ;;
esac
