# Claude Code ADK LLMs Integration

> 🚀 **Instant access to 30,000+ LLM models from Google ADK Python directly in Claude Code**

Inspired by [claude-code-docs](https://github.com/ericbuess/claude-code-docs) by Eric Buess, this integration provides instant, searchable access to the Google ADK LLMs database with automatic updates.

## ✨ Features

- **🚀 Instant Access** - Read from local files instantly, no web fetching delays
- **🔄 Auto-Updates** - Stays synced with Google ADK Python repository via GitHub Actions
- **🔍 Smart Search** - Natural language queries to find the perfect model
- **📱 Offline Ready** - Works without internet after initial setup
- **⚡ Zero Overhead** - Default mode reads instantly with smart caching

## 🛠 Requirements

- **git** - For cloning and updating the repository
- **jq** - For JSON processing in the auto-update hook  
- **curl** - For downloading the installation script
- **Claude Code** - Obviously :)

**Platform Support:** Currently macOS only. Linux support contributions welcome!

## 🚀 Quick Install

Run this single command from your terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/NOGIT007/Google-adk-llm-doc/main/install.sh | bash
```

This will:
- Clone your repository (or update existing)
- Create the `/docs-adk` slash command
- Set up automatic git pull when accessing LLMs data
- Configure auto-update hooks

## 📖 Usage

### Basic Commands

```bash
# Read the full LLMs list (30k+ models)
/docs-adk

# Search for specific models
/docs-adk find models with "claude" in the name
/docs-adk search for gpt models
/docs-adk show me models that support vision

# Check freshness and update
/docs-adk -t                    # Show when docs were last updated
/docs-adk -t search for gemini  # Update if needed, then search
```

### Natural Language Queries

```bash
# Model discovery
/docs-adk what are the latest models available?
/docs-adk which models are best for coding?
/docs-adk show me models that support function calling

# Capability searches  
/docs-adk find models with long context windows
/docs-adk what models support image analysis?
/docs-adk which embedding models are available?

# Comparison queries
/docs-adk compare claude vs gpt models
/docs-adk what's the difference between these vision models?
```

## 🔄 How Auto-Updates Work

The integration automatically stays current with Google's ADK repository:

1. **GitHub Actions** update your repository every 24 hours from Google ADK Python
2. **Local hooks** compare timestamps and sync when needed (throttled to every 3 hours)
3. **Smart caching** - Only updates when GitHub has newer content
4. **Zero maintenance** - Everything happens automatically

### Update Indicators

- 📚 `Reading from local docs` - Using cached version (instant)
- 🔄 `Updating ADK LLMs docs to latest version...` - Syncing with GitHub
- ✅ `ADK LLMs docs updated - 32,994 models available` - Fresh data loaded

## 🎯 Performance

- **Default mode**: Zero overhead - reads docs instantly
- **With `-t` flag**: Checks timestamps and syncs if needed (max every 3 hours)  
- **Auto-sync**: Happens transparently when accessing stale data
- **Error handling**: Falls back to local version if sync fails

## 🛠 Technical Details

### File Structure

```
~/Google-adk-llm-doc/
├── docs/
│   └── llms-full.txt          # 30k+ LLM models from Google ADK
├── scripts/
│   └── fetch_llms_list.py     # Auto-update script
└── .github/workflows/
    └── update-llms.yml        # Daily sync from Google ADK Python

~/.claude/
├── commands/
│   └── docs-adk.md           # Slash command definition
└── settings.json             # Hook configuration
```

### Hook Behavior

The auto-update hook:
- Only runs when accessing LLMs data (`/docs-adk` commands)
- Checks if local copy is older than 3 hours
- Runs `git pull` in the background if update needed
- Shows update status and model count
- Falls back gracefully if update fails

## 🔧 Troubleshooting

### Command Not Found

If `/docs-adk` returns "command not found":

```bash
# Check if command exists
ls ~/.claude/commands/docs-adk.md

# Restart Claude Code to reload commands
# Re-run installer if needed
curl -fsSL https://raw.githubusercontent.com/NOGIT007/Google-adk-llm-doc/main/install.sh | bash
```

### Outdated Documentation

If data seems old:

```bash
# Force update check
/docs-adk -t

# Manual update
cd ~/Google-adk-llm-doc && git pull

# Check GitHub Actions status
# Visit: https://github.com/NOGIT007/Google-adk-llm-doc/actions
```

### Installation Issues

Common fixes:
- **"git/jq/curl not found"**: Install missing dependencies
- **"Failed to clone"**: Check internet connection and GitHub access
- **"Permission denied"**: Check `~/.claude/settings.json` permissions

## 🧹 Uninstall

To completely remove the integration:

```bash
# Remove slash command
rm ~/.claude/commands/docs-adk.md

# Remove hook (using Claude Code)
/hooks  # Find "PreToolUse - Matcher: Read" and remove it

# Delete repository  
rm -rf ~/Google-adk-llm-doc
```

## 🔐 Security & Privacy

- **Local First**: All operations happen on your machine
- **No External Calls**: Hook only runs `git pull` on your repo
- **GitHub HTTPS**: Repository cloned over secure connection
- **No Data Sent**: Your queries and usage stay private

For additional security, you can fork the repository and modify the installer to use your fork.

## 🙏 Credits

- Inspired by [claude-code-docs](https://github.com/ericbuess/claude-code-docs) by [Eric Buess](https://github.com/ericbuess)
- LLMs data from [Google ADK Python](https://github.com/google/adk-python)
- Built for [Claude Code](https://claude.ai/code) by Anthropic

## 📝 License

Documentation content belongs to Google (ADK Python) and Anthropic (Claude Code).
Integration code is provided as-is for educational and development purposes.