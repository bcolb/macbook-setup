# MacBook Setup Scripts

Automated setup scripts for configuring a MacBook (Neo, Air, or Pro) for development, financial analysis, and cloud computing.

## Overview

This repository contains scripts to set up a MacBook with:

- Development tools (Git, pyenv, VS Code, iTerm2, Claude Code)
- Financial analysis environment (Python, QuantLib, OpenBB, pandas-ta)
- AWS CLI and cloud tools
- Database clients (TablePlus, NoSQL Workbench, SQLite)
- Optional AI models via Ollama (optimized for MacBook Air)
- System optimizations for portable development

## Prerequisites

- MacBook (Neo, Air, or Pro) with macOS 14+ (Sonoma or later)
- Fresh macOS installation or existing setup
- Internet connection
- Admin access

> **Note:** All scripts are safe to re-run. Shell configuration blocks (pyenv, brew, aliases) are written to dotfiles idempotently — they check whether the config already exists before appending, so running a script multiple times will not create duplicate entries.

## Quick Start

```bash
# Clone this repository
git clone https://github.com/bcolb/macbook-setup.git
cd macbook-setup

# Run the main setup script
bash setup-macbook.sh

# Restart your shell
exec zsh

# Set up finance environment
bash setup-finance-env.sh

# Configure AWS CLI (optional)
bash setup-aws.sh

# Install VS Code extensions
bash install-vscode-extensions.sh

# Apply MacBook optimizations
bash configure-macbook.sh

# Set up AI Models (Ollama) for AI (optional)
bash setup-ai-models-macbook.sh
```

## Scripts

### setup-macbook.sh

Main setup script that installs:

**CLI Tools:**
- Xcode Command Line Tools
- Homebrew package manager
- git, wget, curl, jq, ripgrep, fd, bat, htop, btop, tree, tldr
- GitHub CLI (gh)

**GUI Applications:**
- iTerm2 - Terminal emulator
- Visual Studio Code - Code editor
- Docker Desktop - Container platform
- Rectangle - Window management
- Stats - System monitor
- Claude - AI assistant
- TablePlus - Database GUI
- NoSQL Workbench - DynamoDB GUI

**Development Environment:**
- Oh My Zsh with agnoster theme
- Python 3.14.3 and 3.13.1 via pyenv
- AWS CLI
- Claude Code (via Homebrew)
- Syncthing for file sync
- SQLite database

**System Configuration:**
- Show hidden files in Finder
- Disable auto-correct
- Faster key repeat
- Git configuration with aliases
- SSH key generation

**Time:** 30-45 minutes

### setup-finance-env.sh

Creates Python virtual environment for financial analysis:

**Packages:**
- Core: numpy, pandas, matplotlib, seaborn, plotly
- Statistics: scipy, scikit-learn, statsmodels
- Finance: yfinance, pandas-ta, QuantLib, OpenBB
- Database: boto3, sqlalchemy, psycopg2
- Jupyter: jupyterlab, ipywidgets
- Utilities: requests, beautifulsoup4, python-dotenv

**Time:** 10-15 minutes

### setup-aws.sh

Interactive AWS CLI configuration helper:

- Guides through AWS account setup
- Configures credentials and default region
- Tests connection with `aws sts get-caller-identity`
- Provides next steps for billing alerts and MFA

**Time:** 5 minutes

### install-vscode-extensions.sh

Installs recommended VS Code extensions:

- Python development (ms-python.python, Pylance)
- Claude Code (anthropic.claude-code)
- Git (GitLens, GitHub Copilot)
- Data formats (CSV, Markdown)
- Docker, AWS Toolkit
- Utilities (Prettier, ESLint, spell checker)

**Time:** 3-5 minutes

### configure-macbook.sh

Applies MacBook-specific optimizations:

- Shell aliases for common tasks
- System status script (`~/scripts/status.sh`)
- Project initialization script (`~/scripts/new-project.sh`)
- Python and development shortcuts

**Time:** 2 minutes

### setup-ai-models-macbook.sh

Configures Ollama for MacBook Air with three strategies:

1. **Remote Only** - Use Mac Mini for all AI (recommended for battery)
2. **Lightweight Local** - Install llama3.2:3b for offline use (2GB)
3. **Hybrid** - Remote by default, local fallback when offline

**Features:**
- Interactive setup wizard
- Automatic remote server detection
- Shell aliases for easy switching
- Storage and battery optimized

**Time:** 3-10 minutes (depending on model downloads)

## Post-Setup Configuration

### Activate Finance Environment

```bash
# Activate environment
pyenv activate finance-env

# Or use alias
finance

# Start Jupyter Lab
jupyter lab
```

### Configure AWS

```bash
# Run interactive setup
bash setup-aws.sh

# Or configure manually
aws configure

# Test connection
aws sts get-caller-identity
```

### Set Up Billing Alerts

