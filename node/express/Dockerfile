FROM node:22 AS base
WORKDIR /app
COPY package*.json ./
COPY tsconfig.json ./

FROM base as development
ENV NODE_ENV=development

RUN npm install --include=dev

COPY . .

CMD ["npm", "run", "dev"]