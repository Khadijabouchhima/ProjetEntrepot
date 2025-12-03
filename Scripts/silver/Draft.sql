hello
/*
===============================================================================
Silver Ingredients Cleaning Script
===============================================================================
Purpose:
    - Remove quotes from ing_name.
    - Trim leading/trailing spaces.
    - Normalize casing to Title Case (optional).
===============================================================================
*/
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.Silver_Ingredients';
        TRUNCATE TABLE silver.Silver_Ingredients;

        PRINT '>> Inserting Data Into: silver.Silver_Ingredients';
        INSERT INTO silver.Silver_Ingredients (
            ing_id,
            ing_name,
            ing_weight,
            ing_meas,
            ing_price
        )
        SELECT DISTINCT
            TRIM(ing_id) AS ing_id,
            TRIM(REPLACE(ing_name, '"', '')) AS ing_name,
            ISNULL(ing_weight,0) AS ing_weight,
            TRIM(ing_meas) AS ing_meas,
            ISNULL(ing_price,0) AS ing_price
        FROM Bronze.Bronze_Ingredients
        WHERE ing_id IS NOT NULL;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

/*
===============================================================================
Silver Inventory Cleaning Script
===============================================================================
    Key points:

        Trims spaces from inv_id and ing_id.
        
        Aggregates quantities if duplicates exist in Bronze.
        
        Joins with ingredients for total_cost.
        
        Assumes ingredients table has ing_id and ing_price.
===============================================================================
*/
-- Insert cleaned and aggregated data from Bronze into Silver
INSERT INTO silver_inventory (inv_id, ing_id, quantity, total_cost)
SELECT
    LTRIM(RTRIM(b.inv_id)) AS inv_id,
    LTRIM(RTRIM(b.ing_id)) AS ing_id,
    SUM(CAST(b.quantity AS INT)) AS quantity,
    SUM(CAST(b.quantity AS INT) * i.ing_price) AS total_cost
FROM bronze_inventory b
LEFT JOIN ingredients i
    ON LTRIM(RTRIM(b.ing_id)) = i.ing_id
GROUP BY
    LTRIM(RTRIM(b.inv_id)),
    LTRIM(RTRIM(b.ing_id));




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
