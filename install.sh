#!/bin/bash

# Installation script for Repo Madness

echo "Installing Repo Madness..."

# Make the repo script executable
chmod +x repo_find.sh

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
ALIAS_LINE="alias repo='source /Users/studio/Documents/GitHub/repo_madness/repo_simple.sh'"

if ! grep -q "alias repo=" "$SHELL_PROFILE"; then
    echo "" >> "$SHELL_PROFILE"
    echo "# Repo Madness - Quick access to GitHub repositories" >> "$SHELL_PROFILE"
    echo "$ALIAS_LINE" >> "$SHELL_PROFILE"
    echo "Alias added to $SHELL_PROFILE"
else
    echo "Alias already exists in $SHELL_PROFILE"
    # Update the existing alias to point to the current location
    sed -i.bak "s|alias repo=.*|${ALIAS_LINE//\//\\/}|" "$SHELL_PROFILE"
    echo "Updated existing alias in $SHELL_PROFILE"
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