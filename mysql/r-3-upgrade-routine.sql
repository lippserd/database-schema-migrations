SET @routine := 'upgrade_routine';
SET @version := 1;

CALL routine_upgradable(@routine, @version);

DROP PROCEDURE IF EXISTS upgrade_routine;
DELIMITER //
CREATE PROCEDURE upgrade_routine(name varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci, to_version smallint)
BEGIN
  INSERT INTO schema_routine (routine, version, timestamp)
    VALUES (name, to_version, UNIX_TIMESTAMP() * 1000);
END//
DELIMITER ;

CALL upgrade_routine(@routine, @version);
