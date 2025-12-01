/*
========================================================
Author:        Khadija Bouchhima
Date:          2025-12-01
Environment:   Bronze Layer – Bloom Coffee Shop
Purpose:       Create raw landing table for ingredients.csv
Notes:         This script drops the table if it exists
               and recreates it. Safe to execute in Git.
========================================================
*/

IF OBJECT_ID('Bronze.Bronze_Ingredients', 'U') IS NOT NULL
    DROP TABLE Bronze.Bronze_Ingredients;
GO

CREATE TABLE Bronze.Bronze_Ingredients (
    ing_id      VARCHAR(50) NULL,
    ing_name    VARCHAR(200) NULL,
    ing_weight             DECIMAL(18,4) NULL,
    ing_meas       VARCHAR(50) NULL,
    ing_price         DECIMAL(18,4) NULL
);
GO
