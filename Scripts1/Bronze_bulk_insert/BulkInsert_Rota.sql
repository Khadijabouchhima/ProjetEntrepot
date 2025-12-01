/*
========================================================
Author:        Khadija Bouchhima
Date:          2025-12-01
Environment:   Bronze Layer – Bloom Coffee Shop
Purpose:       Bulk insert from rota.csv into Bronze_Rota
========================================================
*/

BULK INSERT Bronze.Bronze_Rota
FROM 'C:\Path\To\CSV\rota.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TEXTQUALIFIER = '"',
    CODEPAGE = '65001'
    TABLOCK
);
