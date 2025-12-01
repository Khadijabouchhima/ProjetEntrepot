/*
========================================================
Author:        Khadija Bouchhima
Date:          2025-12-01
Environment:   Bronze Layer – Bloom Coffee Shop
Purpose:       Create raw landing table for items.csv
Notes:         This script drops the table if it exists
               and recreates it. Safe to execute in Git.
========================================================
*/

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
