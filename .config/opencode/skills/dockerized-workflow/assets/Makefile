.PHONY: dev build down add sync sync-host sh logs clean

DOCKER_COMPOSE := docker compose
ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))

APP  := app
PM   := (package_manager)
ADD := (add_command)
DEV_FLAG := (dev_flag)
SYNC := (sync_command)

dev:
	@echo "${USER_ID}:${GROUP_ID}"
	@mkdir -p (generated_dirs)
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

add-dev:
	@$(DOCKER_COMPOSE) exec $(APP) $(PM) $(ADD) $(DEV_FLAG) $(ARGS)
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































