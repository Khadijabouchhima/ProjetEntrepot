/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    Loads data into the 'bronze' schema from external CSV files. 
    Actions performed:
    - Truncates bronze tables before loading.
    - Uses BULK INSERT to load CSV files.
    - Prints per-table load duration and total load time.

Parameters:
    None.

Usage:
    EXEC bronze.load_bronze;
===============================================================================
*/
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
    EXEC('CREATE SCHEMA bronze');
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Bronze Layer – Bloom Coffee Shop';
        PRINT '================================================';

        -----------------------------
        -- Ingredients
        -----------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.Bronze_Ingredients';
        TRUNCATE TABLE bronze.Bronze_Ingredients;
        PRINT '>> Inserting Data Into: bronze.Bronze_Ingredients';
        BULK INSERT bronze.Bronze_Ingredients
        FROM '/var/opt/mssql/data/ingredients.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -----------------------------
        -- Inventory
        -----------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.Bronze_Inventory';
        TRUNCATE TABLE bronze.Bronze_Inventory;
        PRINT '>> Inserting Data Into: bronze.Bronze_Inventory';
        BULK INSERT bronze.Bronze_Inventory
        FROM '/var/opt/mssql/data/inventory.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -----------------------------
        -- Items
        -----------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.Bronze_Items';
        TRUNCATE TABLE bronze.Bronze_Items;
        PRINT '>> Inserting Data Into: bronze.Bronze_Items';
        BULK INSERT bronze.Bronze_Items
        FROM '/var/opt/mssql/data/items.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -----------------------------
        -- Orders
        -----------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.Bronze_Orders';
        TRUNCATE TABLE bronze.Bronze_Orders;
        PRINT '>> Inserting Data Into: bronze.Bronze_Orders';
        BULK INSERT bronze.Bronze_Orders
        FROM '/var/opt/mssql/data/orders.csv'
        WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK,
                FORMAT = 'CSV'
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -----------------------------
        -- Recipe
        -----------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.Bronze_Recipe';
        TRUNCATE TABLE bronze.Bronze_Recipe;
        PRINT '>> Inserting Data Into: bronze.Bronze_Recipe'; 
        BULK INSERT bronze.Bronze_Recipe
        FROM '/var/opt/mssql/data/recipe.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -----------------------------
        -- Rota
        -----------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.Bronze_Rota';
        TRUNCATE TABLE bronze.Bronze_Rota;
        PRINT '>> Inserting Data Into: bronze.Bronze_Rota';
        BULK INSERT bronze.Bronze_Rota
        FROM '/var/opt/mssql/data/rota.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -----------------------------
        -- Shift
        -----------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.Bronze_Shift';
        TRUNCATE TABLE bronze.Bronze_Shift;
        PRINT '>> Inserting Data Into: bronze.Bronze_Shift';
        BULK INSERT bronze.Bronze_Shift
        FROM '/var/opt/mssql/data/shift.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -----------------------------
        -- Staff
        -----------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.Bronze_Staff';
        TRUNCATE TABLE bronze.Bronze_Staff;
        PRINT '>> Inserting Data Into: bronze.Bronze_Staff';
        BULK INSERT bronze.Bronze_Staff
        FROM '/var/opt/mssql/data/staff.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -----------------------------
        -- Finished
        -----------------------------
        SET @batch_end_time = GETDATE();
        PRINT '==========================================';
        PRINT 'Loading Bronze Layer Completed';
        PRINT 'Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '==========================================';

    END TRY
    BEGIN CATCH
        PRINT '==========================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '==========================================';
    END CATCH
END
GO
