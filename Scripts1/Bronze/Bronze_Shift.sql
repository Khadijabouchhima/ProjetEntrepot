/*
========================================================
Author:        Khadija Bouchhima
Date:          2025-12-01
Environment:   Bronze Layer – Bloom Coffee Shop
Purpose:       Create raw landing table for shift.csv
Notes:         This script drops the table if it exists
               and recreates it. Safe to execute in Git.
========================================================
*/

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
