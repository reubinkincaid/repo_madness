#!/bin/bash

# Installation script for Repo Madness
# Cross-platform: Works on macOS, Windows (Git Bash/WSL), Linux

echo "Installing Repo Madness..."

# Get the directory where this install script is located
# This works regardless of where the script is run from
SCRIPT_DIR="${BASH_SOURCE[0]}"
[[ "$SCRIPT_DIR" != /* ]] && SCRIPT_DIR="$(cd "${SCRIPT_DIR%/*}" && pwd)"

echo "Found Repo Madness at: $SCRIPT_DIR"

# Make the main script executable (silently ignore errors on Windows)
chmod +x "$SCRIPT_DIR/repo.sh" 2>/dev/null || true

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
    echo "Creating $HOME/.bashrc for you..."
    touch "$HOME/.bashrc"
    SHELL_PROFILE="$HOME/.bashrc"
fi

echo "Found shell profile: $SHELL_PROFILE"

# Add the repo function to the shell profile
# Using a function instead of alias for better compatibility with tools like direnv
FUNCTION_LINE="repo() { source \"$SCRIPT_DIR/repo.sh\"; source ~/.zshrc 2>/dev/null || true; }"

# Check if repo function already exists
REPO_FUNCTION_EXISTS=false
if grep -q "repo()" "$SHELL_PROFILE" 2>/dev/null; then
    REPO_FUNCTION_EXISTS=true
fi

if [[ "$REPO_FUNCTION_EXISTS" == false ]]; then
    echo "" >> "$SHELL_PROFILE"
    echo "# Repo Madness - Quick access to GitHub repositories" >> "$SHELL_PROFILE"
    echo "$FUNCTION_LINE" >> "$SHELL_PROFILE"
    echo "Function added to $SHELL_PROFILE"
else
    echo "Repo function already exists in $SHELL_PROFILE"
    echo "If you want to update the path, manually edit: $SHELL_PROFILE"
fi

# Check if user wants to set a custom repository path
echo ""
echo "Would you like to set a custom repository folder location?"
echo "Press Enter to use the default (auto-detect common locations)"
echo "Or enter a custom path (e.g., /Users/you/Code or C:/Users/you/Code)"
echo "Custom path (leave empty for auto-detect): "
read custom_path

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
echo "  • Lists all directories in your GitHub folder"
echo "  • Navigate to any directory easily"
echo "  • Supports filtering by name"
echo "  • Works on macOS, Windows (Git Bash/WSL), and Linux"
echo "  • Uninstall script included for easy removal"
echo "  • Compatible with direnv and other shell tools"
