#!/bin/bash

# Uninstallation script for Repo Madness
# Removes the repo function from your shell profile

echo "Uninstalling Repo Madness..."

# Find which shell profile contains the repo function
SHELL_PROFILE=""
PROFILES_TO_CHECK=("$HOME/.zshrc" "$HOME/.bash_profile" "$HOME/.bashrc" "$HOME/.profile")

for profile in "${PROFILES_TO_CHECK[@]}"; do
    if [[ -f "$profile" ]]; then
        while IFS= read -r line; do
            case "$line" in
                *repo\\(\\)*) SHELL_PROFILE="$profile"; break 2 ;;
            esac
        done < "$profile" 2>/dev/null || true
    fi
done

if [[ -z "$SHELL_PROFILE" ]]; then
    echo "Could not find Repo Madness function in any shell profile."
    echo "It may have already been removed or was never installed."
    SHELL_PROFILE="$HOME/.zshrc"  # Default for instructions
else
    echo "Found repo function in: $SHELL_PROFILE"

    # Remove lines by reading and rewriting the file
    removed_function=false
    removed_path=false
    new_content=""

    while IFS= read -r line; do
        case "$line" in
            *repo\\(\\)*)
                removed_function=true
                ;;
            *REPO_MADNESS_PATH*)
                removed_path=true
                ;;
            *Repo Madness*)
                # Skip the comment line too
                ;;
            *)
                new_content="${new_content}${line}"$'\\n'
                ;;
        esac
    done < "$SHELL_PROFILE" 2>/dev/null

    # Write the filtered content back to the file
    if [[ -n "$new_content" ]]; then
        printf "%s" "$new_content" > "$SHELL_PROFILE"
    fi

    if [[ "$removed_function" == true ]]; then
        echo "Removed repo function from $SHELL_PROFILE"
    fi
    if [[ "$removed_path" == true ]]; then
        echo "Removed custom path configuration."
    fi
fi

# Get the script directory
SCRIPT_DIR="${BASH_SOURCE[0]}"
[[ "$SCRIPT_DIR" != /* ]] && SCRIPT_DIR="$(cd "${SCRIPT_DIR%/*}" && pwd)"

# Ask if user wants to delete the repo folder
echo ""
echo "Would you like to delete the Repo Madness folder?"
echo "Current location: $SCRIPT_DIR"
echo "Delete folder? (y/N): "
read delete_folder

if [[ "$delete_folder" =~ ^[Yy]$ ]]; then
    echo "To delete the folder, please run this command manually:"
    echo "  rm -rf \"$SCRIPT_DIR\""
    echo ""
    echo "Or manually delete the folder using your file manager."
fi

echo ""
echo "Uninstallation complete!"
echo ""
echo "To finish the uninstallation, either:"
echo "  1. Restart your terminal, OR"
echo "  2. Run: source $SHELL_PROFILE"
echo ""
echo "The 'repo' command will no longer be available."
