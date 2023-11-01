#!/bin/bash

# squash-rebase.sh

# don't forget to make this executable 
# chmod +x squash-rebase.sh

# add this to your git aliases (~/.gitconfig)
# [alias]
#       sr = "!/path/to/this/script/squash-rebase.sh"

# Check if the number of commits is provided
if [ -z "$1" ]; then
    echo "Usage: git-rebase-alias.sh <number_of_commits_to_squash>"
    exit 1
fi

# 1. Save the current branch name for later use
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
TEMP_BRANCH="temp-$CURRENT_BRANCH"

# Create a copy of the current branch
git branch "$TEMP_BRANCH"

# 2. Reset X number of commits, and then recommit them as a single commit
git reset HEAD~$1

# Prompt the user for a commit message
echo "Enter a commit message: "
read COMMIT_MESSAGE
git add -A
git commit -nm "$COMMIT_MESSAGE"

# 3. Store the commit hash for later use
COMMIT_HASH=$(git rev-parse HEAD)

# 4. Checkout main and fetch
git checkout main
git fetch

# 5. Delete the original branch
git branch -D "$CURRENT_BRANCH"

# 6. Create a new branch based on main
git checkout -b "$CURRENT_BRANCH"

# 7. Cherry-pick the stored commit hash onto the newly created branch
git cherry-pick "$COMMIT_HASH"

# 8. Force push the new branch and set the upstream to the original branch name
git push -u --force origin "$CURRENT_BRANCH"

# 9. Delete the temporary branch
git branch -D "$TEMP_BRANCH"
