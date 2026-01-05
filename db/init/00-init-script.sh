#!/bin/bash
set -e

echo "Running init scripts..."

for file in /docker-entrypoint-initdb.d/*.sql.template; do
    echo "Executing $file"
    envsubst < "$file" | psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB"
done