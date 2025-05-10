#!/bin/bash

echo ">>> Entrando al script de arranque para montar las migraciones de la base de datos"

# Esperar a que la base de datos esté disponible
until nc -z db 3306; do
  echo "Esperando a que la base de datos esté disponible..."
  sleep 2
done

# Instalar dependencias
composer install --no-interaction --optimize-autoloader --no-dev

# Ejecutar migraciones
php artisan migrate --force

# Iniciar Apache en primer plano
exec apache2-foreground
