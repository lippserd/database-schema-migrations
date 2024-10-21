\set ON_ERROR_STOP on

DO $$
DECLARE
  current_version SMALLINT;
BEGIN
  SELECT MAX(version) INTO current_version FROM schema_routine WHERE routine = 'routine_upgradable';

  IF current_version >= 1 THEN
    SELECT schema_upgrade_already_applied();
  END IF;
END $$;

CREATE OR REPLACE PROCEDURE routine_upgradable(name VARCHAR, to_version SMALLINT) LANGUAGE plpgsql AS $$
DECLARE
  current_version SMALLINT;
BEGIN
  SELECT MAX(version) INTO current_version FROM schema_routine WHERE routine = name;

  IF current_version >= to_version THEN
    SELECT schema_upgrade_already_applied();
  END IF;
END;
$$;

INSERT INTO schema_routine (routine, version)
  VALUES ('routine_upgradable', 1);
