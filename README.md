# Always Commit

A Claude Code plugin that automatically commits every file change with optional AI-generated commit messages.

## Features

- ✅ **Auto-commit on every change** - Runs after Write/Edit/Bash tool operations
- 🤖 **AI-generated messages** - Optional: uses Claude Haiku for meaningful commit messages
- 🔒 **Branch protection** - Blocks commits on main branch by default (configurable)
- 📊 **Status command** - View auto-commit statistics with `/auto-commit-status`
- 🧹 **Squash utility** - Clean up commit history with included script
- ✅ **Never blocks Claude** - Always exits successfully to never interrupt workflow

## Installation

### Method 1: Plugin Installation (Recommended)

Install from GitHub in two steps:

```bash
# Add the marketplace
/plugin marketplace add jarosser06/always-commit

# Install the plugin
/plugin install always-commit@jarosser06/always-commit
```

That's it! The hook automatically activates when the plugin is enabled.

### Method 2: Project-Based Installation (For Development/Customization)

Clone the repository and work with it directly:

```bash
git clone https://github.com/jarosser06/always-commit
cd always-commit
# Hook is already configured in .claude/settings.json
# Start using Claude Code in this directory
```

Add to your `~/.zshrc` or `~/.bashrc` to make permanent.

### 4. Restart Claude Code

```bash
# Exit current session and start new one
claude
```

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `CLAUDE_AUTO_COMMIT_USE_AI` | Enable AI-generated commit messages | `false` |
| `ANTHROPIC_API_KEY` | **Required** for AI messages (if enabled) | (none) |
| `CLAUDE_AUTO_COMMIT_ALLOW_MAIN` | Allow commits on main branch | `false` |
| `CLAUDE_AUTO_COMMIT_SKIP` | Disable auto-commit entirely | `false` |

### Examples

```bash
# Enable AI-generated commit messages (requires API key)
export CLAUDE_AUTO_COMMIT_USE_AI=true
export ANTHROPIC_API_KEY="your-api-key"

# Allow commits on main (not recommended)
export CLAUDE_AUTO_COMMIT_ALLOW_MAIN=true

# Temporarily disable
export CLAUDE_AUTO_COMMIT_SKIP=true
```

Add to your `~/.zshrc` or `~/.bashrc` to make permanent.

### Plugin Commands

- `/auto-commit-status` - View statistics and recent auto-commits

### Utility Scripts

- `scripts/squash-auto-commits.sh` - Squash all auto-commits into a single commit

## How It Works

```
1. Claude writes/edits a file
2. PostToolUse hook fires
3. Hook receives JSON with file info via stdin
4. Hook validates:
   - Auto-commit not disabled
   - Not on main branch (unless allowed)
   - File not in skip patterns
   - File has actual changes
5. Hook generates commit message:
   - Sends git diff to Claude Haiku API
   - Receives descriptive commit message
   - Falls back to simple message if API fails
6. Hook commits the file individually
7. Hook exits 0 (success, never blocks)
```

## Files Skipped

The hook automatically skips:

- `.claude/settings.local.json`
- `.git/` internals
- `.drift.yaml`
- `node_modules/`
- `.venv/`, `venv/`
- `__pycache__/`
- `.pytest_cache/`
- `*.pyc`
- `.coverage`, `htmlcov/`
- Any files matching `.gitignore`

## Cost

Using Claude Haiku is very affordable:

- **~$0.0004 per commit** (less than half a penny)
- **~$0.40 per 1,000 commits**
- Example: 50 commits/day × 20 days = **~$0.40/month**

## Example Output

When a file is written:

```
✓ Auto-committed: src/auth.py
  Message: feat(auth): add JWT token validation middleware
```

Example commit messages generated:

```
feat(api): add user authentication endpoints
fix(database): resolve connection timeout issue
docs(readme): update installation instructions
refactor(utils): extract common validation logic
test(auth): add unit tests for login flow
chore(deps): update dependencies
```

## Troubleshooting

### Hook not running

1. Check `.claude/settings.json` has hook configuration
2. Restart Claude Code (hooks load on session start)
3. Verify script is executable: `ls -l .claude/hooks/auto-commit.sh`

### API errors

1. Check API key: `echo $ANTHROPIC_API_KEY`
2. Verify key at https://console.anthropic.com/
3. Hook uses fallback message if API fails (won't block)

### Commits blocked on main

Default behavior. To allow:

```bash
export CLAUDE_AUTO_COMMIT_ALLOW_MAIN=true
```

### Too many commits

Use the included squash utility:

```bash
./scripts/squash-auto-commits.sh

# Or specify base branch
./scripts/squash-auto-commits.sh develop
```

The script will:
- Count and display auto-commits
- Prompt for confirmation
- Create a single squashed commit
- Preserve your working directory

## Security

### API Key

- Never commit `ANTHROPIC_API_KEY`
- Use environment variables
- Store in `.env` (add to `.gitignore`)

### Privacy

- Hook sends git diffs to Anthropic API
- Don't use on sensitive/proprietary code
- Or use `CLAUDE_AUTO_COMMIT_SKIP=true`

## Disabling

### Temporary

```bash
export CLAUDE_AUTO_COMMIT_SKIP=true
```

### Permanent

Remove `hooks` section from `.claude/settings.json` and restart.

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
│   ├── auto-commit.sh       # Main hook script
│   └── squash-auto-commits.sh # Squash utility
├── .claude/                 # For self-hosting development
│   ├── hooks/
│   │   └── auto-commit.sh   # Symlink to scripts/
│   └── settings.json        # Hook configuration
├── README.md                # This file
├── CHANGELOG.md             # Version history
└── LICENSE                  # MIT License
```

## Contributing

This project is structured as both a Claude Code plugin and a self-hosting development environment.

### For Plugin Users
Install via the two-step process above and you're done!

### For Contributors
Clone the repo and the hook will automatically commit your changes as you work:

```bash
git clone https://github.com/jarosser06/always-commit
cd always-commit
# Start making changes - auto-commits will track your work
```

## License

MIT License - see [LICENSE](LICENSE) for details.
