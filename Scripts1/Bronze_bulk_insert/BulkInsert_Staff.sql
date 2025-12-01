/*
========================================================
Author:        Khadija Bouchhima
Date:          2025-12-01
Environment:   Bronze Layer – Bloom Coffee Shop
Purpose:       Bulk insert from staff.csv into Bronze_Staff
========================================================
*/


BULK INSERT Bronze.Bronze_Staff
FROM 'C:\Path\To\CSV\staff.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TEXTQUALIFIER = '"',
    CODEPAGE = '65001'
    TABLOCK
);
