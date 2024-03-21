SHELL := /bin/bash
MAKEFLAGS += --silent
ARGS = $(filter-out $@,$(MAKECMDGOALS))
UNAME=$(shell uname -s)

export COMPOSE_PROJECT_NAME=my-new-project
export COMPOSER_CACHE=$$(composer config --no-interaction --global cache-dir || echo $$HOME/.cache/composer)
export YARN_CACHE=$$(yarn cache dir || echo $$HOME/.cache/yarn)
export NPM_CACHE=$$(npm config get cache || echo $$HOME/.cache/npm)

docker-compose=COMPOSER_CACHE=${COMPOSER_CACHE} YARN_CACHE=${YARN_CACHE} NPM_CACHE=${NPM_CACHE} docker-compose

.PHONY: help

help: ## Show available Commands
	@awk 'BEGIN {FS = ":.*##"; printf "\033[33mUsage:\033[0m \n make \033[32m<target>\033[0m \033[32m\"<arguments>\"\033[0m\n\n\033[33mAvailable commands:\033[0m \n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[32m%-10s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Docker commands
setup:
	@make up
	@make composer install
	@make console "system:install --create-database --basic-setup"
	@make build-all

up: ## Start Project
	@npm install
	@make verify-hook pre-commit
	$(docker-compose) up -d --remove-orphans --force-recreate
	@make permissions
	@make urls

down: ## Stop and remove containers, networks, volumes and images
	@make stop
	$(docker-compose) down

stop: ## Stop Project
	$(docker-compose) stop

restart: ## Restart all containers
	$(docker-compose) kill $(ARGS)
	@make up

rebuild: ## Rebuild the app container
	$(docker-compose) rm --force app
	$(docker-compose) build
	@make up

state:
	$(docker-compose) ps

logs: ## Get logs from all containers or a specific container e.g make logs frontend
	$(docker-compose) logs -f --tail=100 $(ARGS)

destroy: ## Stop Project
	$(docker-compose) down --rmi all -v

##@ System commands
composer: ## Run composer in the container e.g make composer 'require monolog/monolog'
	$(docker-compose) exec -unobody app composer $(ARGS)

console: ## Run shopware commands
	$(docker-compose) exec -unobody app /app/bin/console $(ARGS)

shell: ## Get Bash of app container
	$(docker-compose) exec -unobody app bash

bash: shell

root: ## Get root Bash of app container
	$(docker-compose) exec app bash

verify-hook: ## Verify symlinking of hook files and create if not exists
	bash ./bin/git-hooks.sh $(ARGS)

permissions:
	$(docker-compose) exec -uroot app chown -R nobody:nobody /tmp
	$(docker-compose) exec -uroot app chown -R nobody:nobody /cache/npm

## Print Project URIs
urls:
	echo "---------------------------------------------------"
	echo "You can access your project at the following URLS:"
	echo "---------------------------------------------------"
	echo ""
	echo "Application:          http://"${COMPOSE_PROJECT_NAME}".docker/"
	echo ""
	echo "---------------------------------------------------"
	echo ""

## Linting
lint: lint-ecs lint-stan

lint-ecs: ## ECS linter
	$(docker-compose) exec -unobody app /app/vendor/bin/ecs check /app/custom/static-plugins

lint-stan:
	$(docker-compose) exec -unobody app /app/vendor/bin/phpstan analyse -c phpstan.neon

## Code fixing
fix-ecs: ## Fix ECS issues
	$(docker-compose) exec -unobody app /app/vendor/bin/ecs check /app/custom/static-plugins --fix

## Playwright
playwright: ## Run playwright tests
	APP_ENV=prod DOMAIN=http://shopware.docker npm run test:headed --prefix app/playwright

##@ Mysql commands
mysql-backup: ## Backup MySQL
	bash ./bin/backup.sh mysql

mysql-restore: ## Restore MySQL
	bash ./bin/restore.sh mysql

##Media commands
media-backup: ## Backup media files
	bash ./bin/backup.sh media

media-restore: ## Restore Media
	bash ./bin/restore.sh media

#############################
# Argument fix workaround
#############################
%:
	@:
