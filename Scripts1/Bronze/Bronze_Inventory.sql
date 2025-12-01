/*
========================================================
Author:        Khadija Bouchhima
Date:          2025-12-01
Environment:   Bronze Layer – Bloom Coffee Shop
Purpose:       Create raw landing table for inventory.csv
Notes:         This script drops the table if it exists
               and recreates it. Safe to execute in Git.
========================================================
*/

IF OBJECT_ID('Bronze.Bronze_Inventory', 'U') IS NOT NULL
    DROP TABLE Bronze.Bronze_Inventory;
GO

CREATE TABLE Bronze.Bronze_Inventory (
    inv_id     VARCHAR(50) NULL,
    ing_id     VARCHAR(50) NULL,
    quantity   DECIMAL(18,4) NULL
);
GO
