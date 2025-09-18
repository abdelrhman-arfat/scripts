#!/bin/bash

read -p "📝 Enter your commit message: " msg

echo "🔍 Running tests ..."
# Run tests and capture exit code
php artisan test
test_exit_code=$?
# Exit early if tests failed
if [ $test_exit_code -ne 0 ]; then
  echo "❌ Some tests failed! Fix them before committing."
  exit 1
fi
echo "✅ Tests passed!"
# Go to development branch if not already on it
current_branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$current_branch" != "dev" ]; then
  echo "🔁 Switching to development branch..."
  git checkout dev
fi

git pull origin dev

# Check for changes before committing
if [ -n "$(git status --porcelain)" ]; then
  echo "🚀 Committing changes..."
  git add .
  git commit -m "ci: $msg"
  git push origin dev
else
  echo "⚠️ No changes to commit."
fi

read -p "🔄 Do you want to merge development into main? (y/n): " confirm
if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
  git checkout main
  git pull origin  main
  git merge dev -m "merge after '$msg'"
  git push origin  main
  echo "✅ Merged and pushed to main!"
  git checkout dev
else
  echo "ℹ️ Skipped merging to main."
fi