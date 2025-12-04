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

/*

===============================================================================

Silver Recipe Cleaning Script

===============================================================================

Purpose:

    - Remove quotes from text fields.

    - Trim leading/trailing spaces.

    - Validate quantity is numeric and positive.

    - Ensure recipe_id and ing_id follow expected format patterns.

    - Check for duplicate recipe-ingredient combinations.

===============================================================================

*/

-- Remove quotes and trim spaces from text columns
UPDATE silver.Silver_Recipe
SET 
    recipe_id = TRIM(REPLACE(recipe_id, '"', '')),
    ing_id = TRIM(REPLACE(ing_id, '"', ''))
WHERE recipe_id LIKE '%"%' OR ing_id LIKE '%"%';

-- Trim all text columns even if no quotes
UPDATE silver.Silver_Recipe
SET 
    recipe_id = TRIM(recipe_id),
    ing_id = TRIM(ing_id);

-- Validate and convert quantity to numeric (if stored as text)
-- Using DECIMAL(10,2) to allow for decimal quantities if needed
UPDATE silver.Silver_Recipe
SET quantity = TRY_CAST(TRIM(quantity) AS DECIMAL(10,2))
WHERE TRY_CAST(TRIM(quantity) AS DECIMAL(10,2)) IS NOT NULL;

-- Optional: Mark rows with invalid quantity
/*
ALTER TABLE silver.Silver_Recipe
ADD is_valid_quantity BIT DEFAULT 1;

UPDATE silver.Silver_Recipe
SET is_valid_quantity = 0
WHERE TRY_CAST(TRIM(quantity) AS DECIMAL(10,2)) IS NULL;
*/

-- Optional: Validate quantity is positive (or non-negative)
UPDATE silver.Silver_Recipe
SET is_valid_quantity = 0
WHERE quantity < 0;

-- Optional: Validate recipe_id format pattern
-- Assuming format: XXX-XXX-XX or similar pattern
/*
ALTER TABLE silver.Silver_Recipe
ADD is_valid_recipe_id BIT DEFAULT 1;

UPDATE silver.Silver_Recipe
SET is_valid_recipe_id = 0
WHERE recipe_id NOT LIKE '[A-Z][A-Z][A-Z]-[A-Z][A-Z][A-Z]-[A-Z][A-Z]'
   AND recipe_id NOT LIKE '[A-Z][A-Z][A-Z]-[A-Z][A-Z][A-Z]'
   AND recipe_id IS NOT NULL;
*/

-- Optional: Validate ing_id format pattern
-- Assuming format: ING followed by 3 digits
/*
ALTER TABLE silver.Silver_Recipe
ADD is_valid_ing_id BIT DEFAULT 1;

UPDATE silver.Silver_Recipe
SET is_valid_ing_id = 0
WHERE ing_id NOT LIKE 'ING[0-9][0-9][0-9]'
   AND ing_id IS NOT NULL;
*/

-- Optional: Check for duplicate recipe-ingredient combinations
/*
ALTER TABLE silver.Silver_Recipe
ADD is_duplicate BIT DEFAULT 0;

WITH DuplicateCTE AS (
    SELECT 
        row_id,
        ROW_NUMBER() OVER (
            PARTITION BY recipe_id, ing_id 
            ORDER BY row_id
        ) as rn
    FROM silver.Silver_Rota
    WHERE recipe_id IS NOT NULL AND ing_id IS NOT NULL
)
UPDATE silver.Silver_Recipe
SET is_duplicate = 1
FROM silver.Silver_Recipe r
INNER JOIN DuplicateCTE d ON r.row_id = d.row_id
WHERE d.rn > 1;
*/

-- Optional: Check for missing/invalid ingredient references
-- Assuming you have a Silver_Ingredients table
/*
ALTER TABLE silver.Silver_Recipe
ADD has_valid_ingredient BIT DEFAULT 1;

UPDATE silver.Silver_Recipe
SET has_valid_ingredient = 0
WHERE NOT EXISTS (
    SELECT 1 FROM silver.Silver_Ingredients i 
    WHERE i.ing_id = silver.Silver_Recipe.ing_id
);
*/

