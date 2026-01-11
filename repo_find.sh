#!/bin/bash

# Repo Navigator - Simple directory listing implementation (bash/zsh compatible)

REPO_NAV_GITHUB_DIR="$HOME/Documents/GitHub"

navigate_to_repo() {
    echo "Starting Repo Madness..."

    # Check if GitHub directory exists
    if [[ ! -d "$REPO_NAV_GITHUB_DIR" ]]; then
        echo "GitHub directory not found: $REPO_NAV_GITHUB_DIR"
        echo "Make sure you have a GitHub directory at ~/Documents/GitHub/"
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
        echo "No directories found in $REPO_NAV_GITHUB_DIR"
        echo "Make sure you have directories in ~/Documents/GitHub/"
        return 1
    fi

    # Display the directories
    echo ""
    echo "=========================================="
    echo "           REPO MADNESS"
    echo "=========================================="
    echo "Available directories:"
    echo "------------------------------------------"

    local i=1
    for dir in "${dirs[@]}"; do
        printf "%2d. %s\n" "$i" "$dir"
        i=$((i + 1))
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

        printf "\nYour choice: "
        read choice

        if [[ "$choice" =~ ^[Qq]$ ]] || [[ "$choice" =~ ^[Qq][Uu][Ii][Tt]$ ]]; then
            echo "Exiting without navigation..."
            return 1
        fi

        # Check if input is a number
        if [[ "$choice" =~ ^[0-9]+$ ]]; then
            # In zsh, arrays are 1-indexed, so we need to handle this properly
            if [[ -n "$ZSH_VERSION" ]]; then
                idx="$choice"
            else
                idx=$((choice - 1))
            fi

            if [[ $idx -ge 1 && $idx -le ${#dirs[@]} ]]; then
                selected_dir="${dirs[$idx]}"
                break
            else
                echo "Invalid selection. Please enter a number between 1 and ${#dirs[@]}."
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
                echo "No directories found matching '$choice'. Please try again."
                continue
            elif [[ ${#filtered_dirs[@]} -eq 1 ]]; then
                # Get the single filtered result (index 1 for zsh, 0 for bash)
                local single_result
                if [[ -n "$ZSH_VERSION" ]]; then
                    single_result="${filtered_dirs[1]}"
                else
                    single_result="${filtered_dirs[0]}"
                fi
                echo "Found one match: $single_result"
                echo -n "Do you want to select '$single_result'? (Y/n): "
                read confirm
                if [[ "$confirm" =~ ^[Yy]$ ]] || [[ -z "$confirm" ]]; then
                    selected_dir="$single_result"
                    break
                else
                    continue
                fi
            else
                # Show filtered results
                echo ""
                echo "Found ${#filtered_dirs[@]} matches for '$choice':"
                local j=1
                for dir in "${filtered_dirs[@]}"; do
                    printf "%2d. %s\n" "$j" "$dir"
                    j=$((j + 1))
                done

                printf "\nSelect from filtered results (1-${#filtered_dirs[@]}): "
                read sub_choice

                if [[ "$sub_choice" =~ ^[0-9]+$ ]]; then
                    if [[ -n "$ZSH_VERSION" ]]; then
                        sub_idx="$sub_choice"
                    else
                        sub_idx=$((sub_choice - 1))
                    fi

                    if [[ $sub_idx -ge 1 && $sub_idx -le ${#filtered_dirs[@]} ]]; then
                        selected_dir="${filtered_dirs[$sub_idx]}"
                        break
                    else
                        echo "Invalid selection. Please enter a number between 1 and ${#filtered_dirs[@]}."
                        continue
                    fi
                else
                    echo "Invalid input. Please enter a number."
                    continue
                fi
            fi
        fi
    done

    # Navigate to the selected directory
    dir_path="$REPO_NAV_GITHUB_DIR/$selected_dir"
    if [[ -d "$dir_path" ]]; then
        echo ""
        echo "Selected directory: $dir_path"
        cd "$dir_path" || { echo "Could not navigate to $dir_path"; return 1; }
        echo "Successfully navigated to: $(pwd)"
        return 0
    else
        echo "Directory path does not exist: $dir_path"
        return 1
    fi
}

# If script is sourced, allow directory change to persist
if [[ "${BASH_SOURCE[0]}" != "${0}" ]] || [[ "${ZSH_VERSION}" != "" && "${0}" != "${ZSH_ARGZERO}" ]]; then
    navigate_to_repo
else
    echo "Warning: To navigate to the selected directory, source this script:"
    echo "  source $0"
    echo "  OR"
    echo "  . $0"
    navigate_to_repo
fi
