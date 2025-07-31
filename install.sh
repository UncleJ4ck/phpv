#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_error(){ echo -e "${RED}Error: $1${NC}"; }
print_warning(){ echo -e "${YELLOW}Warning: $1${NC}"; }
print_success(){ echo -e "${GREEN}$1${NC}"; }
print_info(){ echo -e "${BLUE}$1${NC}"; }

install_phpv(){
    print_info "Crafting directories like a master builder..."
    mkdir -p "$HOME/src" "$HOME/bin"

    if [ ! -f "phpv" ]; then
        print_info "Summoning phpv script from the mystical GitHub realms..."
        curl -fsSL -o phpv https://raw.githubusercontent.com/Its-Satyajit/phpv/main/phpv || { print_error "Failed to download phpv."; exit 1; }
    else
        print_info "Found a local copy of phpv, because we believe in magic!"
    fi

    cp phpv "$HOME/bin/phpv"
    chmod +x "$HOME/bin/phpv"

    export PATH="$HOME/bin:$PATH"

    update_config(){
        [ -f "$1" ] || return 0
        grep -qx 'export PATH="$HOME/bin:$PATH"' "$1" || echo 'export PATH="$HOME/bin:$PATH"' >>"$1"
    }

    update_config "$HOME/.bash_profile"
    update_config "$HOME/.bashrc"
    update_config "$HOME/.zshrc"
    update_config "$HOME/.profile"

    command -v phpv >/dev/null && print_success "Installation complete! Your PHPV wand is now ready to wield." || print_error "Installation failed."
}

install_phpv "$@"
