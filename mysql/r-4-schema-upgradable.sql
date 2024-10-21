SET @routine := 'schema_upgradable';
SET @version := 1;

CALL routine_upgradable(@routine, @version);

DROP PROCEDURE IF EXISTS schema_upgradable;
DELIMITER //
CREATE PROCEDURE schema_upgradable(to_version smallint, previous_version smallint)
BEGIN
  DECLARE current_version SMALLINT;
  DECLARE msg VARCHAR(255);
  DECLARE _ TINYINT;

  SELECT MAX(version) INTO current_version FROM schema_history;

  SELECT
    CASE WHEN current_version >= to_version THEN
      schema_upgrade_already_applied()
    ELSE
      NULL
    END INTO _;

  IF previous_version IS NULL THEN
    SET previous_version = to_version - 1;
  END IF;

  IF current_version < previous_version THEN
    SELECT CONCAT(
      'Unexpected latest schema version ',
      current_version,
      '. Expected version ',
      previous_version,
      '. Are all intermediate upgrades applied?'
    ) INTO msg;
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = msg;
  END IF;
END//
DELIMITER ;

CALL upgrade_routine(@routine, @version);
