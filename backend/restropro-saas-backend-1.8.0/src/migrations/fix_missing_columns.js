require("dotenv").config();
const { getMySqlPromiseConnection } = require("../config/mysql.db");

/**
 * Migration script to add missing columns to existing tables
 * This script ensures backward compatibility by checking if columns exist before adding them
 */
async function runMigration() {
  const conn = await getMySqlPromiseConnection();

  try {
    console.log("Starting migration to add missing columns...");

    // Check and add service_charge column to store_details table
    try {
      await conn.query("SELECT service_charge FROM store_details LIMIT 1");
      console.log("✓ service_charge column already exists in store_details");
    } catch (error) {
      if (error.code === "ER_BAD_FIELD_ERROR") {
        console.log("Adding service_charge column to store_details table...");
        await conn.query(
          "ALTER TABLE store_details ADD COLUMN service_charge DECIMAL(10,2) NULL"
        );
        console.log("✓ service_charge column added to store_details");
      } else {
        throw error;
      }
    }

    // Check and add is_enabled column to categories table
    try {
      await conn.query("SELECT is_enabled FROM categories LIMIT 1");
      console.log("✓ is_enabled column already exists in categories");
    } catch (error) {
      if (error.code === "ER_BAD_FIELD_ERROR") {
        console.log("Adding is_enabled column to categories table...");
        await conn.query(
          "ALTER TABLE categories ADD COLUMN is_enabled TINYINT(1) DEFAULT 1"
        );
        console.log("✓ is_enabled column added to categories");
      } else {
        throw error;
      }
    }

    // Check and add service_charge_total column to invoices table
    try {
      await conn.query("SELECT service_charge_total FROM invoices LIMIT 1");
      console.log("✓ service_charge_total column already exists in invoices");
    } catch (error) {
      if (error.code === "ER_BAD_FIELD_ERROR") {
        console.log("Adding service_charge_total column to invoices table...");
        await conn.query(
          "ALTER TABLE invoices ADD COLUMN service_charge_total DECIMAL(10,2) NULL"
        );
        console.log("✓ service_charge_total column added to invoices");
      } else {
        throw error;
      }
    }

    console.log("Migration completed successfully!");
  } catch (error) {
    console.error("Migration failed:", error);
    throw error;
  } finally {
    conn.release();
  }
}

// Run migration if this script is executed directly
if (require.main === module) {
  runMigration()
    .then(() => {
      console.log("Migration script completed successfully");
      process.exit(0);
    })
    .catch((error) => {
      console.error("Migration script failed:", error);
      process.exit(1);
    });
}

module.exports = { runMigration };
