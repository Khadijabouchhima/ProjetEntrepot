/* =======================================================================
   Project:       Bloom Coffee Shop – Data Warehouse
   Layer:         Gold (Star Schema)
   Author:        Khadija Bouchhima
   Description:   Creation of Gold layer dimension and fact tables.
                  Each table includes DROP protection, creation logic,
                  and metadata column dwh_create_date.
   ======================================================================= */

------------------------------------------------------------
-- Ensure Schema Exists
------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Gold')
    EXEC('CREATE SCHEMA Gold');
GO


/* =======================================================================
   DIMENSION TABLES
   ======================================================================= */

------------------------------------------------------------
-- dim_date
-- Purpose: Calendar dimension (YYYYMMDD key)
------------------------------------------------------------
IF OBJECT_ID('Gold.dim_date', 'U') IS NOT NULL DROP TABLE Gold.dim_date;

CREATE TABLE Gold.dim_date (
    date_key        INT PRIMARY KEY,
    full_date       DATE,
    year            INT,
    quarter         INT,
    month           INT,
    month_name      VARCHAR(20),
    day             INT,
    day_of_week     INT,
    day_name        VARCHAR(20),
    week_of_year    INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);


------------------------------------------------------------
-- dim_time
-- Purpose: Time-of-day dimension (HHMMSS key)
------------------------------------------------------------
IF OBJECT_ID('Gold.dim_time', 'U') IS NOT NULL DROP TABLE Gold.dim_time;

CREATE TABLE Gold.dim_time (
    time_key        INT PRIMARY KEY,
    full_time       TIME,
    hour            INT,
    minute          INT,
    second          INT,
    am_pm           VARCHAR(2),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);


------------------------------------------------------------
-- dim_items
-- Purpose: Menu items sold in the coffee shop
------------------------------------------------------------
IF OBJECT_ID('Gold.dim_items', 'U') IS NOT NULL DROP TABLE Gold.dim_items;

CREATE TABLE Gold.dim_items (
    item_key        INT IDENTITY(1,1) PRIMARY KEY,
    item_id         VARCHAR(50),
    sku             VARCHAR(50),
    cat_code        VARCHAR(20),
    item_code       VARCHAR(20),
    size_code       VARCHAR(20),
    item_name       VARCHAR(100),
    item_cat        VARCHAR(50),
    item_price      DECIMAL(10,2),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);


------------------------------------------------------------
-- dim_ingredients
-- Purpose: Ingredient catalog with weight, measurement, and cost
------------------------------------------------------------
IF OBJECT_ID('Gold.dim_ingredients', 'U') IS NOT NULL DROP TABLE Gold.dim_ingredients;

CREATE TABLE Gold.dim_ingredients (
    ingredient_key  INT IDENTITY(1,1) PRIMARY KEY,
    ing_id          VARCHAR(50),
    ing_name        VARCHAR(100),
    ing_weight      DECIMAL(10,2),
    ing_meas        VARCHAR(20),
    ing_price       DECIMAL(10,2),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);


------------------------------------------------------------
-- dim_staff
-- Purpose: Employee roster with roles and hourly rates
------------------------------------------------------------
IF OBJECT_ID('Gold.dim_staff', 'U') IS NOT NULL DROP TABLE Gold.dim_staff;

CREATE TABLE Gold.dim_staff (
    staff_key       INT IDENTITY(1,1) PRIMARY KEY,
    staff_id        VARCHAR(50),
    first_name      VARCHAR(50),
    last_name       VARCHAR(50),
    position        VARCHAR(50),
    sal_per_hour    DECIMAL(10,2),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);


------------------------------------------------------------
-- dim_shift
-- Purpose: Shift configuration storing work periods
------------------------------------------------------------
IF OBJECT_ID('Gold.dim_shift', 'U') IS NOT NULL DROP TABLE Gold.dim_shift;

CREATE TABLE Gold.dim_shift (
    shift_key       INT IDENTITY(1,1) PRIMARY KEY,
    shift_id        VARCHAR(50),
    day_of_week     INT,
    day_name        VARCHAR(20),
    start_time      TIME,
    end_time        TIME,
    shift_period    VARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

/* =======================================================================
   FACT TABLES
   ======================================================================= */

------------------------------------------------------------
-- fact_orders
-- Purpose: Sales facts containing item-level orders
------------------------------------------------------------
IF OBJECT_ID('Gold.fact_orders', 'U') IS NOT NULL DROP TABLE Gold.fact_orders;

CREATE TABLE Gold.fact_orders (
    order_key       INT NOT NULL,
    date_key        INT NOT NULL,
    time_key        INT NOT NULL,
    item_key        INT NOT NULL,
    order_id        VARCHAR(50),
    quantity        INT NOT NULL,
    item_price      DECIMAL(10,2) NOT NULL,
    total_price     DECIMAL(10,2) NOT NULL,
    dwh_create_date DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT PK_fact_orders PRIMARY KEY CLUSTERED (order_key),
    CONSTRAINT FK_fact_orders_date FOREIGN KEY (date_key) REFERENCES Gold.dim_date (date_key),
    CONSTRAINT FK_fact_orders_item FOREIGN KEY (item_key) REFERENCES Gold.dim_items (item_key),
    CONSTRAINT FK_fact_orders_time FOREIGN KEY (time_key) REFERENCES Gold.dim_time (time_key)
);


------------------------------------------------------------
-- fact_labor
-- Purpose: Labor cost facts based on staff and shift data
------------------------------------------------------------
IF OBJECT_ID('Gold.fact_labor', 'U') IS NOT NULL DROP TABLE Gold.fact_labor;

CREATE TABLE Gold.fact_labor (
    rota_key        INT IDENTITY(1,1) PRIMARY KEY,
    date_key        INT NOT NULL,
    shift_key       INT NOT NULL,
    staff_key       INT NOT NULL,
    hours_worked    DECIMAL(5,2) NOT NULL,
    labor_cost      DECIMAL(10,2) NOT NULL,
    dwh_create_date DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT FK_fact_labor_date  FOREIGN KEY (date_key)  REFERENCES Gold.dim_date (date_key),
    CONSTRAINT FK_fact_labor_shift FOREIGN KEY (shift_key) REFERENCES Gold.dim_shift (shift_key),
    CONSTRAINT FK_fact_labor_staff FOREIGN KEY (staff_key) REFERENCES Gold.dim_staff (staff_key)
);


------------------------------------------------------------
-- fact_recipe
-- Purpose: Recipe breakdown and ingredient usage for each item
------------------------------------------------------------
IF OBJECT_ID('Gold.fact_recipe', 'U') IS NOT NULL DROP TABLE Gold.fact_recipe;

CREATE TABLE Gold.fact_recipe (
    recipe_key          INT IDENTITY(1,1) PRIMARY KEY,
    item_key            INT NOT NULL,
    ingredient_key      INT NOT NULL,
    item_inventory      DECIMAL(18,4) NOT NULL,
    quantity_needed     DECIMAL(18,4) NOT NULL,
    shortage_quantity   DECIMAL(18,4) NOT NULL,
    cost_per_unit       DECIMAL(18,4) NOT NULL,
    cost                DECIMAL(18,4) NOT NULL,
    is_available        BIT NOT NULL,
    is_recipe_feasible  BIT NOT NULL,
    dwh_create_date     DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT FK_fact_recipe_item FOREIGN KEY (item_key) REFERENCES Gold.dim_items (item_key),
    CONSTRAINT FK_fact_recipe_ing  FOREIGN KEY (ingredient_key) REFERENCES Gold.dim_ingredients (ingredient_key)
);

