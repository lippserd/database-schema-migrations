\set ON_ERROR_STOP on

CALL schema_upgradable(2::smallint, NULL);

CREATE TABLE IF NOT EXISTS second_table (
  id SERIAL PRIMARY KEY
);

CALL upgrade_schema(2::smallint);