-- Optional: Add derived columns for analysis
-- Extract product category from recipe_id (assuming format CAT-PROD-SIZE)
/*
ALTER TABLE silver.Silver_Recipe
ADD 
    product_category AS 
        CASE 
            WHEN CHARINDEX('-', recipe_id) > 0 
            THEN LEFT(recipe_id, CHARINDEX('-', recipe_id) - 1)
            ELSE NULL
        END,
    product_size AS 
        CASE 
            WHEN LEN(recipe_id) - LEN(REPLACE(recipe_id, '-', '')) >= 2
            THEN RIGHT(recipe_id, CHARINDEX('-', REVERSE(recipe_id)) - 1)
            ELSE NULL
        END;
*/

-- Optional: Validate that quantities are within reasonable ranges
-- Adjust the range based on your business knowledge
/*
UPDATE silver.Silver_Recipe
SET is_valid_quantity = 0
WHERE quantity > 1000 OR quantity < 0.1;
*/

-- Optional: Remove invalid or problematic rows
-- Use with caution - backup first!
/*
-- Remove rows with invalid quantity
DELETE FROM silver.Silver_Recipe 
WHERE is_valid_quantity = 0;

-- Remove duplicate recipe-ingredient combinations (keep first)
WITH DuplicateCTE AS (
    SELECT 
        row_id,
        ROW_NUMBER() OVER (
            PARTITION BY recipe_id, ing_id 
            ORDER BY row_id
        ) as rn
    FROM silver.Silver_Recipe
    WHERE recipe_id IS NOT NULL AND ing_id IS NOT NULL
)
DELETE FROM silver.Silver_Recipe
WHERE row_id IN (
    SELECT row_id FROM DuplicateCTE WHERE rn > 1
);

-- Remove rows with invalid references
DELETE FROM silver.Silver_Recipe 
WHERE has_valid_ingredient = 0;
*/

-- Optional: Add total ingredients per recipe for validation
/*
SELECT 
    recipe_id,
    COUNT(DISTINCT ing_id) as num_ingredients,
    SUM(quantity) as total_quantity
FROM silver.Silver_Recipe
GROUP BY recipe_id
ORDER BY recipe_id;
*/


/*

===============================================================================

Silver Rota Cleaning Script

===============================================================================

Purpose:

    - Remove quotes from text fields.

    - Trim leading/trailing spaces.

    - Validate date format and ensure proper DATE type.

    - Ensure foreign key references exist (shift_id, staff_id).

    - Check for duplicate rota entries.

===============================================================================

*/

-- Remove quotes and trim spaces from text columns
UPDATE silver.Silver_Rota
SET 
    rota_id = TRIM(REPLACE(rota_id, '"', '')),
    shift_id = TRIM(REPLACE(shift_id, '"', '')),
    staff_id = TRIM(REPLACE(staff_id, '"', ''))
WHERE rota_id LIKE '%"%' 
   OR shift_id LIKE '%"%' 
   OR staff_id LIKE '%"%';

-- Trim all text columns even if no quotes
UPDATE silver.Silver_Rota
SET 
    rota_id = TRIM(rota_id),
    shift_id = TRIM(shift_id),
    staff_id = TRIM(staff_id),
    date = TRIM(date);

-- Validate and convert date to proper DATE format
UPDATE silver.Silver_Rota
SET date = CASE 
              WHEN ISDATE(date) = 1 
              THEN CONVERT(VARCHAR(10), CAST(date AS DATE), 120)  -- YYYY-MM-DD format
              ELSE NULL
           END
WHERE date IS NOT NULL;



-- Optional: Check for duplicate rota entries (same date, shift, staff)
-- Add a unique constraint or flag duplicates

ALTER TABLE silver.Silver_Rota
ADD is_duplicate BIT DEFAULT 0;

WITH DuplicateCTE AS (
    SELECT 
        row_id,
        ROW_NUMBER() OVER (
            PARTITION BY date, shift_id, staff_id 
            ORDER BY row_id
        ) as rn
    FROM silver.Silver_Rota
    WHERE date IS NOT NULL
)
UPDATE silver.Silver_Rota
SET is_duplicate = 1
FROM silver.Silver_Rota r
INNER JOIN DuplicateCTE d ON r.row_id = d.row_id
WHERE d.rn > 1;


-- Optional: Remove invalid or duplicate entries
-- Use with caution - backup first!

-- Remove rows with invalid dates
DELETE FROM silver.Silver_Rota 
WHERE is_valid_date = 0;

-- Remove duplicate entries (keep only the first occurrence)
WITH DuplicateCTE AS (
    SELECT 
        row_id,
        ROW_NUMBER() OVER (
            PARTITION BY date, shift_id, staff_id 
            ORDER BY row_id
        ) as rn
    FROM silver.Silver_Rota
    WHERE date IS NOT NULL
)
DELETE FROM silver.Silver_Rota
WHERE row_id IN (
    SELECT row_id FROM DuplicateCTE WHERE rn > 1
);






