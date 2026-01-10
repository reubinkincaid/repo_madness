#!/bin/bash

# Repo Navigator - Simple directory listing implementation

REPO_NAV_GITHUB_DIR="$HOME/Documents/GitHub"

navigate_to_repo() {
    echo "🚀 Starting Repo Navigator..."

    # Check if GitHub directory exists
    if [[ ! -d "$REPO_NAV_GITHUB_DIR" ]]; then
        echo "❌ GitHub directory not found: $REPO_NAV_GITHUB_DIR"
        echo "💡 Make sure you have a GitHub directory at ~/Documents/GitHub/"
        return 1
    fi

    # Get all directories in GitHub folder (excluding hidden ones)
    temp_file=$(mktemp)
    find "$REPO_NAV_GITHUB_DIR" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z > "$temp_file"

    dirs=()
    while IFS= read -r -d '' dir; do
        dir_name=$(basename "$dir")
        # Skip hidden directories that start with a dot
        if [[ ! "$dir_name" =~ ^\. ]]; then
            dirs+=("$dir_name")
        fi
    done < "$temp_file"

    rm "$temp_file"

    if [[ ${#dirs[@]} -eq 0 ]]; then
        echo "⚠️  No directories found in $REPO_NAV_GITHUB_DIR"
        echo "💡 Make sure you have directories in ~/Documents/GitHub/"
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
        echo " • Type a partial name to filter results"
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
        else
            # Filter by partial name
            filtered_dirs=()
            for dir in "${dirs[@]}"; do
                if [[ "$dir" == *"$choice"* ]]; then
                    filtered_dirs+=("$dir")
                fi
            done

            if [[ ${#filtered_dirs[@]} -eq 0 ]]; then
                echo "❌ No directories found matching '$choice'. Please try again."
                continue
            elif [[ ${#filtered_dirs[@]} -eq 1 ]]; then
                echo "✅ Found one match: ${filtered_dirs[0]}"
                echo -n "Do you want to select '${filtered_dirs[0]}'? (Y/n): "
                read confirm
                if [[ "$confirm" =~ ^[Yy]$ ]] || [[ -z "$confirm" ]]; then
                    selected_dir="${filtered_dirs[0]}"
                    break
                else
                    continue
                fi
            else
                # Show filtered results
                echo ""
                echo "🔍 Found ${#filtered_dirs[@]} matches for '$choice':"
                for i in "${!filtered_dirs[@]}"; do
                    printf "%2d. %s\n" $((i+1)) "${filtered_dirs[$i]}"
                done

                echo -n $'\nSelect from filtered results (1-'${#filtered_dirs[@]}'): '
                read sub_choice

                if [[ "$sub_choice" =~ ^[0-9]+$ ]]; then
                    sub_idx=$((sub_choice - 1))
                    if [[ $sub_idx -ge 0 && $sub_idx -lt ${#filtered_dirs[@]} ]]; then
                        selected_dir="${filtered_dirs[$sub_idx]}"
                        break
                    else
                        echo "❌ Invalid selection. Please enter a number between 1 and ${#filtered_dirs[@]}."
                        continue
                    fi
                else
                    echo "❌ Invalid input. Please enter a number."
                    continue
                fi
            fi
        fi
    done

    # Navigate to the selected directory
    dir_path="$REPO_NAV_GITHUB_DIR/$selected_dir"
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

# If script is sourced, allow directory change to persist
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    navigate_to_repo
else
    echo "⚠️  Warning: To navigate to the selected directory, source this script:"
    echo "   source $0"
    echo "   OR"
    echo "   . $0"
    navigate_to_repo
fi