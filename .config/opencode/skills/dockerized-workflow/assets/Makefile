.PHONY: up down add sync run sh logs clean

UID := $(shell id -u)
GID := $(shell id -g)
DOCKER_COMPOSE := UID=$(UID) GID=$(GID) docker compose
ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))

APP  := app
PM   := bun
ADD := add
DEV_FLAG := --dev
SYNC := install
RUN  := run dev

dev:
	$(DOCKER_COMPOSE) up

build: 
	docker build -t app-prod --target runner .

down: 
	$(DOCKER_COMPOSE) down

clean:
	$(DOCKER_COMPOSE) down -v
	rm -rf node_modules

add:
	@$(DOCKER_COMPOSE) exec $(APP) $(PM) $(ADD) $(ARGS)
	@$(MAKE) sync-host

sync:
	$(DOCKER_COMPOSE) exec $(APP) $(PM) $(SYNC)

sync-host:
		$(PM) $(SYNC) --ignore-scripts --frozen-lockfile

sh: 
	$(DOCKER_COMPOSE) exec $(APP) sh

logs:
	$(DOCKER_COMPOSE) logs -f

%:
	@:































