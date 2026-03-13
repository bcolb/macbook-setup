#!/bin/bash
# Ollama Setup for MacBook
# Configures AI models optimized for portable use
# Run: bash setup-ai-models-macbook.sh

set -e

echo "Ollama Setup for MacBook"
echo "============================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if Ollama is installed
if ! command -v ollama &> /dev/null; then
    echo -e "${YELLOW}Ollama not found. Installing...${NC}"
    brew install ollama
    brew services start ollama
    echo "Waiting for Ollama to start..."
    sleep 5
else
    echo -e "${GREEN}Ollama already installed${NC}"
    # Ensure it's running
    if ! brew services list | grep ollama | grep started > /dev/null; then
        brew services start ollama
        sleep 5
    fi
fi

echo ""
echo "MacBook AI Strategy"
echo "======================="
echo ""
echo "You have three options:"
echo ""
echo "1. REMOTE ONLY (Recommended for battery life)"
echo "   - Use Mac Mini or other server for AI"
echo "   - No models on MacBook"
echo "   - Minimal storage and RAM usage"
echo "   - Requires network connection"
echo ""
echo "2. LIGHTWEIGHT LOCAL (Recommended for offline use)"
echo "   - Install one small model (llama3.2:3b - 2GB)"
echo "   - Works offline"
echo "   - Moderate battery impact"
echo "   - Good for basic tasks"
echo ""
echo "3. HYBRID (Best of both worlds)"
echo "   - Use remote by default"
echo "   - Fall back to local when offline"
echo "   - Requires setup of both"
echo ""

read -p "Choose strategy (1/2/3): " strategy

