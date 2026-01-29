-- Script to create missing tables if they don't exist
-- This script checks for table existence before creating them

-- Create categories table if it doesn't exist
CREATE TABLE IF NOT EXISTS `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL,
  `tenant_id` int DEFAULT NULL,
  `is_enabled` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create customers table if it doesn't exist
CREATE TABLE IF NOT EXISTS `customers` (
  `phone` varchar(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `gender` enum('male','female','other') DEFAULT NULL,
  `is_member` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `tenant_id` int NOT NULL,
  PRIMARY KEY (`phone`,`tenant_id`),
  KEY `customers_ibfk_1` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create exchange_rates table if it doesn't exist
CREATE TABLE IF NOT EXISTS `exchange_rates` (
  `currency_code` varchar(5) NOT NULL,
  `rate_to_usd` decimal(10,6) DEFAULT NULL,
  PRIMARY KEY (`currency_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create feedbacks table if it doesn't exist
CREATE TABLE IF NOT EXISTS `feedbacks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `invoice_id` int DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `date` datetime DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(255) DEFAULT NULL,
  `average_rating` double(10,2) DEFAULT NULL,
  `food_quality_rating` double(10,2) DEFAULT NULL,
  `service_rating` double(10,2) DEFAULT NULL,
  `staff_behavior_rating` double(10,2) DEFAULT NULL,
  `ambiance_rating` double(10,2) DEFAULT NULL,
  `recommend_rating` double(10,2) DEFAULT NULL,
  `remarks` mediumtext,
  `tenant_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tenant_id` (`tenant_id`),
  KEY `invoice_id` (`invoice_id`,`tenant_id`),
  KEY `phone` (`phone`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create inventory_items table if it doesn't exist
CREATE TABLE IF NOT EXISTS `inventory_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `quantity` decimal(10,4) DEFAULT '0.0000',
  `unit` enum('pc','kg','g','l','ml') NOT NULL,
  `min_quantity_threshold` decimal(10,4) NOT NULL,
  `status` enum('low','in','out') DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `tenant_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_tenant_id_idx` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create inventory_logs table if it doesn't exist
CREATE TABLE IF NOT EXISTS `inventory_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `inventory_item_id` int NOT NULL,
  `type` enum('IN','OUT','WASTAGE') NOT NULL,
  `quantity_change` decimal(10,4) NOT NULL,
  `previous_quantity` decimal(10,4) DEFAULT NULL,
  `new_quantity` decimal(10,4) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `tenant_id` (`tenant_id`),
  KEY `inventory_item_id` (`inventory_item_id`),
  KEY `inventory_logs_ibfk_3` (`created_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create invoice_sequences table if it doesn't exist
