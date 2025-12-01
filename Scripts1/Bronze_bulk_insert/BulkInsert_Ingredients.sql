/*
========================================================
Author:        Khadija Bouchhima
Date:          2025-12-01
Environment:   Bronze Layer – Bloom Coffee Shop
Purpose:       Bulk insert from ingredients.csv into Bronze_Ingredients
Notes:         Truncates the table before loading to ensure fresh data
========================================================
*/

TRUNCATE TABLE Bronze.Bronze_Ingredients;
GO

BULK INSERT Bronze.Bronze_Ingredients
FROM 'C:\Path\To\CSV\ingredients.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TEXTQUALIFIER = '"',
    CODEPAGE = '65001',
    TABLOCK
);
GO
