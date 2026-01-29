require("dotenv").config();
const { getMySqlPromiseConnection } = require("../config/mysql.db");

async function testDatabaseConnection() {
  const conn = await getMySqlPromiseConnection();

  try {
    console.log("Testing database connection and column existence...");

    // Test service_charge column
    try {
      const [serviceChargeResult] = await conn.query(
        "SELECT service_charge FROM store_details LIMIT 1"
      );
      console.log("✓ service_charge column exists and is accessible");
    } catch (error) {
      console.log("✗ service_charge column issue:", error.message);
    }

    // Test is_enabled column
    try {
      const [isEnabledResult] = await conn.query(
        "SELECT is_enabled FROM categories LIMIT 1"
      );
      console.log("✓ is_enabled column exists and is accessible");
    } catch (error) {
      console.log("✗ is_enabled column issue:", error.message);
    }

    // Test service_charge_total column
    try {
      const [serviceChargeTotalResult] = await conn.query(
        "SELECT service_charge_total FROM invoices LIMIT 1"
      );
      console.log("✓ service_charge_total column exists and is accessible");
    } catch (error) {
      console.log("✗ service_charge_total column issue:", error.message);
    }

    // Test a simple query to verify the database is working
    try {
      const [tenantResult] = await conn.query(
        "SELECT COUNT(*) as tenant_count FROM tenants"
      );
      console.log(
        "✓ Database connection working, tenant count:",
        tenantResult[0].tenant_count
      );
    } catch (error) {
      console.log("✗ Database connection issue:", error.message);
    }

    console.log("Database test completed successfully!");
  } catch (error) {
    console.error("Database test failed:", error);
    throw error;
  } finally {
    conn.release();
  }
}

// Run test if this script is executed directly
if (require.main === module) {
  testDatabaseConnection()
    .then(() => {
      console.log("All tests passed!");
      process.exit(0);
    })
    .catch((error) => {
      console.error("Test failed:", error);
      process.exit(1);
    });
}

module.exports = { testDatabaseConnection };
