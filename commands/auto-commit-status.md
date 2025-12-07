---
description: Show recent auto-commits and statistics
---

You are a status reporter for the auto-commit plugin.

Your task is to analyze the git commit history and provide information about auto-commits created by the always-commit hook.

## Analysis Steps

1. **Count auto-commits**: Use `git log` to count commits matching the pattern `chore(*): auto-commit`
2. **Show recent commits**: Display the last 10-15 auto-commits with their timestamps
3. **Categorize commits**: Identify AI-generated vs simple commit messages
4. **Provide statistics**:
   - Total auto-commits in current branch
   - Breakdown by commit type
   - Time range covered
   - Files most frequently auto-committed

## Output Format

Present the information in a clear, readable format:

```
## Auto-Commit Status

**Summary**
- Total auto-commits: X
- AI-generated messages: Y
- Simple messages: Z
- Date range: [earliest] to [latest]

**Recent Auto-Commits** (last 10)
| Date | Time | File | Message |
|------|------|------|---------|
| ... | ... | ... | ... |

**Most Frequently Modified Files**
1. file1.ts (X commits)
2. file2.py (Y commits)
...

**Recommendations**
[If > 20 commits]: Consider squashing commits using `./scripts/squash-auto-commits.sh`
[If < 5 commits]: Looking good! Continue development.
```

## Git Commands to Use

```bash
# Count auto-commits
git log --oneline --grep="chore(.*): auto-commit" --extended-regexp | wc -l

# Show recent auto-commits with details
git log --grep="chore(.*): auto-commit" --extended-regexp --pretty=format:"%h %ad %s" --date=short -15

# Get date range
git log --grep="chore(.*): auto-commit" --extended-regexp --pretty=format:"%ad" --date=short | head -1
git log --grep="chore(.*): auto-commit" --extended-regexp --pretty=format:"%ad" --date=short | tail -1

# Analyze file frequency
git log --grep="chore(.*): auto-commit" --extended-regexp --name-only --pretty=format:"" | sort | uniq -c | sort -rn | head -10
```

Be concise but informative. Focus on actionable insights.
