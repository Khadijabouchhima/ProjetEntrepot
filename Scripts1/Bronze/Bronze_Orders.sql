/*
========================================================
Author:        Khadija Bouchhima
Date:          2025-12-01
Environment:   Bronze Layer – Bloom Coffee Shop
Purpose:       Create raw landing table for orders.csv
Notes:         This script drops the table if it exists
               and recreates it. Safe to execute in Git.
========================================================
*/

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
