#!/bin/bash

# Installation script for Repo Madness
# This script automatically detects the installation directory and sets up the alias

echo "Installing Repo Madness..."

# Get the directory where this install script is located
# This works regardless of where the script is run from
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Found Repo Madness at: $SCRIPT_DIR"

# Make the main script executable
chmod +x "$SCRIPT_DIR/repo_simple.sh"

# Determine the shell profile file to modify
SHELL_PROFILE=""
if [[ -f "$HOME/.zshrc" ]]; then
    SHELL_PROFILE="$HOME/.zshrc"
elif [[ -f "$HOME/.bash_profile" ]]; then
    SHELL_PROFILE="$HOME/.bash_profile"
elif [[ -f "$HOME/.bashrc" ]]; then
    SHELL_PROFILE="$HOME/.bashrc"
elif [[ -f "$HOME/.profile" ]]; then
    SHELL_PROFILE="$HOME/.profile"
else
    echo "Could not find a shell profile file."
    exit 1
fi

echo "Found shell profile: $SHELL_PROFILE"

# Add the alias to the shell profile if it doesn't already exist
ALIAS_LINE="alias repo='source \"$SCRIPT_DIR/repo_simple.sh\"'"

if ! grep -q "alias repo=" "$SHELL_PROFILE"; then
    echo "" >> "$SHELL_PROFILE"
    echo "# Repo Madness - Quick access to GitHub repositories" >> "$SHELL_PROFILE"
    echo "$ALIAS_LINE" >> "$SHELL_PROFILE"
    echo "Alias added to $SHELL_PROFILE"
else
    echo "Alias already exists in $SHELL_PROFILE"
    # Update the existing alias to point to the current location
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS requires -i.bak for sed
        sed -i.bak "s|alias repo=.*|${ALIAS_LINE//\\//\\\\/}|" "$SHELL_PROFILE"
    else
        # Linux can use -i without backup
        sed -i "s|alias repo=.*|${ALIAS_LINE//\\//\\\\/}|" "$SHELL_PROFILE"
    fi
    echo "Updated existing alias in $SHELL_PROFILE"
fi

# Check if user wants to set a custom repository path
echo ""
echo "Would you like to set a custom repository folder location?"
echo "Press Enter to use the default (auto-detect common locations)"
echo "Or enter a custom path (e.g., /Users/you/Code)"
read -p "Custom path (leave empty for auto-detect): " custom_path

if [[ -n "$custom_path" ]]; then
    # Add export to shell profile
    echo "" >> "$SHELL_PROFILE"
    echo "# Repo Madness custom path" >> "$SHELL_PROFILE"
    echo "export REPO_MADNESS_PATH=\"$custom_path\"" >> "$SHELL_PROFILE"
    echo "Custom path added to $SHELL_PROFILE"
fi

echo ""
echo "Installation complete!"
echo ""
echo "To start using the 'repo' command, either:"
echo "  1. Restart your terminal, OR"
echo "  2. Run: source $SHELL_PROFILE"
echo ""
echo "Then you can use 'repo' from any directory to navigate to your GitHub repositories."
echo ""
echo "Features:"
echo "  • Lists all directories in ~/Documents/GitHub"
echo "  • Navigate to any directory easily"
echo "  • Supports filtering by name"
