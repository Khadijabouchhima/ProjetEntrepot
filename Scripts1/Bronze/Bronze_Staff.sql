/*
========================================================
Author:        Khadija Bouchhima
Date:          2025-12-01
Environment:   Bronze Layer – Bloom Coffee Shop
Purpose:       Create raw landing table for staff.csv
Notes:         This script drops the table if it exists
               and recreates it. Safe to execute in Git.
========================================================
*/

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
