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


