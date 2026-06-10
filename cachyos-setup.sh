#!/bin/bash

# =========================================================
#  CachyOS Gaming/Desktop Setup Script
# =========================================================


# Version: 0.3

# Changes 0.3

# Added package tk, zen-browser and parsec
# Added update command for system update


set -e

# -----------------------------
# Colors
# -----------------------------
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
MAGENTA="\e[35m"
RESET="\e[0m"

# -----------------------------
# Pretty output
# -----------------------------
print_header() {
    clear
    echo -e "${MAGENTA}"
    echo "================================================="
    echo "        CachyOS Desktop Setup Script"
    echo "================================================="
    echo -e "${RESET}"
}

print_step() {
    echo -e "\n${BLUE}==>${RESET} $1"
}

print_success() {
    echo -e "${GREEN}[OK]${RESET} $1"
}

print_skip() {
    echo -e "${YELLOW}[SKIP]${RESET} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${RESET} $1"
}

# -----------------------------
# Spinner
# -----------------------------
spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'

    while ps a | awk '{print $1}' | grep -q "$pid"; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done

    printf "    \b\b\b\b"
}

# -----------------------------
# Check yay
# -----------------------------
install_yay() {
    if command -v yay &>/dev/null; then
        print_skip "yay already installed"
        return
    fi

    print_step "Installing yay..."

    sudo pacman -Sy --needed git base-devel --noconfirm

    git clone https://aur.archlinux.org/yay.git /tmp/yay >/dev/null 2>&1

    cd /tmp/yay

    makepkg -si --noconfirm >/dev/null 2>&1 &
    spinner

    cd ~

    print_success "yay installed"
}

# -----------------------------
# Install package if missing
# -----------------------------
install_package() {
    local package="$1"

    if pacman -Qi "$package" &>/dev/null; then
        print_skip "$package already installed"
    else
        print_step "Installing $package..."

        yay -S --noconfirm --needed "$package" >/dev/null 2>&1 &
        spinner

        print_success "$package installed"
    fi
}
# -----------------------------
# Create shell alias
# -----------------------------
create_alias() {

    local alias_name="$1"
    local alias_command="$2"

    for shellrc in "$HOME/.bashrc" "$HOME/.zshrc"; do

        touch "$shellrc"

        if grep -q "alias ${alias_name}=" "$shellrc" 2>/dev/null; then
            print_skip "Alias '${alias_name}' already exists in $(basename "$shellrc")"
        else
            {
                echo ""
                echo "# Added by CachyOS setup script"
                echo "alias ${alias_name}='${alias_command}'"
            } >> "$shellrc"

            print_success "Alias '${alias_name}' added to $(basename "$shellrc")"
        fi
    done
}

# -----------------------------
# Install MacTahoe KDE Theme
# -----------------------------
install_mactahoe() {

    THEME_DIR="$HOME/.themes"
    ICON_DIR="$HOME/.icons"

    if [[ -d "$THEME_DIR/MacTahoe-kde" ]]; then
        print_skip "MacTahoe-kde already installed"
        return
    fi

    print_step "Installing MacTahoe KDE theme..."

    mkdir -p "$THEME_DIR"
    mkdir -p "$ICON_DIR"

    cd /tmp

    if [[ ! -d "/tmp/MacTahoe-kde" ]]; then
        git clone https://github.com/vinceliuice/MacTahoe-kde.git >/dev/null 2>&1 &
        spinner
    fi

    cd /tmp/MacTahoe-kde

    chmod +x install.sh

    ./install.sh >/dev/null 2>&1 &
    spinner

    print_success "MacTahoe KDE installed"
}

# -----------------------------
# Setup Kvantum Theme
# -----------------------------
setup_kvantum() {

    print_step "Configuring Kvantum..."

    mkdir -p "$HOME/.config/Kvantum"

    cat > "$HOME/.config/Kvantum/kvantum.kvconfig" <<EOF
[General]
theme=MacTahoe
EOF

    print_success "Kvantum configured"
}

# -----------------------------
# Update system
# -----------------------------
update_system() {

    print_step "Updating entire system..."

    update --noconfirm  >/dev/null 2>&1 &
    spinner

    yay -Syu --noconfirm >/dev/null 2>&1 &
    spinner

    print_success "System updated"
}

# =========================================================
# MAIN
# =========================================================

print_header

install_yay

# -----------------------------
# Apps list
# -----------------------------
apps=(
    discord
    steam
    spotify
    mission-center
    protonup-qt
    heroic-games-launcher
    kvantum
    git
    parsec
    zen-browser
    tk
)

TOTAL=${#apps[@]}
COUNT=0

# -----------------------------
# Install apps
# -----------------------------
for app in "${apps[@]}"; do

    COUNT=$((COUNT + 1))

    echo -e "\n${CYAN}[${COUNT}/${TOTAL}]${RESET} Processing ${app}"

    install_package "$app"

done

# -----------------------------
# Create aliases
# -----------------------------
print_step "Creating terminal aliases..."

create_alias \
    "vencord" \
    'sh -c "$(curl -sS https://vencord.dev/install.sh)"'

create_alias \
    "spicetify-setup" \
    'curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh'

# -----------------------------
# Theme setup
# -----------------------------
install_mactahoe
setup_kvantum

# -----------------------------
# Final update
# -----------------------------
update_system

# -----------------------------
# Finished
# -----------------------------
echo -e "\n${GREEN}========================================${RESET}"
echo -e "${GREEN}      Setup completed successfully!${RESET}"
echo -e "${GREEN}========================================${RESET}"

read -rp "Reboot now? [y/N]: " reboot_choice

if [[ "$reboot_choice" =~ ^[Yy]$ ]]; then
    sudo reboot
fi
