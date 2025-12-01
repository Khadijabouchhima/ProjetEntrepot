/*
========================================================
Author:        Khadija Bouchhima
Date:          2025-12-01
Environment:   Bronze Layer – Bloom Coffee Shop
Purpose:       Bulk insert from items.csv into Bronze_Items
========================================================
*/

BULK INSERT Bronze.Bronze_Items
FROM 'C:\Path\To\CSV\items.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TEXTQUALIFIER = '"',
    CODEPAGE = '65001'
    TABLOCK
);
