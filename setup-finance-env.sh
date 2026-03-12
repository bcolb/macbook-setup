#!/bin/bash
# Finance Environment Setup for MacBook
# Creates Python virtual environment with financial analysis packages

set -e

echo "Setting up Finance Environment..."

# Ensure pyenv is loaded
if [ -z "$PYENV_ROOT" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# Verify pyenv is available
if ! command -v pyenv &> /dev/null; then
    echo "Error: pyenv not found. Please run setup-macbook.sh first or restart your shell."
    exit 1
fi

echo "Creating finance-env virtualenv..."
pyenv virtualenv 3.13.1 finance-env

# Activate the environment
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv activate finance-env

pip install --upgrade pip

echo "Installing financial analysis packages (this will take 10-15 minutes)..."

# Core data science packages
pip install \
    numpy pandas matplotlib seaborn plotly \
    scipy scikit-learn statsmodels

# Financial data and analysis
pip install \
    yfinance \
    pandas-ta \
    ta-lib \
    QuantLib \
    openbb

# Database and cloud tools
pip install \
    boto3 \
    psutil \
    sqlalchemy \
    psycopg2-binary

# Jupyter for analysis
pip install \
    jupyter \
    jupyterlab \
    ipywidgets

# Additional utilities
pip install \
    requests \
    beautifulsoup4 \
    python-dotenv

echo ""
echo "Finance environment created successfully"
echo ""
echo "To activate:"
echo "  pyenv activate finance-env"
echo ""
echo "To start Jupyter Lab:"
echo "  jupyter lab"
echo ""
echo "Available libraries:"
echo "  - yfinance: Download market data"
echo "  - pandas-ta: Technical analysis indicators"
echo "  - QuantLib: Quantitative finance library"
echo "  - OpenBB: Open source investment research"
echo "  - plotly: Interactive visualizations"
