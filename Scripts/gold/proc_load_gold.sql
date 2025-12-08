/**********************************************************************************************
 Author:        Khadija Bouchhima
 Procedure:     etl.Load_Gold_Layer
 Description:   Loads all Gold Layer dimensions and fact tables from Silver Layer.
 Execution:     EXEC etl.Load_Gold_Layer;
 Notes:         - Each section logs start/end times.
               - Each table is truncated before loading.
**********************************************************************************************/
-- First, create the ETL schema if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'etl')
    EXEC('CREATE SCHEMA etl');
GO

CREATE OR ALTER PROCEDURE etl.Load_Gold_Layer
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @start_time DATETIME2, @end_time DATETIME2;

    /********************************************
     =============== DIM DATE ===================
    *********************************************/
    SET @start_time = GETDATE();
    PRINT '================================================';
    PRINT 'Starting Gold Layer Load: dim_date';
    PRINT '================================================';

    TRUNCATE TABLE gold.dim_date;

    INSERT INTO gold.dim_date (
        date_key, full_date, year, quarter, month,
        month_name, day, day_of_week, day_name, week_of_year
    )
    SELECT
        CONVERT(INT, FORMAT(order_date, 'yyyyMMdd')),
        order_date,
        YEAR(order_date),
        DATEPART(QUARTER, order_date),
        MONTH(order_date),
        DATENAME(MONTH, order_date),
        DAY(order_date),
        DATEPART(WEEKDAY, order_date),
        DATENAME(WEEKDAY, order_date),
        DATEPART(WEEK, order_date)
    FROM silver.Silver_Orders
    GROUP BY order_date
    ORDER BY order_date;

    SET @end_time = GETDATE();
    PRINT '>> dim_date Load Duration: '
        + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);
    PRINT '================================================';


    /********************************************
     =============== DIM TIME ===================
    *********************************************/
    SET @start_time = GETDATE();
    PRINT 'Starting Gold Layer Load: dim_time';
    PRINT '================================================';

    TRUNCATE TABLE gold.dim_time;

    INSERT INTO gold.dim_time (
        time_key, full_time, hour, minute, second, am_pm
    )
    SELECT DISTINCT
        DATEPART(HOUR, order_time) * 10000
        + DATEPART(MINUTE, order_time) * 100
        + DATEPART(SECOND, order_time),
        CAST(order_time AS TIME),
        DATEPART(HOUR, order_time),
        DATEPART(MINUTE, order_time),
        DATEPART(SECOND, order_time),
        CASE WHEN DATEPART(HOUR, order_time) < 12 THEN 'AM' ELSE 'PM' END
    FROM silver.Silver_Orders;

    SET @end_time = GETDATE();
    PRINT '>> dim_time Load Duration: '
        + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);
    PRINT '================================================';


    /********************************************
     =============== DIM ITEMS ==================
    *********************************************/
    SET @start_time = GETDATE();
    PRINT 'Starting Gold Layer Load: dim_items';
    PRINT '================================================';

    TRUNCATE TABLE gold.dim_items;

    INSERT INTO gold.dim_items (
        item_id, sku, cat_code, item_code, size_code,
        item_name, item_cat, item_price
    )
    SELECT DISTINCT
        item_id, sku, sku_cat_code, sku_item_code,
        sku_size_code, item_name, item_cat, item_price
    FROM silver.Silver_Items;

    SET @end_time = GETDATE();
    PRINT '>> dim_items Load Duration: '
        + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);
    PRINT '================================================';


    /********************************************
     ========= DIM INGREDIENTS ==================
    *********************************************/
    SET @start_time = GETDATE();
    PRINT 'Starting Gold Layer Load: dim_ingredients';
    PRINT '================================================';

    TRUNCATE TABLE gold.dim_ingredients;

    INSERT INTO gold.dim_ingredients (
        ing_id, ing_name, ing_weight, ing_meas, ing_price
    )
    SELECT DISTINCT
        ing_id, ing_name, ing_weight, ing_meas, ing_price
    FROM silver.Silver_Ingredients;

    SET @end_time = GETDATE();
    PRINT '>> dim_ingredients Load Duration: '
        + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);
    PRINT '================================================';


    /********************************************
     =============== DIM STAFF ==================
    *********************************************/
    SET @start_time = GETDATE();
    PRINT 'Starting Gold Layer Load: dim_staff';
    PRINT '================================================';

    TRUNCATE TABLE gold.dim_staff;

    INSERT INTO gold.dim_staff (
        staff_id, first_name, last_name, position, sal_per_hour
    )
    SELECT DISTINCT
        staff_id, first_name, last_name, position, sal_per_hour
    FROM silver.Silver_Staff;

    SET @end_time = GETDATE();
    PRINT '>> dim_staff Load Duration: '
        + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);
    PRINT '================================================';


    /********************************************
     =============== DIM SHIFT ==================
    *********************************************/
    SET @start_time = GETDATE();
    PRINT 'Starting Gold Layer Load: dim_shift';
    PRINT '================================================';

    TRUNCATE TABLE gold.dim_shift;

    INSERT INTO gold.dim_shift (
        shift_id, day_of_week, day_name,
        start_time, end_time, shift_period
    )
    SELECT DISTINCT
        shift_id,
        CASE day_of_week
            WHEN 'Sunday' THEN 1 WHEN 'Monday' THEN 2 WHEN 'Tuesday' THEN 3
            WHEN 'Wednesday' THEN 4 WHEN 'Thursday' THEN 5
            WHEN 'Friday' THEN 6 WHEN 'Saturday' THEN 7
        END,
        day_of_week,
        start_time,
        end_time,
        CASE 
            WHEN start_time >= '06:00' AND start_time < '12:00' THEN 'Morning'
            WHEN start_time >= '12:00' AND start_time < '18:00' THEN 'Afternoon'
            WHEN start_time >= '18:00' AND start_time < '00:00' THEN 'Evening'
            ELSE 'Night'
        END
    FROM silver.Silver_Shift;

    SET @end_time = GETDATE();
    PRINT '>> dim_shift Load Duration: '
        + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);
    PRINT '================================================';


    /********************************************
     =============== FACT ORDERS =================
    *********************************************/
    SET @start_time = GETDATE();
    PRINT 'Starting Gold Layer Load: fact_orders';
    PRINT '================================================';

    TRUNCATE TABLE gold.fact_orders;

    INSERT INTO gold.fact_orders (
        order_key, date_key, time_key, item_key,
        order_id, quantity, item_price, total_price
    )
    SELECT
        o.row_id,
        d.date_key,
        t.time_key,
        i.item_key,
        o.order_id,
        o.quantity,
        i.item_price,
        o.quantity * i.item_price
    FROM silver.Silver_Orders o
    LEFT JOIN gold.dim_date d ON d.full_date = o.order_date
    LEFT JOIN gold.dim_time t ON t.full_time = o.order_time
    LEFT JOIN gold.dim_items i ON i.item_id = o.item_id;

    SET @end_time = GETDATE();
    PRINT '>> fact_orders Load Duration: '
        + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);
    PRINT '================================================';


    /********************************************
     =============== FACT LABOR ==================
    *********************************************/
    SET @start_time = GETDATE();
    PRINT 'Starting Gold Layer Load: fact_labor';
    PRINT '================================================';

    TRUNCATE TABLE gold.fact_labor;

    INSERT INTO gold.fact_labor (
        date_key, shift_key, staff_key,
        hours_worked, labor_cost
    )
    SELECT
        d.date_key,
        sh.shift_key,
        st.staff_key,
        CAST(DATEDIFF(MINUTE, sh.start_time, sh.end_time) AS DECIMAL(5,2)) / 60.0,
        (CAST(DATEDIFF(MINUTE, sh.start_time, sh.end_time) AS DECIMAL(5,2)) / 60.0) * st.sal_per_hour
    FROM silver.Silver_Rota r
    JOIN gold.dim_date d ON d.full_date = r.date
    JOIN gold.dim_shift sh ON sh.shift_id = r.shift_id
    JOIN gold.dim_staff st ON st.staff_id = r.staff_id;

    SET @end_time = GETDATE();
    PRINT '>> fact_labor Load Duration: '
        + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);
    PRINT '================================================';


    /********************************************
     =============== FACT RECIPE =================
    *********************************************/
    SET @start_time = GETDATE();
    PRINT 'Starting Gold Layer Load: fact_recipe';
    PRINT '================================================';

    TRUNCATE TABLE gold.fact_recipe;

    ;WITH base AS (
        SELECT 
            i.item_key,
            ing.ingredient_key,
            inv.quantity AS item_inventory,
            r.quantity AS quantity_needed,
            CASE 
                WHEN inv.quantity - r.quantity < 0 
                    THEN ABS(inv.quantity - r.quantity)
                ELSE 0
            END AS shortage_quantity,
            ing.ing_price AS cost_per_unit,
            (r.quantity * ing.ing_price) AS cost,
            CASE WHEN inv.quantity >= r.quantity THEN 1 ELSE 0 END AS is_available
        FROM silver.silver_recipe r
        JOIN gold.dim_items i ON i.sku = r.recipe_id
        JOIN gold.dim_ingredients ing ON ing.ing_id = r.ing_id
        JOIN silver.silver_inventory inv ON inv.ing_id = ing.ing_id
    ),
    recipe_status AS (
        SELECT *,
            CASE 
                WHEN MIN(is_available) OVER (PARTITION BY item_key) = 1 
                THEN 1 ELSE 0 
            END AS is_recipe_feasible
        FROM base
    )
    INSERT INTO gold.fact_recipe (
        item_key, ingredient_key, item_inventory, quantity_needed,
        shortage_quantity, cost_per_unit, cost, is_available, is_recipe_feasible
    )
    SELECT 
        item_key, ingredient_key, item_inventory, quantity_needed,
        shortage_quantity, cost_per_unit, cost, is_available, is_recipe_feasible
    FROM recipe_status;

    SET @end_time = GETDATE();
    PRINT '>> fact_recipe Load Duration: '
        + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);
    PRINT '================================================';

END;
GO
END;
GO


