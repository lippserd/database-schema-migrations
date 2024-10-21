CREATE OR REPLACE FUNCTION schema_upgrade_already_applied() RETURNS VOID AS $$
BEGIN
  RAISE EXCEPTION 'Schema upgrade already applied.';
END;
$$ LANGUAGE plpgsql;
