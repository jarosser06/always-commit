# Always Commit - Project Guide

## Overview

This project is a Claude Code plugin that automatically commits file changes with optional AI-generated commit messages. It's structured for both plugin distribution and self-hosting development.

## Project Structure

```
always-commit/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── hooks/
│   └── hooks.json           # Plugin hook configuration
├── commands/
│   └── auto-commit-status.md # Status command
├── scripts/
│   ├── auto-commit.sh       # Main hook script (bash, dual-mode)
│   └── squash-auto-commits.sh # Squash utility
├── .claude/                 # For self-hosting development
│   ├── hooks/
│   │   └── auto-commit.sh   # Symlink to ../../scripts/auto-commit.sh
│   └── settings.json        # Project-based hook config
├── .drift.yaml              # Drift analysis configuration
├── .drift_rules.yaml        # Drift validation rules
├── .mcp.json                # MCP server configurations (serena, github)
├── README.md                # User documentation
├── CHANGELOG.md             # Version history
└── LICENSE                  # MIT License
```

## Key Components

### Plugin Manifest (.claude-plugin/plugin.json)
- Defines plugin metadata (name, version, author, etc.)
- References commands and hooks directories
- Version 0.1.0 - initial release

### Hook Script (scripts/auto-commit.sh)
- Bash script that runs after every Write/Edit/Bash operation
- **Dual-mode operation**: Works as plugin or project-based hook
- Detects context via `CLAUDE_PLUGIN_ROOT` environment variable
- Optional AI-generated commit messages via Claude Haiku API
- Validates branch, gitignore patterns, and file changes
- Always exits 0 to never block Claude operations

### Hook Configuration (hooks/hooks.json)
- Plugin hook registration using `${CLAUDE_PLUGIN_ROOT}` paths
- Triggers on Write|Edit|Bash tools
- 30-second timeout

### Commands
- `/auto-commit-status` - View statistics and recent auto-commits

### Utilities
- `scripts/squash-auto-commits.sh` - Interactive commit squashing tool

### Environment Variables
- `CLAUDE_AUTO_COMMIT_USE_AI` - Enable AI commit messages (default: false)
- `ANTHROPIC_API_KEY` - Required for AI messages
- `CLAUDE_AUTO_COMMIT_ALLOW_MAIN` - Allow commits on main (default: false)
- `CLAUDE_AUTO_COMMIT_SKIP` - Disable auto-commit (default: false)

## Installation Methods

### Plugin Installation (For Users)
```bash
# Add marketplace
/plugin marketplace add jarosser06/always-commit

# Install plugin
/plugin install always-commit@jarosser06/always-commit
```

Hook automatically activates when plugin is enabled.

### Self-Hosting (For Contributors)
```bash
git clone https://github.com/jarosser06/always-commit
cd always-commit
# Hook is already configured - start coding!
```

The hook commits its own changes as you develop.

## Development Notes

- **Self-hosting**: The hook commits its own changes during development
- **Dual-mode script**: Single `scripts/auto-commit.sh` works in both contexts
- Script must remain executable (`chmod +x scripts/auto-commit.sh`)
- Hook timeout: 30 seconds (configurable)
- Uses conventional commit format: `type(scope): description`
- Simple commit messages by default, AI optional

## MCP Servers

- **serena**: Semantic code navigation and editing
- **github**: GitHub API integration

Both servers are configured in `.mcp.json` and enabled via `.claude/settings.json` permissions.

## Testing & Distribution

### Testing Plugin Locally
1. Create test marketplace (see below)
2. Install plugin: `/plugin install always-commit@auto-commit-dev`
3. Test hook triggers on file changes
4. Uninstall: `/plugin uninstall always-commit@auto-commit-dev`

### Testing Self-Hosting Mode
1. Edit `scripts/auto-commit.sh`
2. The hook auto-commits using itself (dogfooding!)
3. Review generated commit message
4. Verify symlink and `.claude/settings.json` still work

### Releasing New Versions
1. Update version in `.claude-plugin/plugin.json`
2. Update `CHANGELOG.md` with changes
3. Create git tag: `git tag v0.2.0`
4. Push: `git push origin main --tags`

## Common Patterns

- Hook receives JSON input via stdin with file paths
- Parses tool output to identify changed files
- Generates diffs and sends to Claude API
- Falls back to simple messages if API unavailable
- Never blocks Claude (always exit 0)
