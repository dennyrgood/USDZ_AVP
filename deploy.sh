#!/bin/bash

# This script automates the process of adding, committing, and pushing changes to your Git repository.
# It's useful for quickly deploying updates to platforms like GitHub Pages, Netlify, or Vercel.

# Define the branch you want to push to (commonly 'main' or 'master')
GIT_BRANCH="main"

# Set the default commit message
COMMIT_MESSAGE="Updated content"

echo "--- Starting Git Deployment ---"
echo "Adding all changes to Git staging area..."
git add .

# Check if there are any changes to commit
if git diff --cached --quiet; then
  echo "No changes to commit. Exiting."
  exit 0
fi

# Step 2: Commit the changes
echo "Committing changes with message: \"$COMMIT_MESSAGE\""
git commit -m "$COMMIT_MESSAGE"

# Step 3: Push the changes to the remote repository
echo "Pushing changes to $GIT_BRANCH branch on GitHub..."
git push origin "$GIT_BRANCH"

# Check the exit status of the git push command
if [ $? -eq 0 ]; then
  echo "--- Git Deployment Successful! ---"
  echo "Your changes should now be deploying to your live site."
else
  echo "--- Git Deployment Failed! ---"
  echo "Please check the error messages above. You might need to authenticate (e.g., with a Personal Access Token)."
fi

echo "-------------------------------"
