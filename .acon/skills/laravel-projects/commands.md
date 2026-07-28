# Laravel & Filament Command Reference

Quick command cheat sheet for managing Laravel 13.x and Filament 5.x projects.

---

## 1. Package Management (Composer & NPM)

```bash
# Install PHP dependencies
composer install

# Add a new composer package
composer require vendor/package

# Install JS dependencies
npm install

# Run Vite dev server
npm run dev

# Build production assets
npm run build
```

---

## 2. Laravel Artisan Commands

```bash
# Key generation & caching
php artisan key:generate
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan optimize:clear

# Migrations & Database
php artisan migrate
php artisan migrate:fresh --seed
php artisan db:seed

# Code Generation
php artisan make:controller Api/V1/UserController --api
php artisan make:model Post -mfs # Model with Migration, Factory, Seeder
php artisan make:request StoreUserRequest
php artisan make:resource UserResource
php artisan make:job ProcessPodcast
php artisan make:action CreateUserAction # If using spatie/laravel-actions or custom actions

# Routing & Queues
php artisan route:list
php artisan queue:work
php artisan queue:listen
```

---

## 3. Filament v5.x Commands

```bash
# Install Filament
php artisan filament:install --panels

# Create Filament Admin Resources & Pages
php artisan make:filament-resource User --generate
php artisan make:filament-page Settings
php artisan make:filament-widget StatsOverview --stats
php artisan make:filament-user

# Filament Asset & Theme Commands
php artisan filament:assets
php artisan filament:upgrade
```

---

## 4. Testing & Code Quality (Pest & Pint)

```bash
# Run Pest test suite
./vendor/bin/pest

# Run parallel tests
php artisan test --parallel

# Run code style formatting (Laravel Pint)
./vendor/bin/pint
```
