---
name: dockerized-workflow
description: >
  Dockerized development workflow with Makefile abstraction.
  Trigger: User wants to isolate dependencies in Docker, use Makefile commands
  instead of docker compose directly, any language/runtime (Python, Node, Go, etc.).
license: Apache-2.0
metadata:
  author: ColRuDev
  version: "1.0"
---

## When to Use

- Starting a new project and wanting Docker isolation from day one
- Existing project needs Dockerized dependencies
- User wants to run `make up`, `make add <pkg>`, `make run` instead of `docker compose exec`
- Any language: Python (uv), Node (pnpm, bun, npm), Go, Ruby, Rust

## Critical Patterns

### Detection Logic

The skill must detect runtime and package manager in this order:

```
if pyproject.toml        → Python + uv
else if package.json + pnpm-lock.yaml  → Node + pnpm
else if package.json + bun.lockb       → Node + bun
else if package.json                     → Node + npm (fallback)
else if go.mod         → Go + go
else if Gemfile        → Ruby + bundle
else if Cargo.toml     → Rust + cargo
```

### Project Structure

```
project/
├── Dockerfile           # Runtime + package manager installed
├── docker-compose.yml   # Volume for .venv/node_modules/.bin
├── Makefile            # Abstractions for docker compose commands
└── [project files]
```

### Volume Strategy

- **Python**: Named volume for `.venv` — dependencies isolated, not visible locally
- **Node**: Named volume for `node_modules` and `.bin` — keeps local clean, allows fast installs
- **Go/Ruby/Rust**: Named volume for cache dirs

### Key Rules

1. **Never run package manager on host** — always `docker compose exec app <pm> <cmd>`
2. **Code is always a bind mount** — local edits available inside container instantly
3. **Use named volumes for dependency dirs** — prevents local pollution and ensures isolation
4. **Makefile commands are identical regardless of runtime** — only the underlying `<pm>` changes

## Commands (Makefile targets)

All runtimes support these Makefile targets:

```makefile
.PHONY: up down add sync run sh logs clean

up     → docker compose up -d           # Start in background
down   → docker compose down             # Stop and remove
stop   → docker compose stop             # Stop without removing
add    → docker compose exec app <pm> add # Add dependency(ies)
sync   → docker compose exec app <pm> sync # Install all deps
run    → docker compose exec app <pm> run # Run main script/binary
sh     → docker compose run --rm app sh  # Interactive shell
logs   → docker compose logs -f          # Follow logs
clean  → docker compose down -v           # Remove volumes too
```

## Runtime-Specific Dockerfile Templates

### Python + uv

```dockerfile
FROM python:3.14-slim
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uv/bin/uv
ENV PATH="/uv/bin:$PATH"
WORKDIR /app
COPY pyproject.toml ./
RUN uv sync --no-dev
COPY . .
```

### Node + pnpm

```dockerfile
FROM node:24-alpine
RUN npm install -g pnpm
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile
COPY . .
```

### Node + bun

```dockerfile
FROM oven/bun:1-alpine
WORKDIR /app
COPY package.json bun.lockb ./
RUN bun install --frozen-lockfile
COPY . .
```

### Node + npm

```dockerfile
FROM node:22-alpine
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
```

### Go

```dockerfile
FROM golang:1.23-alpine
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
```

### Ruby

```dockerfile
FROM ruby:3.3-alpine
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
```

### Rust

```dockerfile
FROM rust:1.75-alpine
WORKDIR /app
COPY Cargo.toml ./
RUN cargo build --release
COPY . .
```

## docker-compose.yml Template

```yaml
services:
  app:
    build: .
    volumes:
      - .:/app
      - [name]:/app/[dep-dir]
    command: [start-cmd]

volumes:
  [name]:
```

Where `[start-cmd]` by runtime:

- Python: `uv run python main.py`
- Node (pnpm/bun/npm): `pnpm dev` / `bun dev` / `npm run dev`
- Go: `go run main.go`
- Ruby: `bundle exec ruby main.rb`
- Rust: `cargo run`

## Makefile Template

```makefile
.PHONY: up down add sync run sh logs clean
APP := app
PM := [package-manager]
RUN := [run-command]

up:    docker compose up -d
down:  docker compose down
stop:  docker compose stop

add:
 @docker compose exec $(APP) $(PM) add $(filter-out $@,$(MAKECMDGOALS))
sync:  docker compose exec $(APP) $(PM) sync
run:   docker compose exec $(APP) $(PM) $(RUN)

sh:    docker compose run --rm $(APP) sh
logs:  docker compose logs -f
clean: docker compose down -v
```

## Workflow

1. **Scan project** — detect runtime and package manager
2. **Generate Dockerfile** — using the correct template
3. **Generate docker-compose.yml** — with proper volume strategy
4. **Generate Makefile** — with runtime-specific PM and RUN commands
5. **Build initial image** — `docker compose build`

## Resources

- **Python/uv template**: See [assets/python-uv.dockerfile](assets/python-uv.dockerfile)
- **Node/pnpm template**: See [assets/node-pnpm.dockerfile](assets/node-pnpm.dockerfile)
- **Node/bun template**: See [assets/node-bun.dockerfile](assets/node-bun.dockerfile)
- **Go template**: See [assets/go.dockerfile](assets/go.dockerfile)
- **Ruby template**: See [assets/ruby.dockerfile](assets/ruby.dockerfile)
- **Rust template**: See [assets/rust.dockerfile](assets/rust.dockerfile)
- **docker-compose template**: See [assets/docker-compose.yml](assets/docker-compose.yml)
- **Makefile template**: See [assets/Makefile](assets/Makefile)

