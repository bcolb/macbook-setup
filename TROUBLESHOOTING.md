# Troubleshooting

Common issues and solutions for MacBook setup scripts.

## Installation Issues

### pyenv: command not found

**Problem:** Running `setup-finance-env.sh` shows "pyenv: command not found"

**Cause:** pyenv configuration wasn't loaded in current shell session

**Solutions:**

1. Restart your shell (recommended)
   ```bash
   exec zsh
   ```

2. Load pyenv manually
   ```bash
   source ~/.zprofile
   ```

3. Open a new Terminal window/tab
   - Command+T for new tab
   - Command+N for new window

Then run the script again:
```bash
bash setup-finance-env.sh
```

### Homebrew installation hangs

**Problem:** Homebrew installation seems stuck

**Solutions:**

1. Press Return - Installation may be waiting for input
2. Check internet connection
3. Try manual installation
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

### Xcode Command Line Tools prompt

**Problem:** Popup appears asking to install Xcode Command Line Tools

**Solution:** Click "Install" and wait for completion before continuing with the script.

### Permission denied errors

**Problem:** "Permission denied" during setup

**Cause:** Some operations require admin privileges

**Solution:** The script will prompt for your password when needed. Enter it when prompted.

## Python Issues

### Python package installation fails

**Problem:** pip install fails for certain packages

**Solutions:**

1. Verify you're in the finance-env
   ```bash
   pyenv activate finance-env
   which python
   # Should show: /Users/yourname/.pyenv/versions/finance-env/bin/python
   ```

2. Update pip
   ```bash
   pip install --upgrade pip
   ```

3. Install packages individually
   ```bash
   pip install pandas
   pip install yfinance
   # etc.
   ```

### QuantLib installation fails

**Problem:** QuantLib fails to compile

**Solution:** Install dependencies first:
```bash
brew install boost
pip install --upgrade pip setuptools wheel
pip install QuantLib
```

### Virtual environment activation doesn't work

**Problem:** `pyenv activate finance-env` doesn't work

**Solutions:**

1. Ensure pyenv-virtualenv is installed
   ```bash
   brew install pyenv-virtualenv
   ```

2. Reload shell configuration
   ```bash
   source ~/.zprofile
   ```

3. Check if environment exists
   ```bash
   pyenv virtualenvs
   ```

## VS Code Issues

### 'code' command not found

**Problem:** Running `code` in terminal shows command not found

**Solution:**
1. Open VS Code
2. Command Palette (Cmd+Shift+P)
3. Type: "Shell Command: Install 'code' command in PATH"
4. Select and confirm

### Extensions won't install

**Problem:** VS Code extensions fail to install

**Solutions:**

1. Ensure VS Code is fully installed and running
2. Check internet connection
3. Install extensions manually through VS Code UI
4. Try running script again:
   ```bash
   bash install-vscode-extensions.sh
   ```

### Claude Code extension not working

**Problem:** Claude Code extension installed but not functioning

**Solutions:**

1. Verify Claude Code CLI is installed
   ```bash
   which claude-code
   # Should show: /opt/homebrew/bin/claude-code
   ```

2. Authenticate Claude Code
   ```bash
   claude-code auth
   ```

3. Check subscription (requires Claude Pro or Max)

## AWS Issues

### AWS CLI not configured

**Problem:** AWS commands fail with "Unable to locate credentials"

**Solution:**
```bash
# Run setup script
bash setup-aws.sh

# Or configure manually
aws configure
```

### AWS credentials invalid

**Problem:** AWS commands fail with "Invalid credentials"

**Solutions:**

1. Verify credentials are correct
   ```bash
   cat ~/.aws/credentials
   ```

2. Reconfigure AWS CLI
   ```bash
   aws configure
   ```

3. Test with simple command
   ```bash
   aws sts get-caller-identity
   ```

### Cannot create billing alarms

**Problem:** CloudWatch alarms can't be created

**Cause:** Must be in us-east-1 region for billing metrics

**Solution:**
1. Switch to us-east-1 in AWS Console
2. Create CloudWatch alarms there
3. Or use CLI:
   ```bash
   aws cloudwatch put-metric-alarm --region us-east-1 ...
   ```

## Application Issues

### Docker Desktop won't start

**Problem:** Docker fails to start after installation

**Solutions:**

1. Open Docker Desktop manually
   - Applications > Docker
   - Accept license agreement if prompted

2. Grant necessary permissions
   - System Settings > Privacy & Security
   - Allow Docker extensions if prompted

3. Restart Docker
   ```bash
   killall Docker && open /Applications/Docker.app
   ```

### Syncthing not accessible

**Problem:** Cannot access Syncthing at localhost:8384

**Solutions:**

1. Check if Syncthing is running
   ```bash
   brew services list | grep syncthing
   ```

2. Start Syncthing if stopped
   ```bash
   brew services start syncthing
   ```

3. Check logs
   ```bash
   tail -f ~/Library/Logs/Homebrew/syncthing.log
   ```

4. Access web UI
   ```bash
   open http://localhost:8384
   ```

### TablePlus connection issues

**Problem:** Cannot connect to database

