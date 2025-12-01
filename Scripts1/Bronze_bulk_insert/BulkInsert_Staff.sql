/*
========================================================
Author:        Khadija Bouchhima
Date:          2025-12-01
Environment:   Bronze Layer – Bloom Coffee Shop
Purpose:       Bulk insert from staff.csv into Bronze_Staff
Notes:         Truncates the table before loading to ensure fresh data
========================================================
*/

TRUNCATE TABLE Bronze.Bronze_Staff;
GO

BULK INSERT Bronze.Bronze_Staff
FROM 'C:\Path\To\CSV\staff.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TEXTQUALIFIER = '"',
    CODEPAGE = '65001',
    TABLOCK
);
GO
