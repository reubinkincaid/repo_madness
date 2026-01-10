#!/bin/bash

GITHUB_DIR="$HOME/Documents/GitHub"

echo "Debug: GitHub directory is $GITHUB_DIR"
echo "Debug: Contents of GitHub directory:"

for dir in "$GITHUB_DIR"/*/; do
    if [[ -d "$dir" ]]; then
        repo_name=$(basename "$dir")
        has_git_dir="No"
        if [[ -d "$dir.git" ]]; then
            has_git_dir="Yes"
        fi
        echo "  $dir -> $repo_name (has .git: $has_git_dir)"
    fi
done

echo ""
echo "Repositories that would be included:"

repos=()
for dir in "$GITHUB_DIR"/*/; do
    repo_name=$(basename "$dir")
    
    if [[ "$repo_name" == "." || "$repo_name" == ".." ]]; then
        continue
    fi
    
    if [[ -d "$dir" && -d "$dir.git" ]]; then
        if [[ ! "$repo_name" == .* ]]; then
            repos+=("$repo_name")
            echo "  Included: $repo_name"
        else
            echo "  Excluded (hidden): $repo_name"
        fi
    else
        echo "  Excluded (no .git): $repo_name"
    fi
done