**Solutions:**

1. For SQLite: Use absolute file path
2. For PostgreSQL/MySQL: Verify server is running
3. Check firewall settings
4. Test connection with CLI first

## Git Issues

### SSH key not accepted by GitHub

**Problem:** Git push fails with authentication error

**Solutions:**

1. Verify SSH key is added to GitHub
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```
   Copy and add to GitHub Settings > SSH Keys

2. Test SSH connection
   ```bash
   ssh -T git@github.com
   ```

3. Ensure ssh-agent is running
   ```bash
   eval "$(ssh-agent -s)"
   ssh-add --apple-use-keychain ~/.ssh/id_ed25519
   ```

### Git push asks for password

**Problem:** Git asks for username/password instead of using SSH

**Cause:** Repository uses HTTPS URL instead of SSH

**Solution:** Change remote URL to SSH
```bash
git remote set-url origin git@github.com:username/repo.git
```

### Git commit fails

**Problem:** "Please tell me who you are" error

**Solution:** Configure Git identity
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## System Issues

### Hidden files not showing in Finder

**Problem:** Finder doesn't show hidden files after setup

**Solution:** Restart Finder
```bash
killall Finder
```

Or toggle manually:
```bash
# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true
killall Finder

# Hide hidden files
defaults write com.apple.finder AppleShowAllFiles -bool false
killall Finder
```

### Key repeat rate not changed

**Problem:** Key repeat settings didn't apply

**Solution:** Log out and log back in, or run:
```bash
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
```

### Scripts not executable

**Problem:** "Permission denied" when running scripts

**Solution:** Make scripts executable
```bash
chmod +x setup-macbook.sh
chmod +x setup-finance-env.sh
chmod +x setup-aws.sh
chmod +x install-vscode-extensions.sh
chmod +x configure-macbook.sh
```

## Network Issues

### Cannot connect to Mac Mini via SSH

**Problem:** SSH connection refused from MacBook to Mac Mini

**Solutions:**

1. Verify SSH is enabled on Mac Mini
   - System Settings > General > Sharing > Remote Login

2. Check firewall settings on Mac Mini
   - System Settings > Network > Firewall
   - Ensure SSH is allowed

3. Verify IP address
   ```bash
   # On Mac Mini
   ifconfig en0 | grep "inet " | awk '{print $2}'
   ```

4. Test locally on Mac Mini first
   ```bash
   ssh localhost
   ```

5. Update ~/.ssh/config on MacBook
   ```bash
   Host macmini
       HostName 192.168.1.XXX
       User yourusername
       IdentityFile ~/.ssh/id_ed25519
   ```

### Syncthing devices won't connect

**Problem:** Syncthing can't find other devices

**Solutions:**

1. Verify both devices are on same network
2. Check device IDs are correct
3. Ensure firewalls allow Syncthing (port 22000)
4. Try manual connection with IP address
5. Check Syncthing logs for errors

## Performance Issues

### System running slow after setup

**Problem:** MacBook performance degraded

**Solutions:**

1. Check resource usage
   ```bash
   btop
   # or
   htop
   ```

2. Stop unnecessary services
   ```bash
   brew services list
   brew services stop <service-name>
   ```

3. Disable Docker if not needed
   ```bash
   # Stop Docker Desktop from menu bar
   ```

4. Clean up disk space
   ```bash
   brew cleanup
   ```

### Python packages taking too long to install

**Problem:** pip install is very slow

**Solutions:**

1. Use binary wheels when possible
   ```bash
   pip install --only-binary :all: package-name
   ```

2. Install one package at a time
3. Check internet connection speed
4. Consider using conda for some packages

## Recovery

### Something went wrong, want to start over

**Problem:** Setup partially completed, want to reset

**Solution:** Selective cleanup:

1. Remove Homebrew (nuclear option)
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
   ```

2. Remove pyenv
   ```bash
   rm -rf ~/.pyenv
   ```

3. Remove Oh My Zsh
   ```bash
   uninstall_oh_my_zsh
   ```

4. Clean shell configuration
   ```bash
   # Backup first
   cp ~/.zshrc ~/.zshrc.backup
   cp ~/.zprofile ~/.zprofile.backup
   
   # Edit and remove added sections
   nano ~/.zshrc
   nano ~/.zprofile
   ```

5. Start fresh
   ```bash
   bash setup-macbook.sh
   ```

## Getting More Help

If you're still having issues:

1. Check the main [README.md](README.md) for detailed documentation
2. Review script output for specific error messages
3. Search GitHub issues
4. Create a new issue with:
   - macOS version
   - Script output/error messages
   - Steps to reproduce

## Useful Diagnostic Commands

```bash
# Check macOS version
sw_vers

# Check installed Homebrew packages
brew list

# Check Python versions
pyenv versions

# Check active Python environment
pyenv version
which python

# Check Git configuration
git config --list

# Check AWS configuration
aws configure list
aws sts get-caller-identity

# Check running services
brew services list

# Check disk space
df -h

# Check memory usage
top -l 1 | grep PhysMem

# Check network
ifconfig
ping google.com

# Check processes
ps aux | grep <process-name>
```
