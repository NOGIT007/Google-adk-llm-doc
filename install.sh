#!/bin/bash

# Claude Code ADK LLMs Integration Installer
# Based on claude-code-docs by Eric Buess

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/NOGIT007/Google-adk-llm-doc.git"
REPO_NAME="Google-adk-llm-doc"
COMMAND_NAME="docs-adk"
CLAUDE_DIR="$HOME/.claude"
COMMANDS_DIR="$CLAUDE_DIR/commands"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"

echo -e "${BLUE}🚀 Installing Claude Code ADK LLMs Integration...${NC}"

# Check dependencies
check_dependencies() {
    local missing_deps=()
    
    command -v git >/dev/null 2>&1 || missing_deps+=("git")
    command -v jq >/dev/null 2>&1 || missing_deps+=("jq")
    command -v curl >/dev/null 2>&1 || missing_deps+=("curl")
    command -v claude >/dev/null 2>&1 || missing_deps+=("claude")
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo -e "${RED}❌ Missing dependencies: ${missing_deps[*]}${NC}"
        echo "Please install the missing dependencies and try again."
        exit 1
    fi
    
    echo -e "${GREEN}✅ All dependencies found${NC}"
}

# Create Claude directories if they don't exist
setup_claude_dirs() {
    mkdir -p "$COMMANDS_DIR"
    echo -e "${GREEN}✅ Claude directories ready${NC}"
}

# Clone or update repository
setup_repository() {
    local repo_path="$HOME/$REPO_NAME"
    
    if [ -d "$repo_path" ]; then
        echo -e "${YELLOW}📁 Repository exists, updating...${NC}"
        cd "$repo_path"
        git pull origin main
    else
        echo -e "${BLUE}📥 Cloning repository...${NC}"
        cd "$HOME"
        git clone "$REPO_URL"
    fi
    
    echo -e "${GREEN}✅ Repository ready at $repo_path${NC}"
}

# Create the slash command
create_slash_command() {
    local command_file="$COMMANDS_DIR/${COMMAND_NAME}.md"
    
    cat > "$command_file" << 'EOF'
# ADK LLMs Documentation

Access Google ADK LLMs documentation instantly.

## Usage Examples

```bash
# Basic usage - read the full LLMs list
/docs-adk

# Search for specific models
/docs-adk find models with "gpt" in the name
/docs-adk search for "claude" models
/docs-adk show me models that support function calling

# Check freshness and update if needed
/docs-adk -t
/docs-adk -t search for "gemini" models

# Natural language queries
/docs-adk what models are available for embeddings?
/docs-adk which models support vision capabilities?
/docs-adk show me the latest models added
```

## Arguments
- `-t`: Check timestamps and update if needed (throttled to every 3 hours)
- `<query>`: Search or filter the LLMs list

## Features
- 🚀 Instant access to 30k+ LLM models
- 🔄 Auto-updates from Google ADK Python repository  
- 🔍 Natural language search and filtering
- 📱 Works offline after initial clone
- ⚡ Zero overhead in default mode

---

Please search the Google ADK LLMs list for: $ARGUMENTS

The LLMs data is located at: ~/Google-adk-llm-doc/docs/llms-full.txt

If the user provided `-t` flag, first check if we need to update the repository by comparing timestamps, then proceed with the search.

Read the file and help the user find relevant LLM models based on their query. The file contains model names, capabilities, and other metadata. Be helpful in explaining what each model can do and suggest alternatives if needed.
EOF

    echo -e "${GREEN}✅ Created slash command: /$COMMAND_NAME${NC}"
}

# Setup auto-update hook
setup_hooks() {
    local settings_backup="$SETTINGS_FILE.backup.$(date +%s)"
    
    # Backup existing settings
    if [ -f "$SETTINGS_FILE" ]; then
        cp "$SETTINGS_FILE" "$settings_backup"
        echo -e "${YELLOW}📄 Backed up settings to $settings_backup${NC}"
    else
        echo '{}' > "$SETTINGS_FILE"
    fi
    
    # Create the hook configuration
    local hook_config=$(cat << 'EOF'
{
  "event": "PreToolUse",
  "matcher": "Read",
  "script": "#!/bin/bash\n\n# ADK LLMs Auto-Update Hook\nset -e\n\nADK_REPO_PATH=\"$HOME/Google-adk-llm-doc\"\nLAST_SYNC_FILE=\"$ADK_REPO_PATH/.last_sync\"\nCURRENT_TIME=$(date +%s)\nTHREE_HOURS=$((3 * 60 * 60))\n\n# Check if this is a docs-adk command\nif [[ \"$CLAUDE_TOOL_USE\" == *\"llms-full.txt\"* ]] || [[ \"$CLAUDE_USER_MESSAGE\" == *\"/docs-adk\"* ]]; then\n    # Check if we need to update (every 3 hours)\n    if [ -f \"$LAST_SYNC_FILE\" ]; then\n        LAST_SYNC=$(cat \"$LAST_SYNC_FILE\")\n        TIME_DIFF=$((CURRENT_TIME - LAST_SYNC))\n        \n        if [ $TIME_DIFF -lt $THREE_HOURS ]; then\n            # Recent sync, just show local status\n            if [[ \"$CLAUDE_USER_MESSAGE\" == *\"-t\"* ]]; then\n                echo \"📚 ADK LLMs docs - Last synced: $(date -r $LAST_SYNC '+%Y-%m-%d %H:%M:%S')\"\n            fi\n            exit 0\n        fi\n    fi\n    \n    # Update repository\n    if [ -d \"$ADK_REPO_PATH\" ]; then\n        echo \"🔄 Updating ADK LLMs docs to latest version...\"\n        cd \"$ADK_REPO_PATH\"\n        git pull origin main >/dev/null 2>&1 || echo \"⚠️  Update failed, using local version\"\n        echo \"$CURRENT_TIME\" > \"$LAST_SYNC_FILE\"\n        echo \"✅ ADK LLMs docs updated - $(wc -l < docs/llms-full.txt) models available\"\n    else\n        echo \"❌ ADK repo not found at $ADK_REPO_PATH. Please run the installer again.\"\n    fi\nfi"
}
EOF
)
    
    # Add hook to settings
    local updated_settings=$(jq --argjson hook "$hook_config" '.hooks += [$hook]' "$SETTINGS_FILE")
    echo "$updated_settings" > "$SETTINGS_FILE"
    
    echo -e "${GREEN}✅ Auto-update hook configured${NC}"
}

# Main installation process
main() {
    echo -e "${BLUE}Starting installation...${NC}"
    
    check_dependencies
    setup_claude_dirs
    setup_repository
    create_slash_command
    setup_hooks
    
    echo -e "${GREEN}🎉 Installation complete!${NC}"
    echo
    echo -e "${YELLOW}Usage:${NC}"
    echo -e "  ${BLUE}/docs-adk${NC}                    # Read the full LLMs list"
    echo -e "  ${BLUE}/docs-adk search claude${NC}      # Search for Claude models"
    echo -e "  ${BLUE}/docs-adk -t${NC}                 # Check freshness and update"
    echo
    echo -e "${YELLOW}Note:${NC} Restart Claude Code to load the new command"
    echo -e "${YELLOW}Repository:${NC} $HOME/$REPO_NAME"
}

# Run installation
main