CREATE TABLE IF NOT EXISTS `invoice_sequences` (
  `tenant_id` int NOT NULL,
  `sequence_no` int DEFAULT NULL,
  PRIMARY KEY (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create invoices table if it doesn't exist
CREATE TABLE IF NOT EXISTS `invoices` (
  `id` int NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `sub_total` decimal(10,2) DEFAULT NULL,
  `tax_total` decimal(10,2) DEFAULT NULL,
  `total` decimal(10,2) DEFAULT NULL,
  `tenant_id` int NOT NULL,
  `payment_type_id` int DEFAULT NULL,
  `service_charge_total` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`,`tenant_id`),
  KEY `tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create menu_item_addons table if it doesn't exist
CREATE TABLE IF NOT EXISTS `menu_item_addons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `tenant_id` int DEFAULT NULL,
  PRIMARY KEY (`id`,`item_id`),
  KEY `fk_menu_item_idx` (`item_id`),
  KEY `fk_menu_item_idx_index` (`item_id`),
  KEY `tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create menu_item_recipes table if it doesn't exist
CREATE TABLE IF NOT EXISTS `menu_item_recipes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `menu_item_id` int DEFAULT NULL,
  `variant_id` int NOT NULL DEFAULT '0',
  `addon_id` int NOT NULL DEFAULT '0',
  `inventory_item_id` int NOT NULL,
  `quantity` decimal(10,4) NOT NULL,
  `tenant_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_recipe_combo` (`menu_item_id`,`inventory_item_id`,`variant_id`,`addon_id`),
  KEY `inventory_item_id` (`inventory_item_id`),
  KEY `tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create menu_item_variants table if it doesn't exist
CREATE TABLE IF NOT EXISTS `menu_item_variants` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `tenant_id` int DEFAULT NULL,
  PRIMARY KEY (`id`,`item_id`),
  KEY `fk_variant_menu_item_id_idx` (`item_id`),
  KEY `tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create menu_items table if it doesn't exist
CREATE TABLE IF NOT EXISTS `menu_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `net_price` decimal(10,2) DEFAULT NULL,
  `tax_id` int DEFAULT NULL,
  `image` varchar(2000) DEFAULT NULL,
  `category` int DEFAULT NULL,
  `tenant_id` int DEFAULT NULL,
  `is_enabled` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create order_items table if it doesn't exist
CREATE TABLE IF NOT EXISTS `order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `item_id` int DEFAULT NULL,
  `variant_id` int DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `status` enum('created','preparing','completed','cancelled','delivered') DEFAULT 'created',
  `date` datetime DEFAULT CURRENT_TIMESTAMP,
  `notes` varchar(255) DEFAULT NULL,
  `addons` mediumtext,
  `tenant_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create orders table if it doesn't exist
CREATE TABLE IF NOT EXISTS `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT CURRENT_TIMESTAMP,
  `delivery_type` varchar(90) DEFAULT NULL,
  `customer_type` enum('WALKIN','CUSTOMER') DEFAULT 'WALKIN',
  `customer_id` varchar(20) DEFAULT NULL,
  `table_id` int DEFAULT NULL,
  `status` enum('created','completed','cancelled') DEFAULT 'created',
  `token_no` int DEFAULT NULL,
  `payment_status` enum('pending','paid') DEFAULT 'pending',
  `invoice_id` int DEFAULT NULL,
  `tenant_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create payment_types table if it doesn't exist
CREATE TABLE IF NOT EXISTS `payment_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `tenant_id` int DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create print_settings table if it doesn't exist
CREATE TABLE IF NOT EXISTS `print_settings` (
  `tenant_id` int NOT NULL,
  `page_format` varchar(5) DEFAULT NULL,
  `header` varchar(2000) DEFAULT NULL,
  `footer` varchar(2000) DEFAULT NULL,
  `show_notes` tinyint(1) DEFAULT NULL,
  `is_enable_print` tinyint(1) DEFAULT NULL,
  `show_store_details` tinyint(1) DEFAULT NULL,
  `show_customer_details` tinyint(1) DEFAULT NULL,
  `print_token` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create qr_order_items table if it doesn't exist
CREATE TABLE IF NOT EXISTS `qr_order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `item_id` int DEFAULT NULL,
  `variant_id` int DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `status` enum('created','preparing','completed','cancelled','delivered') DEFAULT 'created',
  `date` datetime DEFAULT CURRENT_TIMESTAMP,
  `notes` varchar(255) DEFAULT NULL,
  `addons` mediumtext,
  `tenant_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create qr_orders table if it doesn't exist
CREATE TABLE IF NOT EXISTS `qr_orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT CURRENT_TIMESTAMP,
  `delivery_type` varchar(90) DEFAULT NULL,
  `customer_type` enum('WALKIN','CUSTOMER') DEFAULT 'WALKIN',
  `customer_id` varchar(20) DEFAULT NULL,
  `table_id` int DEFAULT NULL,
  `status` enum('created','completed','cancelled') DEFAULT 'created',
  `payment_status` enum('pending','paid') DEFAULT 'pending',
  `tenant_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create refresh_tokens table if it doesn't exist
CREATE TABLE IF NOT EXISTS `refresh_tokens` (
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `refresh_token` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `device_ip` varchar(50) DEFAULT NULL,
  `device_name` varchar(255) DEFAULT NULL,
  `device_location` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `expiry` datetime DEFAULT NULL,
  `device_id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  PRIMARY KEY (`device_id`,`username`,`refresh_token`),
  KEY `tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create reservations table if it doesn't exist
CREATE TABLE IF NOT EXISTS `reservations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` varchar(20) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `table_id` int DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  `notes` varchar(500) DEFAULT NULL,
  `people_count` int DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `unique_code` varchar(20) DEFAULT NULL,
  `tenant_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug_index` (`unique_code`) USING BTREE,
  KEY `idx_date` (`date`) USING BTREE,
  KEY `INDEX_CUSTOMER_SEARCH` (`customer_id`) USING BTREE,
  KEY `tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create reset_password_tokens table if it doesn't exist
CREATE TABLE IF NOT EXISTS `reset_password_tokens` (
  `username` varchar(255) NOT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create store_details table if it doesn't exist
CREATE TABLE IF NOT EXISTS `store_details` (
  `store_name` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `currency` varchar(10) DEFAULT NULL,
  `store_image` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `tenant_id` int DEFAULT NULL,
  `is_qr_menu_enabled` tinyint(1) DEFAULT '0',
  `unique_qr_code` varchar(255) DEFAULT NULL,
  `is_qr_order_enabled` tinyint(1) DEFAULT NULL,
  `is_feedback_enabled` tinyint(1) DEFAULT '0',
  `unique_id` varchar(255) DEFAULT NULL,
  `service_charge` decimal(10,2) DEFAULT NULL,
  UNIQUE KEY `tenant_id_pk` (`tenant_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create store_tables table if it doesn't exist
CREATE TABLE IF NOT EXISTS `store_tables` (
  `id` int NOT NULL AUTO_INCREMENT,
  `table_title` varchar(100) DEFAULT NULL,
  `floor` varchar(50) DEFAULT NULL,
  `seating_capacity` smallint DEFAULT NULL,
  `tenant_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create subscription_history table if it doesn't exist
CREATE TABLE IF NOT EXISTS `subscription_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `starts_on` datetime DEFAULT NULL,
  `expires_on` datetime DEFAULT NULL,
  `status` enum('updated','created','cancelled') DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create superadmins table if it doesn't exist
CREATE TABLE IF NOT EXISTS `superadmins` (
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create taxes table if it doesn't exist
CREATE TABLE IF NOT EXISTS `taxes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(50) DEFAULT NULL,
  `rate` double DEFAULT NULL,
  `type` enum('inclusive','exclusive','other') DEFAULT 'other',
  `tenant_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create tenants table if it doesn't exist
CREATE TABLE IF NOT EXISTS `tenants` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(95) DEFAULT NULL,
  `is_active` tinyint DEFAULT NULL,
  `subscription_id` varchar(255) DEFAULT NULL,
  `payment_customer_id` varchar(255) DEFAULT NULL,
  `subscription_start` datetime DEFAULT NULL,
  `subscription_end` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create token_sequences table if it doesn't exist
CREATE TABLE IF NOT EXISTS `token_sequences` (
  `tenant_id` int NOT NULL,
  `sequence_no` int DEFAULT NULL,
  `last_updated` date DEFAULT NULL,
  PRIMARY KEY (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create users table if it doesn't exist
CREATE TABLE IF NOT EXISTS `users` (
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(95) DEFAULT NULL,
  `role` enum('admin','user') DEFAULT 'user',
  `photo` varchar(2000) DEFAULT NULL,
  `designation` varchar(50) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `scope` varchar(2000) DEFAULT NULL,
  `tenant_id` int DEFAULT NULL,
  PRIMARY KEY (`username`),
  KEY `tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;