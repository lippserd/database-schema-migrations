SET @version := 3;
CALL schema_upgradable(@version, 4);

CREATE TABLE third_table (
  id int unsigned NOT NULL AUTO_INCREENT,

  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CALL upgrade_schema(@version);
