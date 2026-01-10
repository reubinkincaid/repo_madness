#!/bin/bash

# Repo Navigator - Pure bash implementation for navigating GitHub repositories

GITHUB_DIR="$HOME/Documents/GitHub"

navigate_to_repo() {
    echo "🚀 Starting Repo Navigator..."

    # Check if GitHub directory exists
    if [[ ! -d "$GITHUB_DIR" ]]; then
        echo "❌ GitHub directory not found: $GITHUB_DIR"
        echo "💡 Make sure you have a GitHub directory at ~/Documents/GitHub/"
        return 1
    fi

    # Find all git repositories in the GitHub directory using find command
    temp_file=$(mktemp)
    find "$GITHUB_DIR" -mindepth 1 -maxdepth 1 -type d -exec test -d '{}/.git' \; -print 2>/dev/null | xargs basename -a | sort > "$temp_file"

    repos=()
    while IFS= read -r repo_name; do
        # Skip hidden directories
        if [[ ! "$repo_name" =~ ^\. ]]; then
            repos+=("$repo_name")
        fi
    done < "$temp_file"

    rm "$temp_file"

    if [[ ${#repos[@]} -eq 0 ]]; then
        echo "⚠️  No repositories found in $GITHUB_DIR"
        echo "💡 Make sure your repositories have a .git folder"
        return 1
    fi

    # Function to get git info for a repository
    get_git_info() {
        local repo_path="$1"
        if [[ -d "$repo_path/.git" ]]; then
            # Get the latest commit info
            local latest_hash=$(cd "$repo_path" && git log -1 --format="%h" 2>/dev/null)
            local latest_msg=$(cd "$repo_path" && git log -1 --format="%s" 2>/dev/null | cut -c1-50)
            local latest_date=$(cd "$repo_path" && git log -1 --format="%ad" --date=short 2>/dev/null)
            local latest_author=$(cd "$repo_path" && git log -1 --format="%an" 2>/dev/null)

            if [[ -n "$latest_hash" ]]; then
                echo " [$latest_hash - $latest_author - $latest_date]"
            else
                echo " [No commits]"
            fi
        else
            echo " [No .git]"
        fi
    }

    # Display the repositories
    echo ""
    echo "=========================================="
    echo "           REPO NAVIGATOR"
    echo "=========================================="
    echo "Available repositories:"
    echo "------------------------------------------"

    for ((i = 0; i < ${#repos[@]}; i++)); do
        repo_path="$GITHUB_DIR/${repos[$i]}"
        git_info=$(get_git_info "$repo_path")
        printf "%2d. %s%s\n" $((i+1)) "${repos[$i]}" "$git_info"
    done

    echo "------------------------------------------"
    echo "Total repositories: ${#repos[@]}"

    # Get user selection
    while true; do
        echo ""
        echo "Options:"
        echo " • Enter a number (1-${#repos[@]}) to select a repository"
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
            if [[ $idx -ge 0 && $idx -lt ${#repos[@]} ]]; then
                selected_repo="${repos[$idx]}"
                break
            else
                echo "❌ Invalid selection. Please enter a number between 1 and ${#repos[@]}."
                continue
            fi
        else
            # Filter by partial name
            filtered_repos=()
            for repo in "${repos[@]}"; do
                if [[ "$repo" == *"$choice"* ]]; then
                    filtered_repos+=("$repo")
                fi
            done

            if [[ ${#filtered_repos[@]} -eq 0 ]]; then
                echo "❌ No repositories found matching '$choice'. Please try again."
                continue
            elif [[ ${#filtered_repos[@]} -eq 1 ]]; then
                echo "✅ Found one match: ${filtered_repos[0]}"
                echo -n "Do you want to select '${filtered_repos[0]}'? (Y/n): "
                read confirm
                if [[ "$confirm" =~ ^[Yy]$ ]] || [[ -z "$confirm" ]]; then
                    selected_repo="${filtered_repos[0]}"
                    break
                else
                    continue
                fi
            else
                # Show filtered results
                echo ""
                echo "🔍 Found ${#filtered_repos[@]} matches for '$choice':"
                for i in "${!filtered_repos[@]}"; do
                    printf "%2d. %s\n" $((i+1)) "${filtered_repos[$i]}"
                done

                echo -n $'\nSelect from filtered results (1-'${#filtered_repos[@]}'): '
                read sub_choice

                if [[ "$sub_choice" =~ ^[0-9]+$ ]]; then
                    sub_idx=$((sub_choice - 1))
                    if [[ $sub_idx -ge 0 && $sub_idx -lt ${#filtered_repos[@]} ]]; then
                        selected_repo="${filtered_repos[$sub_idx]}"
                        break
                    else
                        echo "❌ Invalid selection. Please enter a number between 1 and ${#filtered_repos[@]}."
                        continue
                    fi
                else
                    echo "❌ Invalid input. Please enter a number."
                    continue
                fi
            fi
        fi
    done

    # Navigate to the selected repository
    repo_path="$GITHUB_DIR/$selected_repo"
    if [[ -d "$repo_path" ]]; then
        echo ""
        echo "✅ Selected repository: $repo_path"
        cd "$repo_path" || { echo "❌ Could not navigate to $repo_path"; return 1; }
        echo "💡 Successfully navigated to: $(pwd)"
        return 0
    else
        echo "❌ Repository path does not exist: $repo_path"
        return 1
    fi
}

# If script is sourced, allow directory change to persist
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    navigate_to_repo
else
    echo "⚠️  Warning: To navigate to the selected repository, source this script:"
    echo "   source $0"
    echo "   OR"
    echo "   . $0"
    navigate_to_repo
fi