/*
========================================================
Author:        Khadija Bouchhima
Date:          2025-12-01
Environment:   Bronze Layer – Bloom Coffee Shop
Purpose:       Bulk insert from ingredients.csv into Bronze_Ingredients
========================================================
*/

BULK INSERT Bronze.Bronze_Ingredients
FROM 'C:\Path\To\CSV\ingredients.csv'  -- Update path as needed
WITH (
    FIRSTROW = 2,       -- Skip header row
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',
    TEXTQUALIFIER = '"',
    CODEPAGE = '65001'   -- UTF-8
    TABLOCK
);
