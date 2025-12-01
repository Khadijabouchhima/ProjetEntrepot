/*
========================================================
Author:        Khadija Bouchhima
Date:          2025-12-01
Environment:   Bronze Layer – Bloom Coffee Shop
Purpose:       Bulk insert from orders.csv into Bronze_Orders
Notes:         Truncates the table before loading to ensure fresh data
========================================================
*/


TRUNCATE TABLE Bronze.Bronze_Orders;
GO

BULK INSERT Bronze.Bronze_Orders
FROM 'C:\Path\To\CSV\orders.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TEXTQUALIFIER = '"',
    CODEPAGE = '65001',
    TABLOCK
);
GO

