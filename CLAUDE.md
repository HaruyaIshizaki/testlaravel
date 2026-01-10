# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Docker-based Laravel development environment for learning full-stack development. The Laravel application itself is placed in the `src/` directory (which may be empty initially).

## Architecture

### Docker Services

Three main services compose the development environment:

- **app**: PHP 8.3-fpm container running Laravel
  - User: UID/GID 1000 (appuser)
  - Working directory: `/data` (mounted from `./src`)
  - Includes Composer 2.7 and Node.js 24.x
  - Exposes port 5173 for Vite HMR
  - PHP extensions: intl, pdo_mysql, zip, bcmath, gd

- **web**: nginx 1.25-alpine serving as reverse proxy
  - Proxies PHP requests to app:9000 (PHP-FPM)
  - Document root: `/data/public`
  - Port 80 exposed on host

- **db**: MySQL 8.0
  - Port 3306 exposed on host
  - Persistent storage via `db-store` volume
  - Timezone: Asia/Tokyo

### Environment Configurations

- **Development** (`docker-compose.yml`): Full stack including MySQL database
- **Production** (`docker-compose.prod.yml`): Overrides for production (assumes Aurora MySQL instead of local db service)

## Common Commands

### Environment Setup

```bash
# Initial setup
cp .env.example .env
docker-compose up -d

# Check container status
docker-compose ps

# View logs
docker-compose logs -f

# Stop environment
docker-compose down

# Complete teardown (removes database volume)
docker-compose down -v
```

### Initial Laravel Project Setup

If `src/` directory is empty, create a new Laravel project first:

```bash
# Create new Laravel project in src/ directory
docker-compose exec app composer create-project laravel/laravel .

# Generate application key
docker-compose exec app php artisan key:generate

# Verify database connection settings in src/.env
# Should match docker-compose.yml environment variables:
# DB_HOST=db
# DB_DATABASE=laravel
# DB_USERNAME=udemy123
# DB_PASSWORD=pass123

# Run initial migration
docker-compose exec app php artisan migrate
```

### Working with Laravel

All Laravel/Composer/Artisan commands should be executed inside the app container:

```bash
# Enter PHP container
docker-compose exec app bash

# Install Composer dependencies
docker-compose exec app composer install

# Run migrations
docker-compose exec app php artisan migrate

# Run specific Artisan command
docker-compose exec app php artisan <command>
```

### Frontend Development with Vite

When using Tailwind CSS v4 or Vite, configure `vite.config.js` in the Laravel project to expose port 5173:

```js
server: {
  host: "0.0.0.0",
  port: 5173,
  strictPort: true,
  hmr: {
    host: "localhost",
    port: 5173,
  },
}
```

Then run Vite dev server:

```bash
docker-compose exec app npm run dev
```

### Production Deployment

```bash
# Use production compose override
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

Note: Production configuration expects external database (Aurora MySQL) - database credentials should be set via environment variables.

## Access Points

- Application: http://localhost
- Database: localhost:3306
- Vite HMR: localhost:5173

## Important Notes

- The `src/` directory is where the Laravel project resides - it may be empty initially
- All Docker containers run on the `app-network` bridge network
- nginx config at `infra/nginx/default.conf` is configured for standard Laravel routing
- PHP configuration can be customized via `infra/php/php.ini`
- User UID/GID is set to 1000:1000 to match typical development host permissions
