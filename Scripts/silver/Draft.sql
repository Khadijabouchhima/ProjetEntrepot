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
Silver Staff/Shifts Cleaning Script
===============================================================================
Purpose:
    - Trim leading/trailing spaces in shift_id and day_of_week.
    - Normalize day_of_week casing to Title Case.
    - Optional: validate start_time < end_time.
===============================================================================
*/

-- Trim spaces for shift_id and day_of_week
UPDATE Silver.Silver_Shift
SET shift_id = TRIM(shift_id),
    day_of_week = TRIM(day_of_week)
WHERE shift_id LIKE '% %' OR day_of_week LIKE '% %';

-- Normalize day_of_week casing (first letter uppercase, rest lowercase)
UPDATE Silver.Silver_Shift
SET day_of_week = CONCAT(
    UPPER(LEFT(day_of_week,1)),
    LOWER(SUBSTRING(day_of_week,2,LEN(day_of_week)))
)
WHERE day_of_week IS NOT NULL;

-- Optional: check for invalid times (start_time >= end_time)
SELECT *
FROM Silver.Silver_Shift
WHERE start_time >= end_time;

