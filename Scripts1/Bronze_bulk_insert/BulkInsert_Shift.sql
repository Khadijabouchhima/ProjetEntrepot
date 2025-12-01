/*
========================================================
Author:        Khadija Bouchhima
Date:          2025-12-01
Environment:   Bronze Layer – Bloom Coffee Shop
Purpose:       Bulk insert from shift.csv into Bronze_Shift
Notes:         Truncates the table before loading to ensure fresh data
========================================================
*/

TRUNCATE TABLE Bronze.Bronze_Shift;
GO

BULK INSERT Bronze.Bronze_Shift
FROM 'C:\Path\To\CSV\shift.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TEXTQUALIFIER = '"',
    CODEPAGE = '65001',
    TABLOCK
);
GO

