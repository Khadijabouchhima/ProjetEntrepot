/*
========================================================
Author:        Khadija Bouchhima
Date:          2025-12-01
Environment:   Bronze Layer – Bloom Coffee Shop
Purpose:       Bulk insert from recipe.csv into Bronze_Recipe
========================================================
*/


BULK INSERT Bronze.Bronze_Recipe
FROM 'C:\Path\To\CSV\recipe.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TEXTQUALIFIER = '"',
    CODEPAGE = '65001'
);
