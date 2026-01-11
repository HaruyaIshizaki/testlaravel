.PHONY: help up down restart logs shell composer-install npm-install npm-dev migrate migrate-fresh migrate-rollback seed tinker test cache-clear route-list

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Docker commands
up: ## Start Docker containers
	docker compose up -d

down: ## Stop Docker containers
	docker compose down

restart: ## Restart Docker containers
	docker compose restart

logs: ## Show Docker logs
	docker compose logs -f

shell: ## Enter app container shell
	docker compose exec app bash

# Composer commands
composer-install: ## Run composer install
	docker compose exec app composer install

composer-update: ## Run composer update
	docker compose exec app composer update

composer-dump: ## Run composer dump-autoload
	docker compose exec app composer dump-autoload

# NPM commands
npm-install: ## Run npm install
	docker compose exec app npm install

npm-dev: ## Run npm dev server
	docker compose exec app npm run dev

npm-build: ## Run npm build
	docker compose exec app npm run build

# Artisan commands
migrate: ## Run database migrations
	docker compose exec app php artisan migrate

migrate-fresh: ## Fresh database migrations (WARNING: destroys data)
	docker compose exec app php artisan migrate:fresh

migrate-fresh-seed: ## Fresh migrations with seeding (WARNING: destroys data)
	docker compose exec app php artisan migrate:fresh --seed

migrate-rollback: ## Rollback last migration
	docker compose exec app php artisan migrate:rollback

seed: ## Run database seeders
	docker compose exec app php artisan db:seed

tinker: ## Start Laravel tinker
	docker compose exec app php artisan tinker

# Testing
test: ## Run PHPUnit tests
	docker compose exec app php artisan test

# Cache commands
cache-clear: ## Clear all caches
	docker compose exec app php artisan cache:clear
	docker compose exec app php artisan config:clear
	docker compose exec app php artisan route:clear
	docker compose exec app php artisan view:clear

optimize: ## Optimize the application
	docker compose exec app php artisan optimize

# Info commands
route-list: ## Show all routes
	docker compose exec app php artisan route:list

# Custom artisan command
artisan: ## Run custom artisan command (usage: make artisan cmd="make:controller FooController")
	docker compose exec app php artisan $(cmd)
