#!/bin/bash

# Colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
BOLD="\033[1m"
RESET="\033[0m"

printf "📝 ${CYAN}Enter your commit message:${RESET} "
read msg

# generate prisma client باستخدام schema test
npx dotenv -e .env.test -- npx prisma generate --schema=prisma/schema.test.prisma

# push schema test للـ sqlite in-memory
npx dotenv -e .env.test -- npx prisma db push --schema=prisma/schema.test.prisma

# run tests
npm run test

test_exit_code=$?


if [ $test_exit_code -ne 0 ]; then
  printf "${RED}❌ Some tests failed! Fix them before committing.${RESET}\n"
  exit 1
fi
printf "${GREEN}✅ All tests passed!${RESET}\n"

# Detect current branch
current_branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$current_branch" != "dev" ]; then
  printf "${YELLOW}🔁 Switching to development branch...${RESET}\n"
  git checkout dev
fi


# Pull latest changes
printf "${BLUE}⬇️  Pulling latest changes from dev...${RESET}\n"
git pull origin dev


# Check for changes before committing
if [ -n "$(git status --porcelain)" ]; then
  printf "${CYAN}🚀 Staging and committing changes...${RESET}\n"
  git add .
  git commit -m "ci: $msg"
  printf "${GREEN}✅ Commit created successfully!${RESET}\n"
  git push origin dev
  printf "${GREEN}⬆️  Pushed to dev branch!${RESET}\n"
else
  printf "${YELLOW}⚠️  No changes to commit.${RESET}\n"
fi


# Ask for merge confirmation
printf "🔄 ${BOLD}Do you want to merge development into main? (y/n):${RESET} "
read confirm
if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
  printf "${YELLOW}🔀 Switching to main branch...${RESET}\n"
  git checkout main
  git pull origin main
  printf "${CYAN}🔄 Merging dev into main...${RESET}\n"
  git merge dev -m "merge after '$msg'"
  git push origin main
  printf "${GREEN}✅ Successfully merged and pushed to main!${RESET}\n"
  git checkout dev
else
  printf "${BLUE}ℹ️ Skipped merging to main.${RESET}\n"
fi