case $strategy in
    1)
        echo ""
        echo -e "${GREEN}Setting up REMOTE ONLY configuration${NC}"
        echo ""
        read -p "Enter your Mac Mini IP address (e.g., 192.168.1.100): " macmini_ip
        
        # Validate IP format (basic)
        if [[ ! $macmini_ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
            echo -e "${RED}Invalid IP address format${NC}"
            exit 1
        fi
        
        # Add to shell config
        if ! grep -q "OLLAMA_HOST" ~/.zshrc 2>/dev/null; then
            cat >> ~/.zshrc << EOF

# Ollama remote configuration (Mac Mini)
export OLLAMA_HOST="http://$macmini_ip:11434"
EOF
            echo -e "${GREEN}Remote configuration added to ~/.zshrc${NC}"
        else
            echo -e "${YELLOW}OLLAMA_HOST already configured in ~/.zshrc${NC}"
        fi
        
        # Load the config
        export OLLAMA_HOST="http://$macmini_ip:11434"
        
        echo ""
        echo "Testing connection to Mac Mini..."
        if curl -s "http://$macmini_ip:11434/api/tags" > /dev/null 2>&1; then
            echo -e "${GREEN}Successfully connected to Mac Mini!${NC}"
            echo ""
            echo "Available models on Mac Mini:"
            ollama list || echo "Could not list models"
        else
            echo -e "${RED}Could not connect to Mac Mini at $macmini_ip${NC}"
            echo "Make sure:"
            echo "  1. Mac Mini is on and running Ollama"
            echo "  2. Both devices are on the same network"
            echo "  3. Mac Mini Ollama is configured to accept remote connections"
            echo ""
            echo "On Mac Mini, run:"
            echo "  export OLLAMA_HOST=0.0.0.0:11434"
            echo "  brew services restart ollama"
        fi
        
        echo ""
        echo -e "${GREEN}Setup complete!${NC}"
        echo ""
        echo "Usage:"
        echo "  ollama run qwen2.5:14b 'your prompt'"
        echo ""
        echo "To use local Ollama (if needed):"
        echo "  OLLAMA_HOST=\"\" ollama list"
        ;;
        
    2)
        echo ""
        echo -e "${GREEN}Setting up LIGHTWEIGHT LOCAL configuration${NC}"
        echo ""
        echo "This will download llama3.2:3b (2GB)"
        echo "Estimated time: 3-5 minutes"
        echo ""
        read -p "Continue? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Cancelled"
            exit 0
        fi
        
        echo ""
        echo "Downloading llama3.2:3b..."
        ollama pull llama3.2:3b
        
        echo ""
        echo -e "${GREEN}Model installed successfully!${NC}"
        echo ""
        echo "Test with:"
        echo "  ollama run llama3.2:3b"
        echo ""
        echo "Example prompts:"
        echo "  ollama run llama3.2:3b 'explain Python decorators'"
        echo "  ollama run llama3.2:3b 'write a bash script to backup files'"
        ;;
        
    3)
        echo ""
        echo -e "${GREEN}Setting up HYBRID configuration${NC}"
        echo ""
        
        # Remote setup
        read -p "Enter your Mac Mini IP address: " macmini_ip
        
        if [[ ! $macmini_ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
            echo -e "${RED}Invalid IP address format${NC}"
            exit 1
        fi
        
        # Add remote config with instructions for local override
        if ! grep -q "OLLAMA_HOST" ~/.zshrc 2>/dev/null; then
            cat >> ~/.zshrc << EOF

# Ollama hybrid configuration
# Default: Use Mac Mini (remote)
export OLLAMA_HOST="http://$macmini_ip:11434"

# Aliases for easy switching
alias ollama-remote='export OLLAMA_HOST="http://$macmini_ip:11434"'
alias ollama-local='export OLLAMA_HOST=""'
EOF
            echo -e "${GREEN}Hybrid configuration added to ~/.zshrc${NC}"
        fi
        
        export OLLAMA_HOST="http://$macmini_ip:11434"
        
        echo ""
        echo "Testing remote connection..."
        if curl -s "http://$macmini_ip:11434/api/tags" > /dev/null 2>&1; then
            echo -e "${GREEN}Mac Mini connected successfully${NC}"
        else
            echo -e "${YELLOW}Could not connect to Mac Mini (will continue with local setup)${NC}"
        fi
        
        # Local model setup
        echo ""
        echo "Now installing local fallback model (llama3.2:3b - 2GB)..."
        echo "This will be used when Mac Mini is unavailable"
        echo ""
        read -p "Continue? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Temporarily use local Ollama for download
            OLLAMA_HOST="" ollama pull llama3.2:3b
            echo -e "${GREEN}Local model installed${NC}"
        fi
        
        echo ""
        echo -e "${GREEN}Hybrid setup complete!${NC}"
        echo ""
        echo "Usage:"
        echo "  Default (remote): ollama run qwen2.5:14b 'prompt'"
        echo "  Force local: ollama-local && ollama run llama3.2:3b 'prompt'"
        echo "  Back to remote: ollama-remote"
        echo ""
        echo "The system will use Mac Mini by default."
        echo "Switch to local when offline or for battery saving."
        ;;
        
    *)
        echo -e "${RED}Invalid option${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}Configuration Summary${NC}"
echo "===================="
echo ""

# Show what's installed locally
echo "Local models:"
OLLAMA_HOST="" ollama list 2>/dev/null || echo "  None installed"

echo ""

# Show remote configuration
if grep -q "OLLAMA_HOST" ~/.zshrc 2>/dev/null; then
    echo "Remote server:"
    grep "OLLAMA_HOST" ~/.zshrc | grep -v "^#" | head -1
    echo ""
fi

# Calculate storage used
if [ -d ~/.ollama/models ]; then
    storage=$(du -sh ~/.ollama/models 2>/dev/null | cut -f1)
    echo "Storage used: $storage"
else
    echo "Storage used: 0 (no local models)"
fi

echo ""
echo "Next steps:"
echo "  1. Restart your shell: exec zsh"
echo "  2. Test connection: ollama list"
if [ "$strategy" = "3" ] || [ "$strategy" = "2" ]; then
    echo "  3. Try local model: ollama run llama3.2:3b 'Hello'"
fi
if [ "$strategy" = "1" ] || [ "$strategy" = "3" ]; then
    echo "  3. Try remote model: ollama run qwen2.5:14b 'Hello'"
fi
echo ""
