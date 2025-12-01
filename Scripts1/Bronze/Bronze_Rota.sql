/*
========================================================
Author:        Khadija Bouchhima
Date:          2025-12-01
Environment:   Bronze Layer – Bloom Coffee Shop
Purpose:       Create raw landing table for rota.csv
Notes:         This script drops the table if it exists
               and recreates it. Safe to execute in Git.
========================================================
*/

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
