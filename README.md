# Repo Madness

A fast, shell-native tool for navigating your GitHub repositories. No Python required!

## Features

- ✅ **Works with both Bash and Zsh** - Automatic shell detection
- ✅ **Configurable GitHub folder** - Auto-detects or lets you set your own path
- ✅ **Interactive selection** - Choose repos by number or filter by name
- ✅ **Pure bash** - No dependencies, no Python overhead
- ✅ **Cross-platform** - macOS, Linux, and Windows (WSL)

## Installation

### Option 1: Quick Install (Recommended)

```bash
# Clone the repository
git clone https://github.com/yourusername/repo_madness.git
cd repo_madness

# Run the installer
./install.sh

# Reload your shell
source ~/.zshrc  # or source ~/.bashrc
```

### Option 2: Manual Setup

```bash
# Clone to any location
git clone https://github.com/yourusername/repo_madness.git ~/tools/repo_madness

# Add alias manually to your shell profile
echo "alias repo='source ~/tools/repo_madness/repo.sh'" >> ~/.zshrc

# Reload your shell
source ~/.zshrc
```

## Usage

From anywhere in your terminal, simply run:

```bash
repo
```

By default, it will look for repositories in `~/Documents/GitHub`. If your repositories are elsewhere, you can configure it:

```bash
# Set your GitHub folder location (add to your shell profile)
export REPO_MADNESS_PATH="/path/to/your/repos"

# Then run repo
repo
```

If `REPO_MADNESS_PATH` is not set, it will automatically check common locations:
- `~/Documents/GitHub`
- `~/GitHub`
- `~/Code`
- `~/Projects`
- `~/src`
- `~/workspace`

You'll see a list of all directories in your configured folder.

### Options

- **Enter a number** (1-N) - Navigate to that repository
- **Type a partial name** - Filter repositories by name
- **Type 'q' or 'quit'** - Exit without navigating

### Examples

```
$ repo
==========================================
           REPO MADNESS
==========================================
Available directories:
------------------------------------------
 1. my-project
 2. another-repo
 3. website
 4. api-server
------------------------------------------
Total directories: 4

Options:
 • Enter a number (1-4) to select a directory
 • Type a partial name to filter results
 • Type 'q' or 'quit' to exit

Your choice: api
Found one match: api-server
Do you want to select 'api-server'? (Y/n):
Selected directory: /Users/you/Documents/GitHub/api-server
Successfully navigated to: /Users/you/Documents/GitHub/api-server
```

## How It Works

Repo Madness uses pure bash to:

1. **Find your GitHub folder** - Automatically detects `~/Documents/GitHub`
2. **List directories** - Uses `find` to get all subdirectories
3. **Filter for repos** - Checks for `.git` folder presence (optional)
4. **Navigate** - Uses `cd` to change to the selected directory

### Shell Compatibility

The tool automatically detects your shell and adjusts accordingly:

- **Bash**: Uses 0-indexed arrays
- **Zsh**: Uses 1-indexed arrays (detected via `$ZSH_VERSION`)

## Files

- `repo.sh` - Main script (pure bash, works everywhere)
- `install.sh` - Automated installer
- `README.md` - This file

## Requirements

- Bash 4.0+ or Zsh
- Standard Unix tools: `find`, `sort`, `xargs`
- **No Python required!**

## Why Pure Bash?

- **Faster** - No Python startup overhead
- **Universal** - Works on any Unix-like system
- **Simple** - Easy to understand and modify
- **Reliable** - No dependency management issues

## Customization

Want to change the GitHub folder location? Edit `repo_simple.sh`:

```bash
# Change this line:
GITHUB_PATH="$HOME/Documents/GitHub"

# To something like:
GITHUB_PATH="$HOME/Code"
```

## License

MIT - Free to use and modify!

## Contributing

Found a bug? Have an idea? Open an issue or PR!
