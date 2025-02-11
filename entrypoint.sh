#!/bin/bash

until nc -z -v -w30 $DB_HOST $DB_PORT
do
echo "Waiting for the database service to be available..."
  sleep 1
done

php artisan migrate

exec apache2-foreground