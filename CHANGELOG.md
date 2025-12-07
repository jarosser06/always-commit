# Changelog

All notable changes to the always-commit plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-12-06

### Added
- Initial plugin release
- Auto-commit hook for Write/Edit/Bash operations
- Dual-mode operation: plugin installation and project-based self-hosting
- Environment variable configuration:
  - `CLAUDE_AUTO_COMMIT_SKIP` - disable auto-commit
  - `CLAUDE_AUTO_COMMIT_ALLOW_MAIN` - allow commits on main branch
  - `CLAUDE_AUTO_COMMIT_USE_AI` - enable AI-generated commit messages
- `/auto-commit-status` command to view commit statistics
- `scripts/squash-auto-commits.sh` utility to clean up commit history
- Plugin manifest for Claude Code plugin system
- Comprehensive documentation and installation instructions

### Features
- Automatic commits after file modifications
- AI-generated commit messages (optional, via Claude Haiku)
- Simple fallback commit messages
- Branch protection (blocks main by default)
- Gitignore pattern respect
- Configurable skip patterns
- Always exits 0 (never blocks Claude operations)
- Self-hosting capability for contributors

### Technical
- Bash script with jq dependency
- Claude Code PostToolUse hook integration
- Compatible with both plugin and project-based installation
- MIT License

[0.1.0]: https://github.com/jarosser06/always-commit/releases/tag/v0.1.0
