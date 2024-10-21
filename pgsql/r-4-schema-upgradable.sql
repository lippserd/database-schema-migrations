\set ON_ERROR_STOP on

CALL routine_upgradable('schema_upgradable'::varchar, 1::smallint);

CREATE OR REPLACE PROCEDURE schema_upgradable(to_version SMALLINT, previous_version SMALLINT) LANGUAGE plpgsql AS $$
DECLARE
  current_version SMALLINT;
BEGIN
  SELECT MAX(version) INTO current_version FROM schema_history;

  IF current_version >= to_version THEN
    PERFORM schema_upgrade_already_applied();
  END IF;

  IF previous_version IS NULL THEN
    previous_version := to_version - 1;
  END IF;

  IF current_version < previous_version THEN
    RAISE EXCEPTION 'Unexpected latest schema version %, expected version %. Are all intermediate upgrades applied?',
      current_version, previous_version;
  END IF;
END;
$$;

CALL upgrade_routine('schema_upgradable'::varchar, 1::smallint);
