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


