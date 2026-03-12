#!/bin/bash
# MacBook Setup Script - Development Environment
# Optimized for portable development work
# Run: bash setup-macbook.sh

set -e

echo "MacBook Setup - Development Environment"
echo "========================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Ask for sudo upfront
sudo -v

# Keep sudo alive
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo -e "${GREEN}1. Installing Xcode Command Line Tools${NC}"
xcode-select --install 2>/dev/null || echo "Already installed"

echo ""
echo -e "${GREEN}2. Installing Homebrew${NC}"
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew already installed"
fi

echo ""
echo -e "${GREEN}3. Installing Essential Tools${NC}"
brew install \
    git \
    wget \
    curl \
    jq \
    ripgrep \
    fd \
    bat \
    htop \
    btop \
    tree \
    tldr \
    gh

echo ""
echo -e "${GREEN}4. Installing GUI Applications${NC}"
brew install --cask \
    iterm2 \
    visual-studio-code \
    docker \
    rectangle \
    stats \
    claude

echo ""
echo -e "${GREEN}5. Installing Oh My Zsh${NC}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    sed -i '' 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' ~/.zshrc
else
    echo "Oh My Zsh already installed"
fi

echo ""
echo -e "${GREEN}6. Installing Python Environment (pyenv)${NC}"
brew install pyenv pyenv-virtualenv

cat >> ~/.zprofile << 'PYENV'

# Pyenv configuration
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
PYENV

source ~/.zprofile

echo ""
echo -e "${GREEN}7. Installing Python Versions${NC}"
pyenv install 3.14.3
pyenv install 3.13.1
pyenv global 3.14.3

echo ""
echo -e "${GREEN}8. Installing Database Tools${NC}"
brew install --cask tableplus nosql-workbench
brew install sqlite

echo ""
echo -e "${GREEN}9. Installing AWS Tools${NC}"
brew install awscli

echo ""
echo -e "${GREEN}10. Installing Claude Code${NC}"
brew install claude-code

echo ""
echo -e "${GREEN}11. Installing Syncthing${NC}"
brew install syncthing
brew services start syncthing

echo ""
echo -e "${GREEN}12. Configuring System Settings${NC}"

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true
killall Finder

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Faster key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Show path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

echo ""
echo -e "${GREEN}13. Configuring Git${NC}"
read -p "Enter your name for Git: " git_name
read -p "Enter your email for Git: " git_email

git config --global user.name "$git_name"
git config --global user.email "$git_email"
git config --global init.defaultBranch main
git config --global core.editor "code --wait"

# Git aliases
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

echo ""
echo -e "${GREEN}14. Generating SSH Keys${NC}"
if [ ! -f ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -C "$git_email" -f ~/.ssh/id_ed25519 -N ""
    eval "$(ssh-agent -s)"
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519
    
    echo ""
    echo -e "${YELLOW}Add this SSH key to GitHub:${NC}"
    cat ~/.ssh/id_ed25519.pub
    echo ""
    echo "Press Enter when you've added the key to GitHub..."
    read
else
    echo "SSH key already exists"
fi

echo ""
echo -e "${GREEN}15. Setting up GPG (optional for Git signing)${NC}"
read -p "Setup GPG for commit signing? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew install gnupg
    echo ""
    echo "Generate GPG key with: gpg --full-generate-key"
    echo "Then configure Git to use it:"
    echo "  git config --global user.signingkey YOUR_KEY_ID"
    echo "  git config --global commit.gpgsign true"
fi

echo ""
echo -e "${GREEN}16. Creating Directory Structure${NC}"
mkdir -p ~/projects
mkdir -p ~/Documents/work
mkdir -p ~/.config

echo ""
echo -e "${GREEN}Basic Setup Complete${NC}"
echo ""
echo "Next steps:"
echo "1. Create finance environment: bash setup-finance-env.sh"
echo "2. Configure AWS CLI: aws configure"
echo "3. Install VS Code extensions: bash install-vscode-extensions.sh"
echo "4. Configure Syncthing for multi-device sync"
echo "5. Install heartbeat client"
echo ""
