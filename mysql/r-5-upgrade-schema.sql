SET @routine := 'upgrade_schema';
SET @version := 1;

CALL routine_upgradable(@routine, @version);

DROP PROCEDURE IF EXISTS upgrade_schema;
DELIMITER //
CREATE PROCEDURE upgrade_schema(to_version smallint)
BEGIN
  INSERT INTO schema_history (version, timestamp)
    VALUES (to_version, UNIX_TIMESTAMP() * 1000);
END//
DELIMITER ;

CALL upgrade_routine(@routine, @version);
