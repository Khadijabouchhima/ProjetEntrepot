/*
========================================================
Author:        Khadija Bouchhima
Date:          2025-12-01
Environment:   Bronze Layer – Bloom Coffee Shop
Purpose:       Bulk insert from inventory.csv into Bronze_Inventory
========================================================
*/

BULK INSERT Bronze.Bronze_Inventory
FROM 'C:\Path\To\CSV\inventory.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TEXTQUALIFIER = '"',
    CODEPAGE = '65001'
    TABLOCK
);
