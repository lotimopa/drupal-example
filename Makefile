FIG=docker compose
EXEC=$(FIG) exec
.DEFAULT_GLOBAL=help
.PHONY: test vendor
SHELL := /bin/bash

ifneq (,$(wildcard ./.env))
	include .env
	export $(shell sed 's/=.*//' .env)
endif

help:
	@grep -E '(^([a-zA-Z_-]+ ?)+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {sub(/^[^:]*:/, "", $$0); printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

##
## —— Utils ⚙️ ————————————————————————————————————————————————————————————————
install: vendor drupal-install ## Install the project

start: copy-files ## Start the project
	$(FIG) up --build -d

stop: ## Stop the project
	$(FIG) down

##
## —— Dependencies 📁 ————————————————————————————————————————————————————————————————
vendor: composer.lock ## Install php dependencies
	$(EXEC) php composer install -o

##
## —— Drupal 🐳 ————————————————————————————————————————————————————————————————
uuid:
	$(EXEC) php composer drupal-uuid

drupal-install: ## Install Drupal
	$(EXEC) php vendor/bin/drush site:install minimal -y --account-name=${INSTALL_ACCOUNT_NAME} --account-pass=${INSTALL_ACCOUNT_PASS} --account-mail=${INSTALL_ACCOUNT_MAIL} --existing-config

clear: ## Clear the cache
	$(EXEC) php vendor/bin/drush cr

login:
	$(EXEC) php vendor/bin/drush uli

config-import: ## Import the config
	$(EXEC) php vendor/bin/drush config:import -y

config-export: ## Export the config
	$(EXEC) php vendor/bin/drush config:export -y

pull:
	git pull
	$(EXEC) php composer install -o
	$(EXEC) php vendor/bin/drush updatedb -y
	$(EXEC) php vendor/bin/drush config:import -y
	$(EXEC) php vendor/bin/drush locale:check
	$(EXEC) php vendor/bin/drush locale:update
	$(EXEC) php vendor/bin/drush cache:rebuild

fixtures: ## Creating fixtures
	@echo "🖼️ Creating fixtures"
	$(EXEC) php vendor/bin/drush fixtures:unload all
	$(EXEC) php vendor/bin/drush fixtures:load all

##
## —— Tests 📊 ————————————————————————————————————————————————————————————————
tests: ## Launch tests
	@echo "🧪 Running tests"
	$(EXEC) php composer tests

phpcs:
	@echo "🔎 Running phpcs"
	$(EXEC) php ./vendor/bin/phpcs --standard=vendor/drupal/coder/coder_sniffer/Drupal/ruleset.xml --extensions=php,module,inc,install,test,profile,theme,css,info,txt,md,yml web/modules/custom/* --ignore=*/tests/*,web/modules/custom/*.info.yml
	$(EXEC) php ./vendor/bin/phpcs --exclude=DrupalPractice.General.DescriptionT --standard=vendor/drupal/coder/coder_sniffer/DrupalPractice/ruleset.xml --extensions=php,module,inc,install,test,profile,theme,css,info,txt,md,yml web/modules/custom/* --ignore=*/tests/*,web/modules/custom/*.info.yml

##
## —— Configuration ⚙️ ————————————————————————————————————————————————————————————————
copy-files: compose.override.yml .env web/sites/default/settings.php ## Configure project

compose.override.yml: compose.override.yml.dist
	cp compose.override.yml.dist compose.override.yml

.env: .env.dist
	cp --update=none .env.dist .env
	@sed -i "s/^APP_USER_ID=.*/APP_USER_ID=$(shell id -u)/" .env
	@sed -i "s/^APP_GROUP_ID=.*/APP_GROUP_ID=$(shell id -g)/" .env

web/sites/default/settings.php: web/sites/default/default.settings.php
	cp --update=none web/sites/default/default.settings.php web/sites/default/settings.php
