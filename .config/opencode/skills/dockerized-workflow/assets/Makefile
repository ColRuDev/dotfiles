.PHONY: up down add sync run sh logs clean

APP  := app
PM   := [package-manager]
RUN  := [run-command]

up:
	docker compose up -d

down:
	docker compose down

stop:
	docker compose stop

add:
	@docker compose exec $(APP) $(PM) add $(filter-out $@,$(MAKECMDGOALS))

sync:
	docker compose exec $(APP) $(PM) sync

run:
	docker compose exec $(APP) $(PM) $(RUN)

sh:
	docker compose run --rm $(APP) sh

logs:
	docker compose logs -f

clean:
	docker compose down -v