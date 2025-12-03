/*
===============================================================================
bronze Layer Quality Checks – Bloom Coffee Shop
===============================================================================
Script Purpose:
    This script performs data quality checks on the bronze tables to ensure:
    - Null or duplicate primary/surrogate keys.
    - Unwanted spaces in string fields.
    - Invalid numeric values.
    - Date and time consistency.
    - Referential consistency between related tables.
===============================================================================
*/

-- ====================================================================
-- bronze_Ingredients
-- ====================================================================
-- Check for NULLs or Duplicates in ing_id
SELECT ing_id, COUNT(*) 
FROM bronze.bronze_Ingredients
GROUP BY ing_id
HAVING COUNT(*) > 1 OR ing_id IS NULL;

-- Check for unwanted spaces in string fields
SELECT ing_name 
FROM bronze.bronze_Ingredients
WHERE ing_name != TRIM(ing_name)
   OR ing_meas != TRIM(ing_meas);

-- Check for negative or NULL prices
SELECT ing_price 
FROM bronze.bronze_Ingredients
WHERE ing_price < 0 OR ing_price IS NULL;

-- ====================================================================
-- bronze_Inventory
-- ====================================================================
-- Check for NULLs or Duplicates in inv_id
SELECT inv_id, COUNT(*) 
FROM bronze.bronze_Inventory
GROUP BY inv_id
HAVING COUNT(*) > 1 OR inv_id IS NULL;

-- Check for negative or NULL quantities
SELECT quantity 
FROM bronze.bronze_Inventory
WHERE quantity < 0 OR quantity IS NULL;

-- ====================================================================
-- bronze_Items
-- ====================================================================
-- Check for NULLs or Duplicates in item_id
SELECT item_id, COUNT(*) 
FROM bronze.bronze_Items
GROUP BY item_id
HAVING COUNT(*) > 1 OR item_id IS NULL;

-- Check for unwanted spaces
SELECT sku, item_name, item_cat, item_size 
FROM bronze.bronze_Items
WHERE sku != TRIM(sku)
   OR item_name != TRIM(item_name)
   OR item_cat != TRIM(item_cat)
   OR item_size != TRIM(item_size);

-- Check for negative or NULL prices
SELECT item_price 
FROM bronze.bronze_Items
WHERE item_price < 0 OR item_price IS NULL;

-- ====================================================================
-- bronze_Orders
-- ====================================================================
-- Check for NULLs or Duplicates in row_id
SELECT row_id, COUNT(*) 
FROM bronze.bronze_Orders
GROUP BY row_id
HAVING COUNT(*) > 1 OR row_id IS NULL;

-- Check for invalid dates
SELECT * 
FROM bronze.bronze_Orders
WHERE created_at IS NULL
   OR created_at > GETDATE();

-- Check for negative or NULL quantity
SELECT quantity 
FROM bronze.bronze_Orders
WHERE quantity <= 0 OR quantity IS NULL;

-- ====================================================================
-- bronze_Recipe
-- ====================================================================
-- Check for NULLs or Duplicates in row_id
SELECT row_id, COUNT(*) 
FROM bronze.bronze_Recipe
GROUP BY row_id
HAVING COUNT(*) > 1 OR row_id IS NULL;

-- Check for negative or NULL quantities
SELECT quantity 
FROM bronze.bronze_Recipe
WHERE quantity <= 0 OR quantity IS NULL;

-- Check referential consistency: ing_id exists in Ingredients
SELECT r.ing_id 
FROM bronze.bronze_Recipe r
LEFT JOIN bronze.bronze_Ingredients i
    ON r.ing_id = i.ing_id
WHERE i.ing_id IS NULL;

-- ====================================================================
-- bronze_Staff
-- ====================================================================
-- Check for NULLs or Duplicates in staff_id
SELECT staff_id, COUNT(*) 
FROM bronze.bronze_Staff
GROUP BY staff_id
HAVING COUNT(*) > 1 OR staff_id IS NULL;

-- Check for unwanted spaces
SELECT first_name, last_name, position 
FROM bronze.bronze_Staff
WHERE first_name != TRIM(first_name)
   OR last_name != TRIM(last_name)
   OR position != TRIM(position);

-- Check for negative or NULL salary
SELECT sal_per_hour 
FROM bronze.bronze_Staff
WHERE sal_per_hour < 0 OR sal_per_hour IS NULL;

-- ====================================================================
-- bronze_Rota
-- ====================================================================
-- Check for NULLs or Duplicates in row_id
SELECT row_id, COUNT(*) 
FROM bronze.bronze_Rota
GROUP BY row_id
HAVING COUNT(*) > 1 OR row_id IS NULL;

-- Check for invalid dates
SELECT * 
FROM bronze.bronze_Rota
WHERE date IS NULL
   OR date > GETDATE();

-- Check referential consistency: staff_id exists in Staff
SELECT r.staff_id 
FROM bronze.bronze_Rota r
LEFT JOIN bronze.bronze_Staff s
    ON r.staff_id = s.staff_id
WHERE s.staff_id IS NULL;

-- ====================================================================
-- bronze_Shift
-- ====================================================================
-- Check for NULLs or Duplicates in shift_id
SELECT shift_id, COUNT(*) 
FROM bronze.bronze_Shift
GROUP BY shift_id
HAVING COUNT(*) > 1 OR shift_id IS NULL;

-- Check for unwanted spaces in day_of_week
SELECT day_of_week 
FROM bronze.bronze_Shift
WHERE day_of_week != TRIM(day_of_week);

-- Check for invalid time ranges (start_time > end_time)
SELECT * 
FROM bronze.bronze_Shift
WHERE start_time > end_time;
