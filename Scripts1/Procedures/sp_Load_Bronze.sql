/*
========================================================
Author:        Khadija Bouchhima
Date:          2025-12-01
Environment:   Bronze Layer – Bloom Coffee Shop
Purpose:       Load all CSV files into Bronze tables
Notes:         Truncates each table before bulk insert
========================================================
*/

CREATE OR ALTER PROCEDURE Bronze.sp_Load_Bronze
AS
BEGIN
    SET NOCOUNT ON;

    -- 1️⃣ Ingredients
    TRUNCATE TABLE Bronze.Bronze_Ingredients;
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

    -- 2️⃣ Inventory
    TRUNCATE TABLE Bronze.Bronze_Inventory;
    BULK INSERT Bronze.Bronze_Inventory
    FROM 'C:\Path\To\CSV\inventory.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        TEXTQUALIFIER = '"',
        CODEPAGE = '65001',
        TABLOCK
    );

    -- 3️⃣ Items
    TRUNCATE TABLE Bronze.Bronze_Items;
    BULK INSERT Bronze.Bronze_Items
    FROM 'C:\Path\To\CSV\items.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        TEXTQUALIFIER = '"',
        CODEPAGE = '65001',
        TABLOCK
    );

    -- 4️⃣ Orders
    TRUNCATE TABLE Bronze.Bronze_Orders;
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

    -- 5️⃣ Recipe
    TRUNCATE TABLE Bronze.Bronze_Recipe;
    BULK INSERT Bronze.Bronze_Recipe
    FROM 'C:\Path\To\CSV\recipe.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        TEXTQUALIFIER = '"',
        CODEPAGE = '65001',
        TABLOCK
    );

    -- 6️⃣ Rota
    TRUNCATE TABLE Bronze.Bronze_Rota;
    BULK INSERT Bronze.Bronze_Rota
    FROM 'C:\Path\To\CSV\rota.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        TEXTQUALIFIER = '"',
        CODEPAGE = '65001',
        TABLOCK
    );

    -- 7️⃣ Shift
    TRUNCATE TABLE Bronze.Bronze_Shift;
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

    -- 8️⃣ Staff
    TRUNCATE TABLE Bronze.Bronze_Staff;
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

END
GO
