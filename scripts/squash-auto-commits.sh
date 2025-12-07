#!/usr/bin/env bash
#
# squash-auto-commits.sh - Squash all auto-commits into a single commit
#
# This utility helps clean up commit history by squashing all auto-commits
# created by the auto-commit hook into a single meaningful commit.
#
# USAGE:
#   ./scripts/squash-auto-commits.sh [base-branch]
#
# ARGUMENTS:
#   base-branch  - Branch to squash commits from (default: main)
#
# EXAMPLES:
#   ./scripts/squash-auto-commits.sh          # Squash from main
#   ./scripts/squash-auto-commits.sh develop  # Squash from develop
#

set -euo pipefail

# Configuration
BASE_BRANCH="${1:-main}"
AUTO_COMMIT_PATTERN="chore\(.*\): auto-commit"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
info() {
    echo -e "${GREEN}✓${NC} $1"
}

warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
    exit 1
}

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    error "Not in a git repository"
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)

if [ -z "$CURRENT_BRANCH" ]; then
    error "Not on any branch (detached HEAD state)"
fi

# Check if base branch exists
if ! git rev-parse --verify "$BASE_BRANCH" > /dev/null 2>&1; then
    error "Base branch '$BASE_BRANCH' does not exist"
fi

# Check for uncommitted changes
if ! git diff --quiet || ! git diff --cached --quiet; then
    error "You have uncommitted changes. Please commit or stash them first."
fi

# Count auto-commits
AUTO_COMMIT_COUNT=$(git log --oneline "$BASE_BRANCH".."$CURRENT_BRANCH" --grep="$AUTO_COMMIT_PATTERN" --extended-regexp | wc -l | tr -d ' ')
TOTAL_COMMITS=$(git log --oneline "$BASE_BRANCH".."$CURRENT_BRANCH" | wc -l | tr -d ' ')

if [ "$AUTO_COMMIT_COUNT" -eq 0 ]; then
    warn "No auto-commits found to squash"
    exit 0
fi

info "Found $AUTO_COMMIT_COUNT auto-commits out of $TOTAL_COMMITS total commits since $BASE_BRANCH"

# Show auto-commits
echo ""
echo "Auto-commits to be squashed:"
echo "----------------------------"
git log --oneline "$BASE_BRANCH".."$CURRENT_BRANCH" --grep="$AUTO_COMMIT_PATTERN" --extended-regexp --color=always
echo ""

# Check if there are any commits that would be pushed
UNPUSHED_COMMITS=$(git log --oneline "@{upstream}".."$CURRENT_BRANCH" 2>/dev/null | wc -l | tr -d ' ' || echo "0")

if [ "$UNPUSHED_COMMITS" -gt 0 ]; then
    warn "You have $UNPUSHED_COMMITS unpushed commits. Squashing will rewrite history."
    echo -n "Are you sure you want to continue? (y/N) "
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
fi

# Confirm squashing
echo -n "Squash these commits? (y/N) "
read -r response
if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

# Prompt for new commit message
echo ""
echo "Enter a commit message for the squashed commit:"
echo "(Leave empty to use an auto-generated message)"
read -r COMMIT_MESSAGE

# If no message provided, generate one
if [ -z "$COMMIT_MESSAGE" ]; then
    COMMIT_MESSAGE="chore: squash $AUTO_COMMIT_COUNT auto-commits from development session"
fi

# Perform squash using soft reset
info "Squashing commits..."

# Soft reset to base branch (keeps all changes staged)
git reset --soft "$BASE_BRANCH"

# Create new commit with all changes
git commit -m "$COMMIT_MESSAGE"

# Summary
info "Successfully squashed $AUTO_COMMIT_COUNT commits into 1"
echo ""
echo "New commit:"
git log -1 --oneline --color=always
echo ""
info "Your working directory and staged changes are unchanged"
warn "If you had already pushed, you'll need to force push: git push --force-with-lease"