/*

===============================================================================

Silver Shift Cleaning Script

===============================================================================

Purpose:

    - Remove quotes from text fields.

    - Trim leading/trailing spaces.

    - Normalize day_of_week casing (capitalize first letter, rest lowercase).

    - Validate time formats.

    - Ensure end_time is after start_time.

===============================================================================

*/

-- Remove quotes and trim spaces from text columns
UPDATE silver.Silver_Shift
SET 
    shift_id = TRIM(REPLACE(shift_id, '"', '')),
    day_of_week = TRIM(REPLACE(day_of_week, '"', ''))
WHERE shift_id LIKE '%"%' OR day_of_week LIKE '%"%';

-- Trim all text columns even if no quotes
UPDATE silver.Silver_Shift
SET 
    shift_id = TRIM(shift_id),
    day_of_week = TRIM(day_of_week),
    start_time = TRIM(start_time),
    end_time = TRIM(end_time);

-- Normalize day_of_week casing (capitalize first letter, rest lowercase)
UPDATE silver.Silver_Shift
SET day_of_week = CONCAT(
    UPPER(LEFT(day_of_week, 1)),
    LOWER(SUBSTRING(day_of_week, 2, LEN(day_of_week)))
)
WHERE day_of_week IS NOT NULL;

-- Validate and standardize day_of_week values
UPDATE silver.Silver_Shift
SET day_of_week = 
    CASE LOWER(TRIM(day_of_week))
        WHEN 'mon' THEN 'Monday'
        WHEN 'tue' THEN 'Tuesday'
        WHEN 'wed' THEN 'Wednesday'
        WHEN 'thu' THEN 'Thursday'
        WHEN 'fri' THEN 'Friday'
        WHEN 'sat' THEN 'Saturday'
        WHEN 'sun' THEN 'Sunday'
        ELSE day_of_week
    END
WHERE day_of_week IS NOT NULL;

-- Validate time formats (convert to proper TIME format if needed)
UPDATE silver.Silver_Shift
SET 
    start_time = CASE 
                    WHEN TRY_CAST(start_time AS TIME) IS NOT NULL 
                    THEN CONVERT(VARCHAR(8), CAST(start_time AS TIME), 108)
                    ELSE start_time
                 END,
    end_time = CASE 
                  WHEN TRY_CAST(end_time AS TIME) IS NOT NULL 
                  THEN CONVERT(VARCHAR(8), CAST(end_time AS TIME), 108)
                  ELSE end_time
               END
WHERE start_time IS NOT NULL AND end_time IS NOT NULL;


/*

===============================================================================

Silver Staff Cleaning Script

===============================================================================

Purpose:

    - Remove quotes from text fields.

    - Trim leading/trailing spaces.

    - Normalize position casing to Title Case.

    - Ensure sal_per_hour is numeric.

===============================================================================

*/

-- Remove quotes and trim spaces from text columns
UPDATE silver.Silver_Staff
SET 
    first_name = TRIM(REPLACE(first_name, '"', '')),
    last_name = TRIM(REPLACE(last_name, '"', '')),
    position = TRIM(REPLACE(position, '"', ''))
WHERE first_name LIKE '%"%' 
   OR last_name LIKE '%"%' 
   OR position LIKE '%"%';

-- Trim spaces even if no quotes
UPDATE silver.Silver_Staff
SET 
    first_name = TRIM(first_name),
    last_name = TRIM(last_name),
    position = TRIM(position);

-- Normalize position casing (make first letter uppercase, rest lowercase)
UPDATE silver.Silver_Staff
SET position = CONCAT(
    UPPER(LEFT(position, 1)),
    LOWER(SUBSTRING(position, 2, LEN(position)))
)
WHERE position IS NOT NULL;

-- Optional: Validate sal_per_hour is numeric and positive
-- This will convert text to decimal if needed
UPDATE silver.Silver_Staff
SET sal_per_hour = TRY_CAST(TRIM(sal_per_hour) AS DECIMAL(10,2))
WHERE TRY_CAST(TRIM(sal_per_hour) AS DECIMAL(10,2)) IS NOT NULL;

-- Remove rows with invalid salary if needed
-- DELETE FROM silver.Silver_Staff 
-- WHERE sal_per_hour IS NULL OR sal_per_hour <= 0;
