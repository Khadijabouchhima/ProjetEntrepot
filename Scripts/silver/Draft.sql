CREATE OR ALTER PROCEDURE silver.proc_load_silver
AS
BEGIN
    DECLARE @start_time DATETIME2, @end_time DATETIME2;
    
    BEGIN TRY
        PRINT '================================================';
        PRINT 'Starting Silver Layer Load';
        PRINT '================================================';

        ---------------------------------------------
        -- Silver Ingredients
        ---------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.Silver_Ingredients';
        TRUNCATE TABLE silver.Silver_Ingredients;

        PRINT '>> Inserting Data Into: silver.Silver_Ingredients';
        INSERT INTO silver.Silver_Ingredients (
            ing_id,
            ing_name,
            ing_weight,
            ing_meas,
            ing_price,
            dwh_create_date
        )
        SELECT DISTINCT
            TRIM(ing_id) AS ing_id,
            TRIM(REPLACE(ing_name, '"', '')) AS ing_name,
            ISNULL(ing_weight,0) AS ing_weight,
            TRIM(ing_meas) AS ing_meas,
            ISNULL(ing_price,0) AS ing_price,
            GETDATE() AS dwh_create_date
        FROM Bronze.Bronze_Ingredients
        WHERE ing_id IS NOT NULL;
        SET @end_time = GETDATE();
        PRINT '>> Silver_Ingredients Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        ---------------------------------------------
        -- Silver Inventory
        ---------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.Silver_Inventory';
        TRUNCATE TABLE silver.Silver_Inventory;

        PRINT '>> Inserting Data Into: silver.Silver_Inventory';
        INSERT INTO silver.Silver_Inventory (
            inv_id,
            ing_id,
            quantity,
            dwh_create_date
        )
        SELECT
            TRIM(inv_id) AS inv_id,
            TRIM(ing_id) AS ing_id,
            quantity,
            GETDATE() AS dwh_create_date
        FROM bronze.Bronze_Inventory;
        SET @end_time = GETDATE();
        PRINT '>> Silver_Inventory Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        ---------------------------------------------
        -- Silver Items
        ---------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.Silver_Items';
        TRUNCATE TABLE silver.Silver_Items;

        PRINT '>> Inserting Data Into: silver.Silver_Items';
        INSERT INTO silver.Silver_Items (
            item_id,
            sku,
            sku_cat_code,
            sku_item_code,
            sku_size_code,
            item_name,
            item_cat,
            item_size,
            item_price,
            dwh_create_date
        )
        SELECT
            TRIM(item_id) AS item_id,
            TRIM(sku) AS sku,
            LEFT(sku, CHARINDEX('-', sku + '-') - 1) AS sku_cat_code,
            CASE 
                WHEN CHARINDEX('-', sku) > 0 AND CHARINDEX('-', sku, CHARINDEX('-', sku) + 1) > 0 THEN
                    SUBSTRING(
                        sku,
                        CHARINDEX('-', sku) + 1,
                        CHARINDEX('-', sku, CHARINDEX('-', sku) + 1) - CHARINDEX('-', sku) - 1
                    )
                WHEN CHARINDEX('-', sku) > 0 THEN
                    SUBSTRING(sku, CHARINDEX('-', sku) + 1, LEN(sku)) -- If only two parts
                ELSE
                    'N/A'
            END AS sku_item_code,
            CASE 
                WHEN LEN(sku) - LEN(REPLACE(sku, '-', '')) = 2 THEN
                    RIGHT(sku, CHARINDEX('-', REVERSE(sku)) - 1)
                ELSE
                    'N/A'
            END AS sku_size_code,
            TRIM(REPLACE(item_name, '"', '')) AS item_name,
            TRIM(REPLACE(item_cat, '"', '')) AS item_cat, 
            item_size,
            item_price,
            GETDATE() AS dwh_create_date
        FROM bronze.Bronze_Items;
        SET @end_time = GETDATE();
        PRINT '>> Silver_Items Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        ---------------------------------------------
        -- Silver Orders
        ---------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.Silver_Orders';
        TRUNCATE TABLE silver.Silver_Orders;

        PRINT '>> Inserting Data Into: silver.Silver_Orders';
        INSERT INTO silver.Silver_Orders (
            row_id,
            order_id,
            created_at,
            order_date,
            order_time,
            item_id,
            quantity,
            cust_name,
            in_or_out,
            dwh_create_date
        )
        SELECT
            row_id,
            TRIM(order_id) AS order_id,
            created_at,
            CAST(created_at AS DATE) AS order_date,
            CAST(created_at AS TIME) AS order_time,
            TRIM(item_id) AS item_id,
            quantity,
            TRIM(cust_name) AS cust_name,
            ISNULL(in_or_out,'N/A') AS in_or_out,
            GETDATE() AS dwh_create_date
        FROM Bronze.Bronze_orders;
        SET @end_time = GETDATE();
        PRINT '>> Silver_Orders Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        ---------------------------------------------
        -- Silver Recipe
        ---------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.Silver_Recipe';
        TRUNCATE TABLE silver.Silver_Recipe;

        PRINT '>> Inserting Data Into: silver.Silver_Recipe';
        INSERT INTO silver.Silver_Recipe (
            row_id,
            recipe_id,
            ing_id,
            quantity,
            dwh_create_date
        )
        SELECT
            r.row_id,
            r.recipe_id,
            r.ing_id,
            r.quantity,
            GETDATE() AS dwh_create_date
        FROM bronze.Bronze_Recipe r
        INNER JOIN silver.Silver_Ingredients i ON r.ing_id = i.ing_id
        WHERE r.row_id IS NOT NULL
          AND r.quantity > 0
          AND i.ing_id IS NOT NULL;
        SET @end_time = GETDATE();
        PRINT '>> Silver_Recipe Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        ---------------------------------------------
        -- Silver Rota
        ---------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.Silver_Rota';
        TRUNCATE TABLE silver.Silver_Rota;

        PRINT '>> Inserting Data Into: silver.Silver_Rota';
        INSERT INTO silver.Silver_Rota (
            row_id,
            rota_id,
            date,
            shift_id,
            staff_id,
            dwh_create_date
        )
        SELECT
            r.row_id,
            r.rota_id,
            r.date,
            r.shift_id,
            r.staff_id,
            GETDATE() AS dwh_create_date
        FROM bronze.Bronze_Rota r
        INNER JOIN bronze.Bronze_Staff s ON r.staff_id = s.staff_id
        WHERE r.row_id IS NOT NULL
          AND s.staff_id IS NOT NULL;
        SET @end_time = GETDATE();
        PRINT '>> Silver_Rota Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        ---------------------------------------------
        -- Silver Shift
        ---------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.Silver_Shift';
        TRUNCATE TABLE silver.Silver_Shift;

        PRINT '>> Inserting Data Into: silver.Silver_Shift';
        INSERT INTO silver.Silver_Shift (
            shift_id,
            day_of_week,
            start_time,
            end_time,
            dwh_create_date
        )
        SELECT
            shift_id,
            TRIM(day_of_week) AS day_of_week,
            start_time,
            end_time,
            GETDATE() AS dwh_create_date
        FROM bronze.Bronze_Shift
        WHERE shift_id IS NOT NULL
          AND start_time <= end_time;
        SET @end_time = GETDATE();
        PRINT '>> Silver_Shift Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        ---------------------------------------------
        -- Silver Staff
        ---------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.Silver_Staff';
        TRUNCATE TABLE silver.Silver_Staff;

        PRINT '>> Inserting Data Into: silver.Silver_Staff';
        INSERT INTO silver.Silver_Staff (
            staff_id,
            first_name,
            last_name,
            position,
            sal_per_hour,
            dwh_create_date
        )
        SELECT
            staff_id,
            TRIM(first_name) AS first_name,
            TRIM(last_name) AS last_name,
            TRIM(position) AS position, 
            sal_per_hour,
            GETDATE() AS dwh_create_date
        FROM bronze.Bronze_Staff
        WHERE staff_id IS NOT NULL
          AND sal_per_hour >= 0;
        SET @end_time = GETDATE();
        PRINT '>> Silver_Staff Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        PRINT '================================================';
        PRINT 'Silver Layer Load Completed Successfully';
        PRINT '================================================';

    END TRY
    BEGIN CATCH
        PRINT '==========================================';
        PRINT 'ERROR OCCURRED DURING SILVER LAYER LOAD';
        PRINT ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '==========================================';
    END CATCH
END;

--------------------------------------------Cleaning silver_orders -----------------------------------------------------------------------
UPDATE silver.silver_orders
SET item_id =
    CASE
        WHEN LEN(item_id) > 5 THEN
            CASE
                WHEN TRY_CAST(SUBSTRING(TRIM(item_id), 3, 3) AS INT) BETWEEN 1 AND 24
                     AND LEFT(TRIM(item_id), 2) = 'It'
                     AND LEN(TRIM(item_id)) = 5
                THEN TRIM(item_id)
                ELSE 'UNKNOWN'
            END

        ELSE
            -- Length <=5 → validate directly
            CASE
                WHEN TRY_CAST(SUBSTRING(item_id, 3, 3) AS INT) BETWEEN 1 AND 24
                     AND LEFT(item_id, 2) = 'It'
                     AND LEN(item_id) = 5
                THEN item_id
                ELSE 'UNKNOWN'
            END
    END;

