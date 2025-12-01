/*
========================================================
Author:        Khadija Bouchhima
Date:          2025-12-01
Environment:   Bronze Layer – Bloom Coffee Shop
Purpose:       Full DDL script to create all Bronze tables
Notes:         Drops existing tables and recreates them.
========================================================
*/

-- ==============================================
-- Bronze_Ingredients
-- ==============================================
IF OBJECT_ID('Bronze.Bronze_Ingredients', 'U') IS NOT NULL
    DROP TABLE Bronze.Bronze_Ingredients;
GO

CREATE TABLE Bronze.Bronze_Ingredients (
    ing_id      VARCHAR(50) NULL,
    ing_name    VARCHAR(200) NULL,
    ing_weight  DECIMAL(18,4) NULL,
    ing_meas    VARCHAR(50) NULL,
    ing_price   DECIMAL(18,4) NULL
);
GO

-- ==============================================
-- Bronze_Inventory
-- ==============================================
IF OBJECT_ID('Bronze.Bronze_Inventory', 'U') IS NOT NULL
    DROP TABLE Bronze.Bronze_Inventory;
GO

CREATE TABLE Bronze.Bronze_Inventory (
    inv_id     VARCHAR(50) NULL,
    ing_id     VARCHAR(50) NULL,
    quantity   DECIMAL(18,4) NULL
);
GO

-- ==============================================
-- Bronze_Items
-- ==============================================
IF OBJECT_ID('Bronze.Bronze_Items', 'U') IS NOT NULL
    DROP TABLE Bronze.Bronze_Items;
GO

CREATE TABLE Bronze.Bronze_Items (
    item_id     VARCHAR(50) NULL,
    sku         VARCHAR(50) NULL,
    item_name   VARCHAR(200) NULL,
    item_cat    VARCHAR(100) NULL,
    item_size   VARCHAR(50) NULL,
    item_price  DECIMAL(18,4) NULL
);
GO

-- ==============================================
-- Bronze_Orders
-- ==============================================
IF OBJECT_ID('Bronze.Bronze_Orders', 'U') IS NOT NULL
    DROP TABLE Bronze.Bronze_Orders;
GO

CREATE TABLE Bronze.Bronze_Orders (
    row_id       INT NULL,
    order_id     VARCHAR(50) NULL,
    created_at   DATETIME NULL,
    item_id      VARCHAR(50) NULL,
    quantity     DECIMAL(18,4) NULL,
    cust_name    VARCHAR(200) NULL,
    in_or_out    VARCHAR(20) NULL
);
GO

-- ==============================================
-- Bronze_Recipe
-- ==============================================
IF OBJECT_ID('Bronze.Bronze_Recipe', 'U') IS NOT NULL
    DROP TABLE Bronze.Bronze_Recipe;
GO

CREATE TABLE Bronze.Bronze_Recipe (
    row_id      INT NULL,
    recipe_id   VARCHAR(50) NULL,
    ing_id      VARCHAR(50) NULL,
    quantity    DECIMAL(18,4) NULL
);
GO

-- ==============================================
-- Bronze_Staff
-- ==============================================
IF OBJECT_ID('Bronze.Bronze_Staff', 'U') IS NOT NULL
    DROP TABLE Bronze.Bronze_Staff;
GO

CREATE TABLE Bronze.Bronze_Staff (
    staff_id       VARCHAR(50) NULL,
    first_name     VARCHAR(100) NULL,
    last_name      VARCHAR(100) NULL,
    position       VARCHAR(50) NULL,
    sal_per_hour   DECIMAL(18,2) NULL
);
GO

-- ==============================================
-- Bronze_Rota
-- ==============================================
IF OBJECT_ID('Bronze.Bronze_Rota', 'U') IS NOT NULL
    DROP TABLE Bronze.Bronze_Rota;
GO

CREATE TABLE Bronze.Bronze_Rota (
    row_id      INT NULL,
    rota_id     VARCHAR(50) NULL,
    date        DATE NULL,
    shift_id    VARCHAR(50) NULL,
    staff_id    VARCHAR(50) NULL
);
GO

-- ==============================================
-- Bronze_Shift
-- ==============================================
IF OBJECT_ID('Bronze.Bronze_Shift', 'U') IS NOT NULL
    DROP TABLE Bronze.Bronze_Shift;
GO

CREATE TABLE Bronze.Bronze_Shift (
    shift_id       VARCHAR(50) NULL,
    day_of_week    VARCHAR(20) NULL,
    start_time     TIME NULL,
    end_time       TIME NULL
);
GO
