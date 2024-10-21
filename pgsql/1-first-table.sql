DO $$
DECLARE
  version SMALLINT := 1;
BEGIN
  CALL schema_upgradable(version, NULL);

  CREATE TABLE IF NOT EXISTS first_table (
    id SERIAL PRIMARY KEY
  );

  CALL upgrade_schema(version);
END $$;