1. Login to AWS Console
2. Navigate to **Billing > Billing Preferences**
3. Enable "Receive Billing Alerts"
4. Go to CloudWatch in **us-east-1** region
5. Create alarms at $5, $10, $50 thresholds
6. Set up SNS topic with email notification

### Configure Syncthing

1. Open Syncthing UI: http://localhost:8384
2. Add other devices (Mac Mini, other MacBooks)
3. Share folders: `~/projects`, `~/Documents`
4. Configure ignore patterns for large files

### Connect to Mac Mini (if you have one)

Add to `~/.ssh/config`:

```bash
Host macmini
    HostName 192.168.1.XXX  # Replace with Mac Mini IP
    User yourusername
    IdentityFile ~/.ssh/id_ed25519
```

Connect:
```bash
ssh macmini
```

## Installed Tools

### CLI Tools

| Tool | Purpose |
|------|---------|
| git | Version control |
| pyenv | Python version management |
| gh | GitHub CLI |
| ripgrep | Fast text search |
| fd | Fast file finder |
| bat | Cat with syntax highlighting |
| htop/btop | System monitoring |
| tree | Directory visualization |
| tldr | Simplified man pages |
| awscli | AWS command line interface |

### GUI Applications

| Application | Purpose |
|-------------|---------|
| iTerm2 | Advanced terminal |
| VS Code | Code editor |
| Docker Desktop | Container platform |
| Rectangle | Window management |
| Stats | Menu bar system monitor |
| Claude | AI assistant |
| TablePlus | Database client |
| NoSQL Workbench | DynamoDB client |

### Python Packages (finance-env)

| Package | Purpose |
|---------|---------|
| yfinance | Download market data from Yahoo Finance |
| pandas-ta | Technical analysis indicators |
| QuantLib | Quantitative finance library |
| OpenBB | Open source investment research |
| plotly | Interactive visualizations |
| jupyter | Interactive notebooks |

## Shell Aliases

After running `configure-macbook.sh`, these aliases are available:

```bash
# Python environments
finance              # Activate finance-env
jlab                 # Start Jupyter Lab

# Git shortcuts
gs                   # git status
gp                   # git pull
gpu                  # git push
gd                   # git diff

# AWS
aws-whoami           # Show current AWS identity

# Navigation
projects             # cd ~/projects
work                 # cd ~/Documents/work

# System
update               # Update all Homebrew packages
cleanup              # Clean Homebrew cache
myip                 # Show public IP address
ports                # Show listening ports

# Python virtual environments
venv-create          # Create new venv
venv-activate        # Activate venv in current directory
```

## Ollama AI Models (Optional)

The `setup-ai-models-macbook.sh` script provides three strategies optimized for MacBook Air:

### Strategy 1: Remote Only (Recommended)

Use your Mac Mini or other server for all AI workloads:

```bash
bash setup-ai-models-macbook.sh
# Choose option 1
# Enter Mac Mini IP address

# Usage
ollama run qwen2.5:14b "explain this code"
ollama run qwen2.5-coder:7b "write a Python script"
```

**Pros:**
- No local storage used (0 GB)
- Minimal battery impact
- Access to powerful models
- MacBook stays fast

**Cons:**
- Requires network connection
- Depends on Mac Mini being on

### Strategy 2: Lightweight Local (Offline Use)

Install one small model for offline work:

```bash
bash setup-ai-models-macbook.sh
# Choose option 2

# Usage
ollama run llama3.2:3b "quick question"
```

**Pros:**
- Works offline (airplane, coffee shop)
- Small footprint (2GB)
- Fast responses

**Cons:**
- Lower quality than larger models
- Battery drain when active
- Limited capabilities

### Strategy 3: Hybrid (Best of Both)

Remote by default, local fallback:

```bash
bash setup-ai-models-macbook.sh
# Choose option 3

# Default: uses Mac Mini
ollama run qwen2.5:14b "complex task"

# Switch to local when offline
ollama-local
ollama run llama3.2:3b "simple task"

# Back to remote
ollama-remote
```

**Pros:**
- Flexibility for all situations
- Best performance when on network
- Fallback when offline

**Cons:**
- Uses 2GB storage for local model
- Requires initial setup of both

### Recommended Model by Use Case

| Use Case | Model | Location |
|----------|-------|----------|
| Complex code generation | qwen2.5-coder:7b | Mac Mini |
| Code explanation | qwen2.5:14b | Mac Mini |
| Quick questions | llama3.2:3b | Local (if offline) |
| Learning/experimentation | Various | Mac Mini |
| Offline work | llama3.2:3b | Local |
| Battery preservation | Any | Mac Mini (remote) |

### Battery Impact

| Configuration | Battery Drain |
|---------------|---------------|
| No Ollama | Baseline |
| Remote (Mac Mini) | +2-3% per hour |
| Local llama3.2:3b (active) | +15-25% per hour |
| Local qwen2.5:7b (active) | +30-40% per hour |

