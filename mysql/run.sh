#!/bin/bash

docker run --rm --name mysql-migrations -e MYSQL_DATABASE=migrations -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -d mysql

docker exec -i mysql-migrations mysql migrations < baseline.sql

for f in r*.sql; do
  docker exec -i mysql-migrations mysql migrations < "$f"
done

for f in [0-9]*.sql; do
  docker exec -i mysql-migrations mysql migrations < "$f"
done
