#!/bin/bash

REPO_URL="https://<token>@github.com/user-name/repo-name.git"
PROJECT_DIR=".git" 
BRANCH="main"

git config --global user.name "user-name"
git config --global user.email "user-email"


if [ -d "$PROJECT_DIR" ]; then
  echo "🔄 Repository already exists. Pulling latest changes..."
  git pull --rebase --autostash origin $BRANCH
  echo "✅ Repository updated!"
else
  echo "📥 Repository not found. Cloning..."
  git clone -b $BRANCH "$REPO_URL" .
  echo "✅ Repository cloned successfully!"
fi



