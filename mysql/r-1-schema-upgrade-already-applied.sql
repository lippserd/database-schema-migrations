-- Requires MySQL 8.
DELIMITER //
CREATE FUNCTION IF NOT EXISTS schema_upgrade_already_applied() RETURNS tinyint DETERMINISTIC
BEGIN
  SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Schema upgrade already applied.';

  RETURN NULL;
END//
DELIMITER ;
