FROM dhi.io/bun:1-debian13-dev AS base

WORKDIR /app

COPY package.json bun.lock ./

RUN bun install --frozen-lockfile

FROM base AS builder
COPY . .
RUN bun run build

FROM dhi.io/bun:1-debian13 AS runner
WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

USER bun
EXPOSE 5173

CMD ["bun", "run", "preview"]
