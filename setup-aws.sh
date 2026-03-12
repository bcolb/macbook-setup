#!/bin/bash
# AWS CLI Configuration Helper
# Guides through AWS account setup and CLI configuration

set -e

echo "AWS CLI Configuration"
echo "====================="
echo ""

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI not found. Run setup-macbook.sh first."
    exit 1
fi

echo "This script will help you configure AWS CLI"
echo ""
echo "You will need:"
echo "  1. AWS Account (personal or company)"
echo "  2. IAM User with programmatic access"
echo "  3. Access Key ID and Secret Access Key"
echo ""
echo "For security, it's recommended to:"
echo "  - Use an IAM user (not root account)"
echo "  - Enable MFA on your AWS account"
echo "  - Use temporary credentials when possible"
echo ""

read -p "Continue with AWS configuration? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Exiting. Run 'aws configure' manually when ready."
    exit 0
fi

echo ""
echo "Running AWS configure..."
echo ""
aws configure

echo ""
echo "Testing AWS connection..."
aws sts get-caller-identity

echo ""
echo "AWS CLI configured successfully"
echo ""
echo "Next steps:"
echo "1. Set up billing alerts:"
echo "   - Login to AWS Console"
echo "   - Navigate to Billing > Billing Preferences"
echo "   - Enable 'Receive Billing Alerts'"
echo "   - Create CloudWatch alarms in us-east-1"
echo ""
echo "2. Enable MFA on your account:"
echo "   - IAM > Users > [Your User] > Security Credentials"
echo "   - Assign MFA device"
echo ""
echo "3. Create additional profiles (optional):"
echo "   aws configure --profile work"
echo "   aws configure --profile personal"
echo ""
echo "4. View your configuration:"
echo "   cat ~/.aws/credentials"
echo "   cat ~/.aws/config"
