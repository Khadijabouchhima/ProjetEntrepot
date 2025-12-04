-- dim date
-------------------------------------------------------------
-- Load dim_date
-------------------------------------------------------------
DECLARE @start_time DATETIME2, @end_time DATETIME2;

SET @start_time = GETDATE();
PRINT '================================================';
PRINT 'Starting Gold Layer Load: dim_date';
PRINT '================================================';

PRINT '>> Truncating Table: gold.dim_date';
TRUNCATE TABLE gold.dim_date;

PRINT '>> Inserting Data Into: gold.dim_date';
INSERT INTO gold.dim_date (
    date_key,
    full_date,
    year,
    quarter,
    month,
    month_name,
    day,
    day_of_week,
    day_name,
    week_of_year
)
SELECT
    CONVERT(INT, FORMAT(order_date, 'yyyyMMdd')) AS date_key,
    order_date AS full_date,
    YEAR(order_date) AS year,
    DATEPART(QUARTER, order_date) AS quarter,
    MONTH(order_date) AS month,
    DATENAME(MONTH, order_date) AS month_name,
    DAY(order_date) AS day,
    DATEPART(WEEKDAY, order_date) AS day_of_week,
    DATENAME(WEEKDAY, order_date) AS day_name,
    DATEPART(WEEK, order_date) AS week_of_year
FROM silver.Silver_Orders
GROUP BY order_date
ORDER BY order_date;
SET @end_time = GETDATE();
PRINT '>> dim_date Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
PRINT '================================================';
PRINT 'Gold Layer Load: dim_date Completed Successfully';
PRINT '================================================';

-- dim time 
-------------------------------------------------------------
-- Load dim_time
-------------------------------------------------------------
DECLARE @start_time DATETIME2, @end_time DATETIME2;

SET @start_time = GETDATE();
PRINT '================================================';
PRINT 'Starting Gold Layer Load: dim_time';
PRINT '================================================';

PRINT '>> Truncating Table: gold.dim_time';
TRUNCATE TABLE gold.dim_time;

PRINT '>> Inserting Data Into: gold.dim_time';
INSERT INTO gold.dim_time (
  time_key,
  full_time,
  hour,
  minute,
  second,
  am_pm
)
SELECT DISTINCT
    DATEPART(HOUR, order_time) * 10000
  + DATEPART(MINUTE, order_time) * 100
  + DATEPART(SECOND, order_time) AS time_key,
    CAST(order_time AS TIME) AS full_time,
    DATEPART(HOUR, order_time) AS hour,
    DATEPART(MINUTE, order_time) AS minute,
    DATEPART(SECOND, order_time) AS second,
    CASE WHEN DATEPART(HOUR, order_time) < 12 THEN 'AM' ELSE 'PM' END AS am_pm
FROM silver.Silver_Orders
SET @end_time = GETDATE();
PRINT '>> dim_time Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
PRINT '================================================';
PRINT 'Gold Layer Load: dim_time Completed Successfully';
PRINT '================================================';

-- dim items 
-------------------------------------------------------------
-- Load dim_items
-------------------------------------------------------------
DECLARE @start_time DATETIME2, @end_time DATETIME2;

SET @start_time = GETDATE();
PRINT '================================================';
PRINT 'Starting Gold Layer Load: dim_items';
PRINT '================================================';

PRINT '>> Truncating Table: gold.dim_items';
TRUNCATE TABLE gold.dim_items;

PRINT '>> Inserting Data Into: gold.dim_items';
INSERT INTO gold.dim_items (
    item_id,
    sku,
    cat_code,
    item_code,
    size_code,
    item_name,
    item_cat,
    item_price
)
SELECT DISTINCT
    item_id,
    sku,
    sku_cat_code,
    sku_item_code,
    sku_size_code,
    item_name,
    item_cat,
    item_price
FROM silver.Silver_Items
SET @end_time = GETDATE();
PRINT '>> dim_items Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
PRINT '================================================';
PRINT 'Gold Layer Load: dim_items Completed Successfully';
PRINT '================================================';

-- dim ingredients 
-------------------------------------------------------------
-- Load dim_ingredients
-------------------------------------------------------------
DECLARE @start_time DATETIME2, @end_time DATETIME2;

SET @start_time = GETDATE();
PRINT '================================================';
PRINT 'Starting Gold Layer Load: dim_ingredients';
PRINT '================================================';

PRINT '>> Truncating Table: gold.dim_ingredient';
TRUNCATE TABLE gold.dim_ingredients;

PRINT '>> Inserting Data Into: gold.dim_ingredients';
INSERT INTO gold.dim_ingredients (
    ing_id,
    ing_name,
    ing_weight,
    ing_meas,
    ing_price
)
SELECT DISTINCT
    ing_id,
    ing_name,
    ing_weight,
    ing_meas,
    ing_price
FROM silver.Silver_Ingredients
SET @end_time = GETDATE();
PRINT '>> dim_ingredients Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
PRINT '================================================';
PRINT 'Gold Layer Load: dim_ingredients Completed Successfully';
PRINT '================================================';


-- dim staff
-------------------------------------------------------------
-- Load dim_staff
-------------------------------------------------------------
DECLARE @start_time DATETIME2, @end_time DATETIME2;

SET @start_time = GETDATE();
PRINT '================================================';
PRINT 'Starting Gold Layer Load: dim_staff';
PRINT '================================================';

