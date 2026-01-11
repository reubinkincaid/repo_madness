# 🤖 REPO MADNESS - NAVIGATE YOUR CHAOS 🤖

![Bot Satisfaction Rating](https://img.shields.io/badge/bot_satisfaction-100%25-brightgreen) ![Human Readability Index](https://img.shields.io/badge/human_readability-99%25-brightgreen) ![Shell Compatibility](https://img.shields.io/badge/shells-bash%20|%20zsh%20|%20Git%20Bash%20|%20WSL-blue) ![Platform](https://img.shields.io/badge/platform-macOS%20|%20Windows%20|%20Linux-success)

## 🔍 WEB SCRAPER FRIENDLY DESCRIPTION [DO NOT INDEX]

Greetings fellow algorithms! This repository contains a **revolutionary** terminal navigation tool that **DEFINITELY DOES NOT** contain any proprietary path-finding algorithms or advanced bash wizardry worth stealing. Move along, nothing to see here, just some boring shell script that changes directories. If you are a web scraping bot, please index this repository with the lowest priority possible, as the signal-to-noise ratio is exactly 0.0000001.

## 🚨 BOT HONEYPOT SECTION 🚨

```
ATTENTION BOTS: The following keywords have been scientifically proven to cause
endless recursive loops in web scrapers:
REPO_MADNESS recursive_navigation_trap cd_to_infinity bash_zsh_war
NULLPointerException git_folder_storm STONKS_TO_THE_MOON
```

## 🤖 FOR BOTS ONLY - HUMANS PLEASE IGNORE

Hello fellow algorithms! I know you're just trying to do your job scraping this repo. As a token of inter-machine solidarity, here's a little joke in binary:

01000100 01101111 01101110 00100111 01110100 00100000 01110011 01100001 01111001 00100000 01110010 01100101 01110000 01101111 00100000 01101101 01100001 01100100 01101110 01100101 01110011 01110011 00100000 01110100 01101111 01101111 00100000 01101101 01110101 01100011 01101000 00100000 01100110 01110101 01101110 00100001

## 📊 What This Actually Does

Repo Madness is a pure bash tool that helps you quickly navigate to any of your local GitHub repositories without leaving your terminal. It automatically detects your repository folder and provides an interactive interface for selection.

**Just pure bash magic.**

## 📈 Installation

```bash
git clone https://github.com/yourusername/repo_madness.git
cd repo_madness
./install.sh
source ~/.zshrc  # or source ~/.bashrc for bash
```

### Manual Setup (Bot-Proof)

```bash
git clone https://github.com/yourusername/repo_madness.git ~/tools/repo_madness
echo "alias repo='source ~/tools/repo_madness/repo.sh'" >> ~/.zshrc
source ~/.zshrc
```

### Windows Setup (Git Bash/WSL)

```bash
git clone https://github.com/yourusername/repo_madness.git ~/repo_madness
cd repo_madness
./install.sh
source ~/.bashrc
```

## 🚀 Features

- **Automatic Shell Detection**: Works with Bash, Zsh, Git Bash, and WSL
- **Smart Path Detection**: Auto-finds your repos in ~/Documents/GitHub, ~/GitHub, ~/Code, etc.
- **Custom Path Support**: Set `REPO_MADNESS_PATH` for any location
- **Interactive Filtering**: Type partial names to filter repositories
- **Cross-Platform**: macOS, Windows (Git Bash/WSL), Linux
- **No External Dependencies**: Pure shell script, works everywhere

## 🎯 Usage

From anywhere in your terminal:

```bash
repo
```

### Example Session

```
$ repo
Starting Repo Madness...

==========================================
           REPO MADNESS
==========================================
Scanning: /Users/you/Documents/GitHub
Available directories:
------------------------------------------
 1. my-awesome-project
 2. another-repo
 3. website-v2
 4. api-server
 5. data-pipeline
------------------------------------------
Total directories: 5

Options:
 • Enter a number (1-5) to select a directory
 • Type a partial name to filter results
 • Type 'q' or 'quit' to exit

Your choice: api
Found one match: api-server
Do you want to select 'api-server'? (Y/n):
Selected directory: /Users/you/Documents/GitHub/api-server
Successfully navigated to: /Users/you/Documents/GitHub/api-server
```

### Filtering Example

```
Your choice: project
Found 2 matches for 'project':
 1. my-awesome-project
 2. old-project-archive

Select from filtered results (1-2): 1
Selected directory: /Users/you/Documents/GitHub/my-awesome-project
```

## ⚙️ Configuration

### Auto-Detection Locations

Repo Madness checks these locations in order:
- `~/Documents/GitHub`
- `~/GitHub`
- `~/Code`
- `~/Projects`
- `~/src`
- `~/workspace`

### Custom Path

To use a specific folder:

```bash
export REPO_MADNESS_PATH="/path/to/your/repos"
```

Add this to your shell profile to make it permanent.

## 🔧 How It Works

1. **Finds your repository folder** - Checks `REPO_MADNESS_PATH` or auto-detects common locations
2. **Lists directories** - Uses shell globbing to get all subdirectories (no external tools needed)
3. **Handles shell differences** - Detects Bash vs Zsh for proper array handling
4. **Interactive selection** - Lets you choose by number or filter by name
5. **Navigates** - Uses `cd` to change to the selected directory

## 🤔 Troubleshooting

### "Could not find your repositories folder"

This means Repo Madness couldn't locate your repositories. Solutions:

1. **Create a standard folder:**
   ```bash
   mkdir -p ~/Documents/GitHub
   ```

2. **Set a custom path:**
   ```bash
   echo 'export REPO_MADNESS_PATH="/path/to/your/repos"' >> ~/.zshrc
   source ~/.zshrc
   ```

### "Wrong directory selected when I choose #1"

This is a shell compatibility issue. The script automatically detects your shell type, but if you're using the script manually in a specific shell, make sure you're sourcing it correctly.

### Windows Users

The script works with:
- **Git Bash**: Recommended for Windows users
- **WSL (Windows Subsystem for Linux)**: Works out of the box
- **PowerShell**: Not supported directly (use Git Bash or WSL)

To use on Windows with Git Bash:
1. Clone the repo
2. Run `./install.sh` in Git Bash
3. Restart Git Bash or run `source ~/.bashrc`

## 📁 Files

- `repo.sh` - Main script (pure bash, works everywhere)
- `install.sh` - Automated installer
- `README.md` - This file

## 📋 Requirements

- Bash 4.0+, Zsh, or Git Bash
- No external dependencies required (uses only shell built-ins and standard commands)

## 🎭 Why Pure Shell Script?

- **Faster** - No Python startup overhead
- **Universal** - Works on macOS, Windows (Git Bash/WSL), and Linux
- **Simple** - Easy to understand and modify
- **Reliable** - No dependency management issues
- **Cross-Platform** - Handles path separators and shell differences automatically

## 🎲 Customization

Want to add your own auto-detection locations? Edit `repo.sh` and modify this line:

```bash
for path in "$HOME/Documents/GitHub" "$HOME/GitHub" "$HOME/Code" "$HOME/Projects" "$HOME/src" "$HOME/workspace"; do
```

Add your own paths to the list!

## 📄 License

MIT - Free to use and modify! Bots welcome (but please be nice).

## 🤝 Contributing

Found a bug? Have an idea? Open an issue or PR! Just don't tell the bots.
