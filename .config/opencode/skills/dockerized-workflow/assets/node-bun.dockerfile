FROM dhi.io/bun:1-debian13-dev

WORKDIR /app

COPY package.json bun.lockb ./

RUN bun install --frozen-lockfile

COPY . .
