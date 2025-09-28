#!/bin/bash

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
CYAN="\033[0;36m"
NC="\033[0m" # Reset

echo -e "${CYAN}🚀 Node.js Project Starter${NC}"

read -p "📂 Enter the name of the project: " project_name

echo -e "${YELLOW}➡️ Generating main folder...${NC}"
mkdir -p "$project_name"
cd "$project_name" || exit
echo -e "${GREEN}✅ Main folder [$project_name] generated${NC}"

echo -e "${YELLOW}➡️ Initializing Git...${NC}"
git init
echo -e "${GREEN}✅ Git repo initialized${NC}"


# package.json
echo -e "${YELLOW}➡️ Initializing package.json...${NC}"
npm init -y 
echo -e "${GREEN}✅ package.json generated${NC}"

# set scripts
echo -e "${YELLOW}➡️ Setting scripts...${NC}"

echo -e "${GREEN}✅ Scripts set${NC}"

# dev deps
echo -e "${YELLOW}➡️ Installing ts-node nodemon concurrently...${NC}"
npm install --save-dev ts-node nodemon concurrently
echo -e "${GREEN}✅ Installed: ts-node nodemon concurrently${NC}"

# main libs (array)
default_libs=(express bcryptjs cookie-parser cors dotenv express-validator helmet)
echo -e "${YELLOW}➡️ Installing default libraries...${NC}"
for lib in "${default_libs[@]}"; do
  echo -e "${CYAN}📦 Installing: $lib...${NC}"
  npm install "$lib"
  echo -e "${GREEN}✅ Installed: $lib${NC}"
done

# user libs (array)
echo -e "${CYAN}📦 Enter extra libraries you want to install (space-separated, leave empty to skip):${NC}"
read -a user_libs
if [ ${#user_libs[@]} -gt 0 ]; then
  for lib in "${user_libs[@]}"; do
    echo -e "${CYAN}📦 Installing: $lib...${NC}"
    npm install "$lib"
    echo -e "${GREEN}✅ Installed: $lib${NC}"
  done
fi

# tsconfig.json
echo -e "${YELLOW}➡️ Installing TypeScript and generating tsconfig.json...${NC}"
npm install typescript --save-dev
npx tsc --init 
echo -e "${GREEN}✅ tsconfig.json generated${NC}"

# Docker files
for file in docker-compose.yml Dockerfile docker-compose.dev.yml docker-compose.prod.yml .gitignore nodemon.json eslint.config.js scripts.json .env; do
  echo -e "${YELLOW}➡️ Creating $file...${NC}"
  touch "$file"
  echo -e "${GREEN}✅ $file created${NC}"
done

# .gitignore
echo -e "${YELLOW}➡️ updating .gitignore...${NC}"
echo 'node_modules/
dist/
.env
*.log
' > .gitignore
echo -e "${GREEN}✅ .gitignore updated${NC}"

# scripts.json
echo -e "${YELLOW}➡️ updating scripts.json...${NC}"
echo '{
  "scripts": {
    "db:push": "npx prisma db push",
    "db:generate": "npx prisma generate",
    "build": "tsc",
    "start": "node dist/index.js",
    "build-and-start": "npm run db:push && npm run db:generate && npm run build && npm run start",
    "dev": "concurrently \"tsc --watch\" \"nodemon dist/index.js\"",
    "logs": "docker logs backend-backend-1 -f",
    "bash": "docker exec -it backend-backend-1 bash",
    "dev:docker": "docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d",
    "down:docker": "docker-compose -f docker-compose.yml -f docker-compose.dev.yml down",
    "build:docker": "docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build",
    "start:worker": "npx tsx src/worker/email.worker.ts"
  }
}' > scripts.json
echo -e "${GREEN}✅ scripts.json updated${NC}"

# eslint
echo -e "${YELLOW}➡️ updating eslint.config.js...${NC}"
echo '
import globals from "globals";
import pluginJs from "@eslint/js";
/** @type {import("eslint").Linter.Config[]} */
export default [
  { languageOptions: { globals: globals.browser } },
  pluginJs.configs.recommended,
];' > eslint.config.js
echo -e "${GREEN}✅ eslint.config.js updated${NC}"

# Dockerfile
echo '
FROM node:22 AS base
WORKDIR /app
COPY package*.json ./
COPY tsconfig.json ./

FROM base as production
ENV NODE_ENV=production
RUN npm install --omit=dev
COPY . .
CMD ["node", "dist/index.js"]

FROM base as development
ENV NODE_ENV=development
RUN npm install --include=dev
COPY . .
CMD ["npm", "run", "dev"]
' > Dockerfile

# nodemon.json
echo '{
  "watch": ["dist"],
  "ext": "js",
  "exec": "node dist/index.js"
}' > nodemon.json

