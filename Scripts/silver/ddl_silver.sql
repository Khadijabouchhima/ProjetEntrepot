/*
========================================================
Author:        Khadija Bouchhima
Date:          2025-12-01
Environment:   Silver Layer – Bloom Coffee Shop
Purpose:       Full DDL script to create all Silver tables with DWH creation date
Notes:         Drops existing tables and recreates them.
========================================================
*/

-- ==============================================
-- Silver_Ingredients
-- ==============================================
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Silver')
    EXEC('CREATE SCHEMA Silver');
GO
IF OBJECT_ID('Silver.Silver_Ingredients', 'U') IS NOT NULL
    DROP TABLE Silver.Silver_Ingredients;
GO

CREATE TABLE Silver.Silver_Ingredients (
    ing_id           VARCHAR(50) NULL,
    ing_name         VARCHAR(200) NULL,
    ing_weight       DECIMAL(18,4) NULL,
    ing_meas         VARCHAR(50) NULL,
    ing_price        DECIMAL(18,4) NULL,
    dwh_create_date  DATETIME2 DEFAULT GETDATE()
);
GO

-- ==============================================
-- Silver_Inventory
-- ==============================================
IF OBJECT_ID('Silver.Silver_Inventory', 'U') IS NOT NULL
    DROP TABLE Silver.Silver_Inventory;
GO

CREATE TABLE Silver.Silver_Inventory (
    inv_id           VARCHAR(50) NULL,
    ing_id           VARCHAR(50) NULL,
    quantity         DECIMAL(18,4) NULL,
    dwh_create_date  DATETIME2 DEFAULT GETDATE()
);
GO

-- ==============================================
-- Silver_Items
-- ==============================================
IF OBJECT_ID('Silver.Silver_Items', 'U') IS NOT NULL
    DROP TABLE Silver.Silver_Items;
GO

CREATE TABLE Silver.Silver_Items (
    item_id          VARCHAR(50) NULL,
    sku              VARCHAR(50) NULL,
    item_name        VARCHAR(200) NULL,
    item_cat         VARCHAR(100) NULL,
    item_size        VARCHAR(50) NULL,
    item_price       DECIMAL(18,4) NULL,
    dwh_create_date  DATETIME2 DEFAULT GETDATE()
);
GO

-- ==============================================
-- Silver_Orders
-- ==============================================
IF OBJECT_ID('Silver.Silver_Orders', 'U') IS NOT NULL
    DROP TABLE Silver.Silver_Orders;
GO

CREATE TABLE Silver.Silver_Orders (
    row_id           INT NULL,
    order_id         VARCHAR(50) NULL,
    created_at       DATETIME NULL,
    item_id          VARCHAR(50) NULL,
    quantity         DECIMAL(18,4) NULL,
    cust_name        VARCHAR(200) NULL,
    in_or_out        VARCHAR(20) NULL,
    dwh_create_date  DATETIME2 DEFAULT GETDATE()
);
GO

-- ==============================================
-- Silver_Recipe
-- ==============================================
IF OBJECT_ID('Silver.Silver_Recipe', 'U') IS NOT NULL
    DROP TABLE Silver.Silver_Recipe;
GO

CREATE TABLE Silver.Silver_Recipe (
    row_id           INT NULL,
    recipe_id        VARCHAR(50) NULL,
    ing_id           VARCHAR(50) NULL,
    quantity         DECIMAL(18,4) NULL,
    dwh_create_date  DATETIME2 DEFAULT GETDATE()
);
GO

-- ==============================================
-- Silver_Staff
-- ==============================================
IF OBJECT_ID('Silver.Silver_Staff', 'U') IS NOT NULL
    DROP TABLE Silver.Silver_Staff;
GO

CREATE TABLE Silver.Silver_Staff (
    staff_id         VARCHAR(50) NULL,
    first_name       VARCHAR(100) NULL,
    last_name        VARCHAR(100) NULL,
    position         VARCHAR(50) NULL,
    sal_per_hour     DECIMAL(18,2) NULL,
    dwh_create_date  DATETIME2 DEFAULT GETDATE()
);
GO

-- ==============================================
-- Silver_Rota
-- ==============================================
IF OBJECT_ID('Silver.Silver_Rota', 'U') IS NOT NULL
    DROP TABLE Silver.Silver_Rota;
GO

CREATE TABLE Silver.Silver_Rota (
    row_id           INT NULL,
    rota_id          VARCHAR(50) NULL,
    date             DATE NULL,
    shift_id         VARCHAR(50) NULL,
    staff_id         VARCHAR(50) NULL,
    dwh_create_date  DATETIME2 DEFAULT GETDATE()
);
GO

-- ==============================================
-- Silver_Shift
-- ==============================================
IF OBJECT_ID('Silver.Silver_Shift', 'U') IS NOT NULL
    DROP TABLE Silver.Silver_Shift;
GO

CREATE TABLE Silver.Silver_Shift (
    shift_id         VARCHAR(50) NULL,
    day_of_week      VARCHAR(20) NULL,
    start_time       TIME NULL,
    end_time         TIME NULL,
    dwh_create_date  DATETIME2 DEFAULT GETDATE()
);
GO
