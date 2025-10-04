################
## DEVELOPMENT ##
################
FROM node:22 AS development

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3001 

CMD [ "npm", "run", "start:dev" ]


FROM node:22 AS production

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install --only=production

COPY . .
RUN npm run build

EXPOSE 3001

CMD [ "node", "dist/main" ]
