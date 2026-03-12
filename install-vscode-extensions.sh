#!/bin/bash
# Install recommended VS Code extensions for development

set -e

echo "Installing VS Code Extensions..."
echo ""

# Verify code CLI is available
if ! command -v code &> /dev/null; then
    echo "VS Code command line tool not found."
    echo "Open VS Code and run: Command Palette (Cmd+Shift+P) > Shell Command: Install 'code' command in PATH"
    exit 1
fi

# Python
echo "Installing Python extensions..."
code --install-extension ms-python.python
code --install-extension ms-python.vscode-pylance
code --install-extension ms-python.debugpy

# Claude Code
echo "Installing Claude Code extension..."
code --install-extension anthropic.claude-code

# Git
echo "Installing Git extensions..."
code --install-extension eamodio.gitlens
code --install-extension GitHub.copilot

# Data formats
echo "Installing data format extensions..."
code --install-extension mechatroner.rainbow-csv
code --install-extension janisdd.vscode-edit-csv

# Markdown
echo "Installing Markdown extensions..."
code --install-extension yzhang.markdown-all-in-one
code --install-extension bierner.markdown-mermaid

# Docker
echo "Installing Docker extension..."
code --install-extension ms-azuretools.vscode-docker

# AWS
echo "Installing AWS extension..."
code --install-extension amazonwebservices.aws-toolkit-vscode

# Utilities
echo "Installing utility extensions..."
code --install-extension esbenp.prettier-vscode
code --install-extension dbaeumer.vscode-eslint
code --install-extension streetsidesoftware.code-spell-checker
code --install-extension EditorConfig.EditorConfig

# Theme
echo "Installing theme..."
code --install-extension GitHub.github-vscode-theme

echo ""
echo "VS Code extensions installed successfully"
echo ""
echo "Recommended settings (optional):"
echo '  - Theme: GitHub Dark Default'
echo '  - Font: Menlo, Monaco, or SF Mono'
echo '  - Format on Save: Enabled'
