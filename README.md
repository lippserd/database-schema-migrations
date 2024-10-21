# Database Schema Migrations

This proof of concept outlines a comprehensive approach to database migrations, emphasizing the following key principle:

Migrations are either repeatable or sequentially numbered, ensuring they are applied in order.
These migrations are self-contained **pure SQL scripts** that can be executed safely,
even multiple times, either manually or programmatically.

The following sections elaborate on this concept.

### Migration Scripts

  - Migration scripts define changes to the database schema,
    including modifications to routines such as functions, procedures, and triggers.
  - These scripts are written using **pure SQL**.
  - Migration scripts are categorized as either **versioned** or **repeatable**.
  - Versioned migration scripts primarily involve changes to tables.
  - They adhere to a naming convention like `1-description.sql`,
    where `1` represents the version number and `description` provides a brief overview of the migration,
    e.g., `1-sla-index.sql`.
  - Versioned migration scripts can specify a previous version that must be applied before the current script.
    By default, this is the target version minus one, but specifying it allows for optional versioned migrations.
  - Repeatable migration scripts focus on changes to routines and
    are named with an `r` prefix followed by a description, such as `r-calc-sla.sql`.
  - Versioned migration scripts **must** be applied sequentially.
  - The same versioned migration script **should not** be reapplied.
  - Repeatable migration scripts **can** be executed multiple times.
  - However, unchanged repeatable migration scripts **should not** be reapplied.

**Why pure SQL Migration Scripts?**

Utilizing pure SQL for migration scripts offers several advantages:

  - SQL provides direct access to database-specific features and optimizations.
  - SQL scripts can be fine-tuned for performance, leveraging native database capabilities.
  - Developers and database administrators are typically proficient in SQL.
  - SQL scripts can be executed directly within database management tools without additional processing or conversion.
  - Writing in SQL grants precise control over the commands and operations performed on the database.
  - SQL scripts are easier to debug and test independently using standard database tools.

### Tracking

  - A dedicated table (e.g., `schema_history`) is established in the database to
    monitor which versioned migrations have been executed.
  - Another table (e.g., `schema_routine`) tracks the application of repeatable migrations,
    recording the routine name and version.
  - These tables log the version and timestamp of each applied migration.

### Execution

Repeatable migrations are executed before versioned migrations, following a natural sort order.

**Both types of migration scripts determine their applicability by consulting the tracking tables**:

  - Versioned migration scripts are applicable if the current schema version is lower than the target version and
    matches the expected previous version specified in the migration script.
  - Repeatable migrations are applicable if the current version is lower than the target version.

If a migration script is not applicable, it exits early with a clear error message, leaving the schema unchanged.

**Applicable migration scripts are responsible for updating the tracking tables**.

## Conclusion

Given the above considerations, it is safe to apply all migration scripts multiple times,
whether manually or programmatically. However, from a programmatic perspective,
it is logical to apply only pending migrations. For versioned migrations,
it is straightforward to apply only scripts with a higher version number than the current version.
Repeatable migrations present a challenge as they do not include version numbers in their filenames.
Some tools address this by comparing checksums, i.e. if the content of a repeatable migration changes, it is reapplied.
This approach also requires database queries, as it is the case with our approach.
There is also no significant bandwidth concern since programmatically,
migration scripts are executed statement by statement, stopping upon encountering an error.
However, to implement programmatic checksum checks, we could consider the following steps:

  - Add a `checksum` column to the `schema_routine` table.
  - Ensure that repeatable migrations include the routine name as their description.
  - Compute the target checksum.
  - Retrieve the current checksum from the `schema_routine` table by selecting it based on the maximum version and
    the routine name derived from the filename.
  - If the current checksum is null or differs from the target checksum, execute the repeatable migration.
  - Update the checksum for the routine, filtered by the maximum version.

We could consider not maintaining version numbers for repeatable migrations,
as executing them multiple times manually is not an issue.
This approach would simplify the repeatable migration scripts and also reduce complexity for
programmatic execution of a repeatable migration only when its content has changed.

Please note that optional versioned migrations have not been addressed yet.

## Database Functions and Procedures

### Function: `schema_upgrade_already_applied`

This function raises an error with the message "Schema upgrade already applied.".
It is used to prevent the reapplication of the same schema upgrade.

### Procedure: `routine_upgradable`

This procedure checks if a routine can be upgraded to a specified version.
It accepts the name of the routine and the target version for the upgrade as parameters.

The upgrade check is performed as follows:

- It compares the current maximum version of the routine in the `schema_routine` table with the provided target version.
- If the current routine version is greater than or equal to the target version,
  it calls `schema_upgrade_already_applied`.
- It inserts the routine name, version, and timestamp into the `schema_routine` table.

### Procedure: `upgrade_routine`

This procedure upgrades a routine to a specified version.
It takes the name of the routine and the target version as parameters.
The upgrade is executed by inserting the routine name, version, and timestamp into the `schema_routine` table.

### Procedure: `schema_upgradable`

This procedure checks if the schema can be upgraded to a specified version.
It accepts the target version for the schema upgrade and the expected previous version before the upgrade as arguments.
If `NULL` is provided for the previous version, it defaults to the target version minus one.

The upgrade check is done as follows:

- It retrieves the current maximum version from the `schema_history` table.
- If the current version is greater than or equal to the target version, it calls `schema_upgrade_already_applied`.
- It verifies that the current version matches the `previous_version`,
  raising an error if not, to ensure intermediate upgrades are applied.

### Procedure: `upgrade_schema`

This procedure upgrades the schema to a specified version.
It takes the target version for the schema upgrade as an argument.
The upgrade is performed by inserting a new entry into the `schema_history` table with
the specified target version and the current timestamp.
