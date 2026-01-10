#!/usr/bin/env python3
"""
Repo Navigator - A tool to easily navigate between GitHub repositories
"""

import os
import sys
from pathlib import Path


def get_github_repos():
    """
    Scans the parent GitHub directory for repositories
    """
    # Get the parent directory (GitHub folder)
    github_dir = Path.home() / "Documents" / "GitHub"

    if not github_dir.exists():
        print(f"GitHub directory not found: {github_dir}")
        return []

    repos = []
    for item in github_dir.iterdir():
        if item.is_dir() and (item / ".git").exists():
            repos.append(item.name)

    return sorted(repos)


def display_repos(repos):
    """
    Displays the list of repositories with numbering in a user-friendly format
    """
    if not repos:
        print("No repositories found in GitHub directory.")
        return

    print("\n" + "="*50)
    print("           REPO NAVIGATOR")
    print("="*50)
    print("Available repositories:")
    print("-" * 50)

    # Display repos in columns if there are many
    if len(repos) > 20:
        # Show in multiple columns for better readability
        max_width = max(len(repo) for repo in repos) + 5
        for i, repo in enumerate(repos, 1):
            print(f"{i:2d}. {repo:<{max_width}}", end="")
            if (i % 3) == 0:  # 3 columns
                print()  # New line after every 3rd entry
        if len(repos) % 3 != 0:
            print()  # Final newline if needed
    else:
        # Just show in a single column for smaller lists
        for i, repo in enumerate(repos, 1):
            print(f"{i:2d}. {repo}")

    print("-" * 50)
    print(f"Total repositories: {len(repos)}")


def select_repo(repos):
    """
    Allows user to select a repository by number with enhanced UX
    """
    if not repos:
        return None

    while True:
        try:
            print(f"\nOptions:")
            print(" • Enter a number (1-{len(repos)}) to select a repository")
            print(" • Type a partial name to filter results")
            print(" • Type 'q' or 'quit' to exit")

            choice = input("\nYour choice: ").strip()

            if choice.lower() in ['q', 'quit']:
                return None

            # Check if input is a number
            if choice.isdigit():
                index = int(choice) - 1
                if 0 <= index < len(repos):
                    return repos[index]
                else:
                    print(f"❌ Invalid selection. Please enter a number between 1 and {len(repos)}.")
                    continue
            else:
                # Treat as a filter/partial name
                filtered_repos = [repo for repo in repos if choice.lower() in repo.lower()]

                if not filtered_repos:
                    print(f"❌ No repositories found matching '{choice}'. Please try again.")
                    continue
                elif len(filtered_repos) == 1:
                    # If only one match, select it directly
                    print(f"✅ Found one match: {filtered_repos[0]}")
                    confirm = input(f"Do you want to select '{filtered_repos[0]}'? (Y/n): ").strip().lower()
                    if confirm in ['', 'y', 'yes']:
                        return filtered_repos[0]
                    else:
                        continue
                else:
                    # Show filtered results
                    print(f"\n🔍 Found {len(filtered_repos)} matches for '{choice}':")
                    for i, repo in enumerate(filtered_repos, 1):
                        print(f"{i:2d}. {repo}")

                    sub_choice = input(f"\nSelect from filtered results (1-{len(filtered_repos)}) or press Enter to see all: ").strip()

                    if sub_choice == "":
                        # Return to full list
                        display_repos(repos)
                        continue
                    elif sub_choice.isdigit():
                        idx = int(sub_choice) - 1
                        if 0 <= idx < len(filtered_repos):
                            return filtered_repos[idx]
                        else:
                            print(f"❌ Invalid selection. Please enter a number between 1 and {len(filtered_repos)}.")
                            continue
                    else:
                        print("❌ Invalid input. Please enter a number or press Enter to see all repos.")
                        continue

        except KeyboardInterrupt:
            print("\n\n👋 Exiting...")
            return None
        except Exception as e:
            print(f"❌ An error occurred: {e}")
            continue


def get_repo_path(repo_name):
    """
    Gets the full path of the selected repository
    """
    github_dir = Path.home() / "Documents" / "GitHub"
    return github_dir / repo_name


def main():
    """
    Main function to run the repo navigator
    """
    repos = get_github_repos()

    if not repos:
        # Print error message that can be caught by shell script
        print("No repositories found or GitHub directory not accessible.")
        sys.exit(1)

    display_repos(repos)

    selected_repo = select_repo(repos)
    if selected_repo:
        repo_path = get_repo_path(selected_repo)
        # Print just the path so the shell script can use it for navigation
        print(repo_path)
    else:
        # Exit with code 1 to indicate no selection was made
        sys.exit(1)


if __name__ == "__main__":
    main()