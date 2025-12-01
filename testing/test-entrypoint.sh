#!/bin/bash
# test-entrypoint.sh
# This script tests the chezmoi dotfiles installation in Docker containers

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Testing Chezmoi Dotfiles Installation${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Function to print step
print_step() {
    echo -e "\n${BLUE}>>> $1${NC}"
}

# Function to check if command exists (silent)
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to verify command exists (with output)
verify_command() {
    local cmd=$1
    local pkg=${2:-$cmd}

    if command_exists "$cmd"; then
        echo -e "  ${GREEN}✓${NC} $pkg installed ($cmd available)"
        return 0
    else
        echo -e "  ${RED}✗${NC} $pkg NOT installed ($cmd not found)"
        return 1
    fi
}

# Function to verify command with alternative names
verify_command_alt() {
    local pkg=$1
    local cmd1=$2
    local cmd2=$3

    if command_exists "$cmd1"; then
        echo -e "  ${GREEN}✓${NC} $pkg installed ($cmd1 available)"
        return 0
    elif command_exists "$cmd2"; then
        echo -e "  ${GREEN}✓${NC} $pkg installed ($cmd2 available)"
        return 0
    else
        echo -e "  ${RED}✗${NC} $pkg NOT installed ($cmd1 or $cmd2 not found)"
        return 1
    fi
}

# Step 1: Initialize chezmoi with the mounted dotfiles
print_step "Initializing chezmoi from /dotfiles"
if chezmoi init --source=/dotfiles; then
    echo -e "${GREEN}✓${NC} Chezmoi initialized successfully"
else
    echo -e "${RED}✗${NC} Failed to initialize chezmoi"
    exit 1
fi

# Step 2: Apply the dotfiles (this will run the package installation script)
print_step "Applying dotfiles (this will install packages)"
if chezmoi apply --source=/dotfiles; then
    echo -e "${GREEN}✓${NC} Dotfiles applied successfully"
else
    echo -e "${RED}✗${NC} Failed to apply dotfiles"
    exit 1
fi

# Step 3: Verify installed packages
print_step "Verifying installed packages"

FAILED_COUNT=0

# Check each expected package
verify_command "zsh" "zsh" || ((FAILED_COUNT++))
verify_command "git" "git" || ((FAILED_COUNT++))
verify_command "nvim" "neovim" || ((FAILED_COUNT++))
verify_command_alt "bat" "bat" "batcat" || ((FAILED_COUNT++))
verify_command "zoxide" "zoxide" || ((FAILED_COUNT++))
verify_command "lazygit" "lazygit" || ((FAILED_COUNT++))
verify_command "fzf" "fzf" || ((FAILED_COUNT++))
verify_command "rg" "ripgrep" || ((FAILED_COUNT++))
verify_command_alt "fd" "fd" "fdfind" || ((FAILED_COUNT++))
verify_command "eza" "eza" || ((FAILED_COUNT++))

# Summary
echo -e "\n${BLUE}========================================${NC}"
if [[ $FAILED_COUNT -eq 0 ]]; then
    echo -e "${GREEN}✓ All packages verified successfully!${NC}"
    echo -e "${BLUE}========================================${NC}\n"
    exit 0
else
    echo -e "${YELLOW}⚠ $FAILED_COUNT package(s) failed verification${NC}"
    echo -e "${BLUE}========================================${NC}\n"
    exit 1
fi
