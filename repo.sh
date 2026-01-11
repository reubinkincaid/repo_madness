#!/bin/bash

# Repo Navigator - Shell wrapper to enable actual directory navigation
# This script calls the Python script and handles directory changes

REPO_SCRIPT_DIR="/Users/studio/Documents/GitHub/repo_madness"
PYTHON_SCRIPT="$REPO_SCRIPT_DIR/repo_navigator.py"

# Main navigation function
navigate_to_repo() {
    echo "Starting Repo Madness..."

    # Check if the Python script exists
    if [[ ! -f "$PYTHON_SCRIPT" ]]; then
        echo "Python script not found: $PYTHON_SCRIPT"
        echo "Make sure you're running this from the correct directory or reinstall the tool."
        return 1
    fi

    # Run the Python script and capture the selected path
    result=$(python3 "$PYTHON_SCRIPT")
    exit_code=$?

    # Check if the output indicates no repos were found
    if [[ $exit_code -ne 0 ]]; then
        if [[ "$result" == *"No repositories found or GitHub directory not accessible"* ]]; then
            echo "$result"
            echo "Make sure you have Git repositories in ~/Documents/GitHub/"
            return 1
        fi
    fi

    # If we have a valid path that exists, navigate to it
    if [[ -n "$result" && -d "$result" ]]; then
        echo "Selected repository: $result"
        cd "$result" || { echo "Could not navigate to $result"; return 1; }
        echo "Successfully navigated to: $(pwd)"
        return 0
    else
        echo "Exiting without navigation..."
        return 1
    fi
}

# If script is sourced (using 'source repo.sh' or '. repo.sh'), allow directory change
if [[ "${BASH_SOURCE[0]}" != "${0}" ]] || [[ "${ZSH_VERSION}" != "" && "${0}" != "${ZSH_ARGZERO}" ]]; then
    # Script is being sourced - this allows the directory change to persist
    navigate_to_repo
else
    # Script is being executed directly - warn user about sourcing
    echo "Warning: To navigate to the selected repository, source this script:"
    echo "  source $0"
    echo "  OR"
    echo "  . $0"
    navigate_to_repo
fi