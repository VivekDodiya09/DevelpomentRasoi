require("dotenv").config();
const fs = require("fs");
const path = require("path");
const { getMySqlPromiseConnection } = require("../config/mysql.db");

/**
 * Migration runner to execute SQL migration files
 */
async function runMigrations() {
  const conn = await getMySqlPromiseConnection();

  try {
    console.log("Starting database migrations...");

    // List of migration files to run in order
    const migrationFiles = [
      "create_all_tables.sql",
      "create_missing_tables.sql"
    ];

    for (const file of migrationFiles) {
      const filePath = path.join(__dirname, file);
      console.log(`Running migration: ${file}`);

      const sql = fs.readFileSync(filePath, "utf8");

      // Split by semicolon and execute each statement
      const statements = sql.split(";").filter(stmt => stmt.trim().length > 0);

      for (const statement of statements) {
        if (statement.trim()) {
          try {
            await conn.query(statement);
          } catch (error) {
            // Log but continue for CREATE TABLE IF NOT EXISTS
            if (!error.message.includes("already exists")) {
              console.error(`Error executing statement: ${statement.trim().substring(0, 50)}...`);
              console.error(error.message);
            }
          }
        }
      }

      console.log(`✓ Migration ${file} completed`);
    }

    // Run the fix_missing_columns.js migration
    console.log("Running fix_missing_columns migration...");
    const { runMigration } = require("./fix_missing_columns");
    await runMigration();
    console.log("✓ fix_missing_columns migration completed");

    console.log("All migrations completed successfully!");
  } catch (error) {
    console.error("Migration failed:", error);
    throw error;
  } finally {
    conn.release();
  }
}

// Run migrations if this script is executed directly
if (require.main === module) {
  runMigrations()
    .then(() => {
      console.log("Migration runner completed successfully");
      process.exit(0);
    })
    .catch((error) => {
      console.error("Migration runner failed:", error);
      process.exit(1);
    });
}

module.exports = { runMigrations };