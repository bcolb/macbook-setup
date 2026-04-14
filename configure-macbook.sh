#!/bin/bash
# MacBook-specific optimizations and shell configuration

echo "Configuring MacBook for portable development..."

# Add to ~/.zshrc (idempotent — skip if already configured)
if ! grep -q "# MacBook Development Configuration" ~/.zshrc 2>/dev/null; then
cat >> ~/.zshrc << 'ZSHRC'

# MacBook Development Configuration

# Python optimization
export PYTHONUNBUFFERED=1

# Quick aliases
alias finance='pyenv activate finance-env'
alias jlab='jupyter lab'
alias aws-whoami='aws sts get-caller-identity'
alias myip='curl -s ifconfig.me'
alias ports='lsof -i -P -n | grep LISTEN'

# Git shortcuts (in addition to global aliases)
alias gs='git status'
alias gp='git pull'
alias gpu='git push'
alias gd='git diff'

# Python virtual environment shortcuts
alias venv-create='python3 -m venv venv'
alias venv-activate='source venv/bin/activate'

# Directory shortcuts
alias projects='cd ~/projects'
alias work='cd ~/Documents/work'

# System shortcuts
alias cleanup='brew cleanup && brew autoremove'
alias update='brew update && brew upgrade && brew cleanup'

# Show git branch in prompt (if not using oh-my-zsh theme)
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '

ZSHRC
fi

# Create helpful scripts directory
mkdir -p ~/scripts

# Create system status script
cat > ~/scripts/status.sh << 'STATUS'
#!/bin/bash
# MacBook System Status

echo "MacBook Status"
echo "=============="
echo ""

echo "System:"
echo "  Model: $(sysctl -n hw.model)"
echo "  CPU: $(sysctl -n machdep.cpu.brand_string)"
echo "  Memory: $(sysctl -n hw.memsize | awk '{print $1/1024/1024/1024 " GB"}')"
echo ""

echo "Battery:"
pmset -g batt | grep -Eo "[0-9]+%" | head -1
echo ""

echo "Python Environments:"
if command -v pyenv &> /dev/null; then
    pyenv versions
else
    echo "  pyenv not installed"
fi
echo ""

echo "Network:"
echo "  Local IP: $(ipconfig getifaddr en0 2>/dev/null || echo 'Not connected')"
echo "  Public IP: $(curl -s ifconfig.me)"
echo ""

echo "Disk Usage:"
df -h / | tail -1 | awk '{print "  Used: " $3 " / " $2 " (" $5 ")"}'
echo ""

echo "Services:"
echo "  Docker: $(docker info > /dev/null 2>&1 && echo 'Running' || echo 'Stopped')"
if brew services list | grep syncthing | grep started > /dev/null; then
    echo "  Syncthing: Running (http://localhost:8384)"
else
    echo "  Syncthing: Stopped"
fi
STATUS

chmod +x ~/scripts/status.sh

# Create project initialization script
cat > ~/scripts/new-project.sh << 'NEWPROJ'
#!/bin/bash
# Quick project initialization

if [ -z "$1" ]; then
    echo "Usage: new-project.sh project-name"
    exit 1
fi

PROJECT_NAME=$1
PROJECT_DIR=~/projects/$PROJECT_NAME

echo "Creating new project: $PROJECT_NAME"

mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# Initialize git
git init
git branch -M main

# Create .gitignore
cat > .gitignore << 'GITIGNORE'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
venv/
env/
.venv
.env

# Jupyter
.ipynb_checkpoints/
*.ipynb_checkpoints

# IDE
.vscode/
.idea/

# macOS
.DS_Store

# Project specific
data/
*.csv
*.xlsx
*.db
*.sqlite

# Secrets
.env.local
secrets/
GITIGNORE

# Create README
cat > README.md << README
# $PROJECT_NAME

## Description

[Add project description]

## Setup

\`\`\`bash
# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
\`\`\`

## Usage

[Add usage instructions]
README

# Create requirements.txt
touch requirements.txt

echo ""
echo "Project created at: $PROJECT_DIR"
echo ""
echo "Next steps:"
echo "  cd $PROJECT_DIR"
echo "  Create virtual environment: python3 -m venv venv"
echo "  Activate: source venv/bin/activate"
echo "  Install packages: pip install <package-name>"
echo "  Save packages: pip freeze > requirements.txt"
NEWPROJ

chmod +x ~/scripts/new-project.sh

echo "MacBook configured successfully"
echo ""
echo "Available commands:"
echo "  ~/scripts/status.sh - System status check"
echo "  ~/scripts/new-project.sh <name> - Create new project"
echo ""
echo "Shell aliases added (restart shell or run: source ~/.zshrc):"
echo "  finance - Activate finance environment"
echo "  jlab - Start Jupyter Lab"
echo "  aws-whoami - Show current AWS identity"
echo "  projects - cd to ~/projects"
echo "  update - Update all Homebrew packages"