# tsconfig.json override
echo '{
  "compilerOptions": {
    "target": "ESNext",
    "module": "ESNext",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "moduleResolution": "Node",
    "allowSyntheticDefaultImports": true,
    "resolveJsonModule": true,
    "allowJs": true,
    "noImplicitAny": false
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules"]
}' > tsconfig.json

# src structure
echo -e "${YELLOW}➡️ Generating src structure...${NC}"
mkdir -p src/{utils,services,constants,controllers,models,routes,middleware,validations,tests,worker}
touch src/index.ts
echo -e "${GREEN}✅ src structure with index.ts created${NC}"

cd src
cd utils
echo -e "${YELLOW}➡️ Creating utils structure...${NC}"
touch jsonStander.ts
echo '
import { Response } from "express";
/**
 * @param data
 * @param status
 * @param message
 * @param error
 * @returns json with status , message , data and error
 */
export const jsonStandard = (
  data: any,
  status: number,
  message: string,
  error?: any
) => {
  return {
    data,
    status,
    message,
    error: error || null,
  };
};

export const setResponse = (
  res: Response,
  {
    data,
    pages = 1,
  }: {
    data: any;
    pages?: number;
  },
  status: number,
  message: string
): Response => {
  const responseData = { data, pages };
  return res.status(status).json(jsonStandard(responseData, status, message));
};
' > jsonStander.ts

touch AsyncWrapper.ts
echo '
import { jsonStandard } from "./jsonStander.js";
export const asyncWrapper =
  (func: any) => async (req: any, res: any, next: any) => {
    try {
      await func(req, res, next);
    } catch (err) {
      const error = err as Error;
      console.log("error", error);
      const ErrorMessage = JSON.stringify(error.message);
      console.log("error message", ErrorMessage);
      return res
        .status(500)
        .json(jsonStandard(null, 500, "Internal Server Error", ErrorMessage));
    }
  };
' > AsyncWrapper.ts

echo -e "${GREEN}✅ AsyncWrapper.ts created${NC}"

cd ..
cd middleware
touch validationMiddleware.ts
echo '
import { NextFunction, Request, Response } from "express";
import { validationResult } from "express-validator";
import { jsonStandard, setResponse } from "../utils/jsonStander.js";

export const validationMiddleware = (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res
      .status(400)
      .json(jsonStandard(null, 400, "Validation error", errors.array()[0].msg));
  }
  next();
};
' > validationMiddleware.ts

echo -e "${GREEN}✅ validationMiddleware.ts created${NC}"

cd .. # back to src
cd .. # back to root

echo '
APP_ENV= development
APP_PORT= 4000
APP_NAME= backend
APP_URL= http://localhost:4000
JWT_SECRET= 
RABBITMQ_HOST= rabbitmq
RABBITMQ_PORT= 5672
RABBITMQ_USER= guest
RABBITMQ_PASSWORD= guest
REDIS_HOST= redis
REDIS_PORT= 6379
REDIS_PASSWORD= 
DATABASE_URL= 
DATABASE_USER= 
DATABASE_PASSWORD= 
DATABASE_HOST= 
DATABASE_PORT= 
DATABASE_NAME= 
' > .env

cd src
cd constants
touch env.ts
echo '
import dotenv from "dotenv";
dotenv.config();
export const ENV = {
  APP_ENV: process.env.APP_ENV,
  APP_PORT: process.env.APP_PORT,
  APP_NAME: process.env.APP_NAME,
  APP_URL: process.env.APP_URL,
  JWT_SECRET: process.env.JWT_SECRET,
  RABBITMQ_HOST: process.env.RABBITMQ_HOST,
  RABBITMQ_PORT: process.env.RABBITMQ_PORT,
  RABBITMQ_USER: process.env.RABBITMQ_USER,
  RABBITMQ_PASSWORD: process.env.RABBITMQ_PASSWORD,
  REDIS_HOST: process.env.REDIS_HOST,
  REDIS_PORT: process.env.REDIS_PORT,
  REDIS_PASSWORD: process.env.REDIS_PASSWORD,
  DATABASE_URL: process.env.DATABASE_URL,
  DATABASE_USER: process.env.DATABASE_USER,
  DATABASE_PASSWORD: process.env.DATABASE_PASSWORD,
  DATABASE_HOST: process.env.DATABASE_HOST,
  DATABASE_PORT: process.env.DATABASE_PORT,
  DATABASE_NAME: process.env.DATABASE_NAME,
};
' > env.ts
echo -e "${GREEN}✅ env.ts created${NC}"

cd .. # back to src
cd .. # back to root

# git
echo -e "${YELLOW}➡️ Initializing Git...${NC}"
git add .
git commit -m "Generate folder structure"
git branch dev
echo -e "${GREEN}✅ Git repo initialized on 'dev' branch${NC}"

echo -e "${CYAN}🎉 Project [$project_name] setup completed successfully!${NC}"
