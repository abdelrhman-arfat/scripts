

#!/bin/bash
echo "🔄 Pulling latest changes from main branch..."

git config --global user.name "user-name"
git config --global user.email "user-email"


git remote set-url origin https://<token>@github.com/user-name/repo-name.git

git pull origin main

echo "✅ Latest changes pulled from main branch!"