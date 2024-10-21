\set ON_ERROR_STOP on

CALL routine_upgradable('upgrade_routine'::varchar, 1::smallint);

CREATE OR REPLACE PROCEDURE upgrade_routine(name VARCHAR, to_version SMALLINT) LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO schema_routine (routine, version)
    VALUES (name, to_version);
END;
$$;

CALL upgrade_routine('upgrade_routine'::varchar, 1::smallint);