PRINT '>> Truncating Table: gold.dim_staff';
TRUNCATE TABLE gold.dim_staff;

PRINT '>> Inserting Data Into: gold.dim_staff';

INSERT INTO gold.dim_staff (
    staff_id,
    first_name,
    last_name,
    position,
    sal_per_hour
)
SELECT DISTINCT
    staff_id,
    first_name,
    last_name,
    position,
    sal_per_hour
FROM silver.Silver_Staff
SET @end_time = GETDATE();
PRINT '>> dim_staff Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
PRINT '================================================';
PRINT 'Gold Layer Load: dim_staff Completed Successfully';
PRINT '================================================';

-- dim shift 
-------------------------------------------------------------
-- Load dim_shift
-------------------------------------------------------------
DECLARE @start_time DATETIME2, @end_time DATETIME2;

SET @start_time = GETDATE();
PRINT '================================================';
PRINT 'Starting Gold Layer Load: dim_shift';
PRINT '================================================';

PRINT '>> Truncating Table: gold.dim_shift';
TRUNCATE TABLE gold.dim_shift;

PRINT '>> Inserting Data Into: gold.dim_shift';
  
INSERT INTO gold.dim_shift (
    shift_id,
    day_of_week,
    day_name,
    start_time,
    end_time,
    shift_period
)
SELECT DISTINCT
    shift_id,
    CASE day_of_week
        WHEN 'Sunday' THEN 1
        WHEN 'Monday' THEN 2
        WHEN 'Tuesday' THEN 3
        WHEN 'Wednesday' THEN 4
        WHEN 'Thursday' THEN 5
        WHEN 'Friday' THEN 6
        WHEN 'Saturday' THEN 7
        ELSE NULL
    END AS day_of_week,
    day_of_week as day_name,
    start_time,
    end_time,
    CASE 
        WHEN start_time >= '06:00' AND start_time < '12:00' THEN 'Morning'
        WHEN start_time >= '12:00' AND start_time < '18:00' THEN 'Afternoon'
        WHEN start_time >= '18:00' AND start_time < '00:00' THEN 'Evening'
        ELSE 'Night'
    END AS shift_period
FROM silver.Silver_Shift
SET @end_time = GETDATE();
PRINT '>> dim_shift Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
PRINT '================================================';
PRINT 'Gold Layer Load: dim_shift Completed Successfully';
PRINT '================================================';

-- dim rota
-------------------------------------------------------------
-- Load dim_rota
-------------------------------------------------------------
DECLARE @start_time DATETIME2, @end_time DATETIME2;

SET @start_time = GETDATE();
PRINT '================================================';
PRINT 'Starting Gold Layer Load: dim_rota';
PRINT '================================================';

PRINT '>> Truncating Table: gold.dim_rota';
TRUNCATE TABLE gold.dim_rota;

PRINT '>> Inserting Data Into: gold.dim_rota';
INSERT INTO gold.dim_rota (
    rota_key,
    rota_id,
    date_key,
    time_key,
    shift_key,
    staff_key
)
SELECT
    r.row_id,
    r.rota_id,
    d.date_key,
    (
        SELECT TOP 1 t.time_key
        FROM gold.dim_time t
        WHERE t.full_time >= sh.start_time
          AND t.full_time < sh.end_time
        ORDER BY t.full_time
    ) AS time_key,
    sh.shift_key,
    st.staff_key
FROM silver.Silver_Rota r
JOIN gold.dim_date d
    ON d.full_date = r.date
JOIN gold.dim_shift sh
    ON sh.shift_id = r.shift_id
JOIN gold.dim_staff st
    ON st.staff_id = r.staff_id
ORDER BY r.row_id;
SET @end_time = GETDATE();

PRINT '>> dim_rota Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
PRINT '================================================';
PRINT 'Gold Layer Load: dim_rota Completed Successfully';
PRINT '================================================';
SET @end_time = GETDATE();

PRINT '>> dim_rota Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
PRINT '================================================';
PRINT 'Gold Layer Load: dim_rota Completed Successfully';
PRINT '================================================';


-------------------------------------------------------------
-- Load fact_orders
-------------------------------------------------------------
DECLARE @start_time DATETIME2, @end_time DATETIME2;

SET @start_time = GETDATE();
PRINT '================================================';
PRINT 'Starting Gold Layer Load: fact_orders';
PRINT '================================================';

-- Truncate existing data
PRINT '>> Truncating Table: gold.fact_orders';
TRUNCATE TABLE gold.fact_orders;

-- Insert new data
PRINT '>> Inserting Data Into: gold.fact_orders';
INSERT INTO gold.fact_orders (
    order_key,
    date_key,
    time_key,
    item_key,
    order_id,
    quantity,
    item_price,
    total_price
)
SELECT
    o.row_id,
    d.date_key,
    t.time_key,
    i.item_key,
    o.order_id,
    o.quantity,
    i.item_price,
    o.quantity * i.item_price AS total_price
FROM silver.Silver_Orders o
LEFT JOIN gold.dim_date d 
    ON d.full_date = o.order_date
LEFT JOIN gold.dim_time t
    ON t.full_time = o.order_time
LEFT JOIN gold.dim_items i
    ON i.item_id = o.item_id;

-- End time and duration
SET @end_time = GETDATE();
PRINT '>> fact_orders Load Duration: ' 
    + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
PRINT '================================================';
PRINT 'Gold Layer Load: fact_orders Completed Successfully';
PRINT '================================================';

