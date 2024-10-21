DO $$
DECLARE
  version SMALLINT := 3;
  previous_version SMALLINT := 4;
BEGIN
  CALL schema_upgradable(version, previous_version);

  CREATE TABLE IF NOT EXISTS third_table (
    id SERIAL PRIMARY KEY
  );

  CALL upgrade_schema(version);
END $$;