## Helpful Scripts

### System Status

```bash
~/scripts/status.sh
```

Shows:
- System information (model, CPU, memory)
- Battery status
- Python environments
- Network (local and public IP)
- Disk usage
- Running services

### New Project

```bash
~/scripts/new-project.sh my-project-name
```

Creates:
- Project directory in `~/projects/`
- Git repository with main branch
- `.gitignore` for Python projects
- `README.md` template
- Empty `requirements.txt`

## Directory Structure

```
~/projects/           # Your development projects
~/Documents/work/     # Work-related documents
~/scripts/            # Utility scripts
~/.pyenv/             # Python versions and environments
~/.aws/               # AWS credentials and config
~/.config/            # Application configurations
```

## Customization

### Change Python Versions

Edit `setup-macbook.sh` lines 88-90:

```bash
pyenv install 3.X.X
pyenv global 3.X.X
```

### Add Homebrew Packages

Edit `setup-macbook.sh` lines 40-52 (CLI) or 57-63 (GUI).

### Modify Finance Packages

Edit `setup-finance-env.sh` lines 30-58.

### Add VS Code Extensions

Edit `install-vscode-extensions.sh` and add:

```bash
code --install-extension publisher.extension-name
```

## Maintenance

### Update Homebrew Packages

```bash
brew update
brew upgrade
brew cleanup

# Or use alias
update
```

### Update Python Packages

```bash
pyenv activate finance-env
pip list --outdated
pip install --upgrade package-name

# Or upgrade all
pip list --outdated --format=freeze | cut -d = -f 1 | xargs -n1 pip install -U
```

### Update VS Code Extensions

Open VS Code:
- Command Palette (Cmd+Shift+P)
- "Extensions: Check for Updates"

### Backup Your Environment

```bash
# Export Python packages
pyenv activate finance-env
pip freeze > requirements-$(date +%Y%m%d).txt

# Export Homebrew packages
brew bundle dump --file=Brewfile-$(date +%Y%m%d)

# Backup AWS config
cp -r ~/.aws ~/.aws-backup-$(date +%Y%m%d)
```

## Multi-Device Setup

If you have multiple Macs (MacBook Air + Mac Mini, etc.):

### Role Definition

| Device | Role | Python Env |
|--------|------|------------|
| MacBook Air | Portable dev | finance-env |
| MacBook Pro | Heavy dev | finance-env |
| Mac Mini | AI/server | ai-env |

### Sync Strategy

**Git:** All code projects
**Syncthing:** Documents, project files
**iCloud:** Selective (Keychain, Find My only)
**Exclude:** `node_modules/`, `.venv/`, `__pycache__/`, `.DS_Store`

## Troubleshooting

### pyenv: command not found

**Solution:** Restart your shell or run:
```bash
source ~/.zprofile
exec zsh
```

### VS Code 'code' command not found

**Solution:**
1. Open VS Code
2. Command Palette (Cmd+Shift+P)
3. "Shell Command: Install 'code' command in PATH"

### AWS CLI not configured

**Solution:**
```bash
bash setup-aws.sh
# Or manually:
aws configure
```

### Homebrew installation fails

**Solution:**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Python package installation fails

**Solution:**
```bash
# Ensure you're in the correct environment
pyenv activate finance-env
which python  # Should show .pyenv path

# Update pip
pip install --upgrade pip

# Try installing individually
pip install package-name
```

### Docker won't start

**Solution:**
1. Open Docker Desktop manually
2. Accept license agreement
3. Grant permissions in System Settings

### Syncthing not accessible

**Solution:**
```bash
# Check if running
brew services list | grep syncthing

# Restart if needed
brew services restart syncthing

# Access UI
open http://localhost:8384
```

## Related Projects

- [mac-mini-setup](https://github.com/bcolb/mac-mini-setup) - Mac Mini AI server setup
- [heartbeat-client](https://github.com/bcolb/heartbeat-client) - Device monitoring agent
- [heartbeat-monitor-infra](https://github.com/bcolb/heartbeat-monitor-infra) - AWS monitoring infrastructure

## Best Practices

### Security

- Enable FileVault disk encryption
- Use strong passwords and Touch ID
- Enable Find My Mac
- Set up Time Machine backups
- Use SSH keys (not passwords) for Git
- Enable MFA on AWS account
- Don't commit secrets to Git (use .env files)

### Development

- Create virtual environments for each project
- Use `requirements.txt` or `pyproject.toml`
- Commit early and often
- Write meaningful commit messages
- Use branches for features
- Keep dependencies up to date

### Organization

- Use consistent project structure
- Document your projects
- Clean up old projects regularly
- Back up important data
- Use Syncthing for seamless multi-device work

## License

MIT

## Author

Brice Colbert

---

For more information or issues, please open an issue on GitHub.
