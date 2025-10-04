# CI script :

## Setting the env file

- Create the `.env.test` then Paste

```bash
DATABASE_URL="file:./test.db?mode=memory&cache=shared"
```

## Setting prisma schema file

- Create the `schema.test.prisma` then Paste

```bash
datasource db {
  provider = "sqlite"
  url      = env("DATABASE_URL")
}

generator client {
  provider = "prisma-client-js"
  output   = "../generated/prisma"
}
```

## setting your github init :
```bash
  git init
  git add .
  git commit -m "First Commit"
```

## Generate the branch of dev:
```bash
  git branch dev
  git checkout dev
```

## Run the script :
```bash
  chmod -x CI.sh
  ./CI.sh
```