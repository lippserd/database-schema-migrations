\set ON_ERROR_STOP on

CALL routine_upgradable('upgrade_schema'::varchar, 1::smallint);

CREATE OR REPLACE PROCEDURE upgrade_schema(to_version SMALLINT) LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO schema_history (version)
    VALUES (to_version);
END;
$$;

CALL upgrade_routine('upgrade_schema'::varchar, 1::smallint);
