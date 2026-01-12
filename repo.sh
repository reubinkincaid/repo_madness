#!/bin/bash

# Simple Repo Navigator - Works with bash, zsh
# When sourced, this will cd to the selected directory

# Determine the repository directory
if [[ -n "$REPO_MADNESS_PATH" ]]; then
    GITHUB_PATH="$REPO_MADNESS_PATH"
else
    for path in "$HOME/Documents/GitHub" "$HOME/GitHub" "$HOME/Code" "$HOME/Projects" "$HOME/src" "$HOME/workspace"; do
        if [[ -d "$path" ]]; then
            GITHUB_PATH="$path"
            break
        fi
    done
fi

if [[ -z "$GITHUB_PATH" ]]; then
    echo "Could not find your repositories folder." >&2
    return 1 2>/dev/null || exit 1
fi

if [[ ! -d "$GITHUB_PATH" ]]; then
    echo "Directory not found: $GITHUB_PATH" >&2
    return 1 2>/dev/null || exit 1
fi

# Get all directories
dirs=()
for entry in "$GITHUB_PATH"/*; do
    if [[ -d "$entry" ]] 2>/dev/null; then
        dir_name="${entry##*/}"
        case "$dir_name" in
            .*) continue ;;
            *) dirs+=("$dir_name") ;;
        esac
    fi
done

# Sort
if command -v sort >/dev/null 2>&1; then
    sorted_list=$(printf "%s\\n" "${dirs[@]}" | sort)
    dirs=()
    while IFS= read -r line; do
        [[ -n "$line" ]] && dirs+=("$line")
    done <<< "$sorted_list"
fi

if [[ ${#dirs[@]} -eq 0 ]]; then
    echo "No directories found in $GITHUB_PATH" >&2
    return 1 2>/dev/null || exit 1
fi

# Display
echo ""
echo "=========================================="
echo "           REPO MADNESS"
echo "=========================================="
echo "Scanning: $GITHUB_PATH"
echo "Available directories:"
echo "------------------------------------------"

i=1
for dir in "${dirs[@]}"; do
    printf "%2d. %s\\n" "$i" "$dir"
    i=$((i + 1))
done

echo "------------------------------------------"
echo "Total directories: ${#dirs[@]}"

# Get selection
while true; do
    echo ""
    echo "Options:"
    echo " • Enter a number (1-${#dirs[@]}) to select a directory"
    echo " • Type a partial name to filter results"
    echo " • Type 'q' or 'quit' to exit"

    printf "\\nYour choice: "
    read choice

    if [[ "$choice" =~ ^[Qq]$ ]] || [[ "$choice" =~ ^[Qq][Uu][Ii][Tt]$ ]]; then
        echo "Exiting without navigation..." >&2
        return 1 2>/dev/null || exit 1
    fi

    if [[ "$choice" =~ ^[0-9]+$ ]]; then
        if [[ -n "$ZSH_VERSION" ]]; then
            idx="$choice"
            if [[ $idx -ge 1 && $idx -le ${#dirs[@]} ]]; then
                selected_dir="${dirs[$idx]}"
                break
            fi
        else
            idx=$((choice - 1))
            if [[ $idx -ge 0 && $idx -lt ${#dirs[@]} ]]; then
                selected_dir="${dirs[$idx]}"
                break
            fi
        fi
        echo "Invalid selection. Please enter a number between 1 and ${#dirs[@]}."
        continue
    else
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
            echo ""
            echo "Found ${#filtered_dirs[@]} matches for '$choice':"
            j=1
            for dir in "${filtered_dirs[@]}"; do
                printf "%2d. %s\\n" "$j" "$dir"
                j=$((j + 1))
            done

            printf "\\nSelect from filtered results (1-${#filtered_dirs[@]}): "
            read sub_choice

            if [[ "$sub_choice" =~ ^[0-9]+$ ]]; then
                if [[ -n "$ZSH_VERSION" ]]; then
                    sub_idx="$sub_choice"
                    if [[ $sub_idx -ge 1 && $sub_idx -le ${#filtered_dirs[@]} ]]; then
                        selected_dir="${filtered_dirs[$sub_idx]}"
                        break
                    fi
                else
                    sub_idx=$((sub_choice - 1))
                    if [[ $sub_idx -ge 0 && $sub_idx -lt ${#filtered_dirs[@]} ]]; then
                        selected_dir="${filtered_dirs[$sub_idx]}"
                        break
                    fi
                fi
                echo "Invalid selection. Please enter a number between 1 and ${#filtered_dirs[@]}."
                continue
            else
                echo "Invalid input. Please enter a number."
                continue
            fi
        fi
    fi
done

# Navigate
dir_path="$GITHUB_PATH/$selected_dir"
if [[ -d "$dir_path" ]]; then
    echo ""
    echo "Selected directory: $dir_path"
    cd "$dir_path" || { echo "Could not navigate to $dir_path"; return 1 2>/dev/null || exit 1; }
    echo "Successfully navigated to: $(pwd)"
else
    echo "Directory path does not exist: $dir_path" >&2
    return 1 2>/dev/null || exit 1
fi
