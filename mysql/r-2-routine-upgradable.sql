SET @routine := 'routine_upgradable';
SET @version := 1;

SELECT
  CASE WHEN (SELECT MAX(version) FROM schema_routine WHERE routine = @routine) >= @version THEN
    schema_upgrade_already_applied()
  ELSE
    NULL
  END INTO @_;

DROP PROCEDURE IF EXISTS routine_upgradable;
DELIMITER //
CREATE PROCEDURE routine_upgradable(name varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci, to_version smallint)
BEGIN
  DECLARE _ TINYINT;

  SELECT
    CASE WHEN (SELECT MAX(version) FROM schema_routine WHERE routine = name) >= to_version THEN
      schema_upgrade_already_applied()
    ELSE
      NULL
    END INTO _;
END//
DELIMITER ;

INSERT INTO schema_routine (routine, version, timestamp)
  VALUES (@routine, @version, UNIX_TIMESTAMP() * 1000);
