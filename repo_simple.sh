#!/bin/bash

# Simple Repo Navigator

navigate_to_repo() {
    echo "🚀 Starting Repo Navigator..."

    GITHUB_PATH="$HOME/Documents/GitHub"
    
    # Check if GitHub directory exists
    if [[ ! -d "$GITHUB_PATH" ]]; then
        echo "❌ GitHub directory not found: $GITHUB_PATH"
        return 1
    fi

    # Get all directories in GitHub folder (excluding hidden ones)
    # Using find command to avoid shell globbing issues
    temp_file=$(mktemp)
    find "$GITHUB_PATH" -mindepth 1 -maxdepth 1 -type d -not -path "*/.*" 2>/dev/null | xargs basename -a | sort > "$temp_file"

    dirs=()
    while IFS= read -r dir_name; do
        dirs+=("$dir_name")
    done < "$temp_file"

    rm "$temp_file"

    if [[ ${#dirs[@]} -eq 0 ]]; then
        echo "⚠️  No directories found in $GITHUB_PATH"
        return 1
    fi

    # Display the directories
    echo ""
    echo "=========================================="
    echo "           REPO NAVIGATOR"
    echo "=========================================="
    echo "Available directories:"
    echo "------------------------------------------"

    for i in "${!dirs[@]}"; do
        printf "%2d. %s\n" $((i+1)) "${dirs[$i]}"
    done

    echo "------------------------------------------"
    echo "Total directories: ${#dirs[@]}"

    # Get user selection
    while true; do
        echo ""
        echo "Options:"
        echo " • Enter a number (1-${#dirs[@]}) to select a directory"
        echo " • Type 'q' or 'quit' to exit"

        echo -n $'\nYour choice: '
        read choice

        if [[ "$choice" =~ ^[Qq]$ ]] || [[ "$choice" =~ ^[Qq][Uu][Ii][Tt]$ ]]; then
            echo "👋 Exiting without navigation..."
            return 1
        fi

        # Check if input is a number
        if [[ "$choice" =~ ^[0-9]+$ ]]; then
            idx=$((choice - 1))
            if [[ $idx -ge 0 && $idx -lt ${#dirs[@]} ]]; then
                selected_dir="${dirs[$idx]}"
                break
            else
                echo "❌ Invalid selection. Please enter a number between 1 and ${#dirs[@]}."
                continue
            fi
        fi
    done

    # Navigate to the selected directory
    dir_path="$GITHUB_PATH/$selected_dir"
    if [[ -d "$dir_path" ]]; then
        echo ""
        echo "✅ Selected directory: $dir_path"
        cd "$dir_path" || { echo "❌ Could not navigate to $dir_path"; return 1; }
        echo "💡 Successfully navigated to: $(pwd)"
        return 0
    else
        echo "❌ Directory path does not exist: $dir_path"
        return 1
    fi
}

navigate_to_repo