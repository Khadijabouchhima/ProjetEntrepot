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

-- Remove quotes and trim spaces
UPDATE silver.Silver_Ingredients
SET ing_name = TRIM(REPLACE(ing_name, '"', ''))
WHERE ing_name LIKE '%"%';

-- Optional: normalize casing to Title Case
-- Note: SQL Server doesn't have built-in title case, but you can use this simple function:
-- (For complex names, consider using a CLR function or handle in ETL)
UPDATE silver.Silver_Ingredients
SET ing_name = CONCAT(
    UPPER(LEFT(ing_name,1)),
    LOWER(SUBSTRING(ing_name,2,LEN(ing_name)))
)
WHERE ing_name IS NOT NULL;
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
