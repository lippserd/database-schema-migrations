SET @version := 2;
CALL schema_upgradable(@version, null);

CREATE TABLE second_table (
  id int unsigned NOT NULL AUTO_INCREMENT,

  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CALL upgrade_schema(@version);
