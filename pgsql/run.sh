#!/bin/bash

docker run --rm --name pgsql-migrations -e POSTGRES_HOST_AUTH_METHOD=trust -e POSTGRES_DB=migrations -d postgres

docker exec -i pgsql-migrations psql -U postgres migrations < baseline.sql

for f in r*.sql; do
  docker exec -i pgsql-migrations psql -U postgres migrations < "$f"
done

for f in [0-9]*.sql; do
  docker exec -i pgsql-migrations psql -U postgres migrations < "$f"
done
