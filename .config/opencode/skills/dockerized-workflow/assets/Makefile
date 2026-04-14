.PHONY: up down add sync run sh logs clean

APP  := app
PM   := [package-manager]
ADD := [package-manager-add-command]
DEV_FLAG := [package-manager-dev-flag]
SYNC := [package-manager-sync-command]
RUN  := [run-command]

up:
	docker compose up -d

down:
	docker compose down

stop:
	docker compose stop

add:
	@docker compose exec $(APP) $(PM) $(ADD) $(filter-out $@,$(MAKECMDGOALS))

add-dev:
	@docker compose exec $(APP) $(PM) $(ADD) $(DEV_FLAG) $(filter-out $@,$(MAKECMDGOALS))

sync:
	docker compose exec $(APP) $(PM) $(SYNC)

run:
	docker compose exec $(APP) $(PM) $(RUN)

sh:
	docker compose run --rm $(APP) sh

logs:
	docker compose logs -f

clean:
	docker compose down -v
