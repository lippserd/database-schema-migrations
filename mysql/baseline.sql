CREATE TABLE schema_history (
  id int unsigned NOT NULL AUTO_INCREMENT,
  version smallint unsigned NOT NULL,
  timestamp bigint unsigned NOT NULL,

  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE schema_routine (
  id int unsigned NOT NULL AUTO_INCREMENT,
  routine varchar(64) COLLATE utf8mb4_unicode_ci,
  version smallint unsigned NOT NULL,
  timestamp bigint unsigned NOT NULL,

  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

INSERT INTO schema_history (version, timestamp)
  VALUES (0, UNIX_TIMESTAMP() * 1000);
