---
name: dockerized-workflow
description: >
  Dockerized development workflow with Makefile abstraction.
  Trigger: User wants to isolate dependencies in Docker, use Makefile commands
  instead of docker compose directly, any language/runtime (Python, Node, Go, etc.).
license: Apache-2.0
metadata:
  author: ColRuDev
  version: "1.1"
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

### Port Exposure

Applications that serve HTTP (web servers, dev servers, etc.) must expose their internal port to the host:

| Runtime | Internal Port | Example |
|---------|---------------|---------|
| Astro | 4321 | `4321:4321` |
| Next.js | 3000 | `3000:3000` |
| Vite | 5173 | `5173:5173` |
| Django | 8000 | `8000:8000` |
| Flask | 5000 | `5000:5000` |
| Ruby on Rails | 3000 | `3000:3000` |

The `ports` directive in docker-compose.yml maps container port to host port:

```yaml
ports:
  - 4321:4321  # host:container
```

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
