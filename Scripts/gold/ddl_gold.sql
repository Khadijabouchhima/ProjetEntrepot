IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Gold')
    EXEC('CREATE SCHEMA Gold');
GO

----------------------- Dimensions -------------------------

-- dim date

------------------------------------------------------------

CREATE TABLE Gold.dim_date (
    date_key        INT PRIMARY KEY,     -- YYYYMMDD
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

-- dim time

------------------------------------------------------------

CREATE TABLE Gold.dim_time (
    time_key       INT PRIMARY KEY,  -- HHMMSS
    full_time      TIME,
    hour           INT,
    minute         INT,
    second         INT,
    am_pm          VARCHAR(2),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
------------------------------------------------------------

-- dim item 

------------------------------------------------------------

CREATE TABLE Gold.dim_items (
    item_key        INT IDENTITY(1,1) PRIMARY KEY,  -- Surrogate key
    item_id         VARCHAR(50),                    -- Business key from Silver_Items
    sku             VARCHAR(50),
    cat_code    VARCHAR(20),
    item_code   VARCHAR(20),
    size_code   VARCHAR(20),
    item_name       VARCHAR(100),
    item_cat        VARCHAR(50),
    item_price      DECIMAL(10,2),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
------------------------------------------------------------

-- dim ingredient 

------------------------------------------------------------

CREATE TABLE Gold.dim_ingredients (
    ingredient_key   INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate key
    ing_id           VARCHAR(50),                   -- Business key from Silver_Ingredients
    ing_name         VARCHAR(100),
    ing_weight       DECIMAL(10,2),
    ing_meas         VARCHAR(20),
    ing_price        DECIMAL(10,2),
    dwh_create_date  DATETIME2 DEFAULT GETDATE()
);

------------------------------------------------------------

-- dim staff

------------------------------------------------------------

CREATE TABLE Gold.dim_staff (
    staff_key       INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate key
    staff_id        VARCHAR(50),                   -- Business key from Silver_Staff
    first_name      VARCHAR(50),
    last_name       VARCHAR(50),
    position        VARCHAR(50),
    sal_per_hour    DECIMAL(10,2),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
------------------------------------------------------------

-- dim shift 

------------------------------------------------------------

CREATE TABLE Gold.dim_shift (
    shift_key       INT IDENTITY(1,1) PRIMARY KEY,  -- Surrogate key
    shift_id        VARCHAR(50),                    -- Business key from Silver_Shift
    day_of_week     INT,                            -- 1 = Monday, 7 = Sunday
    day_name        VARCHAR(20),
    start_time      TIME,
    end_time        TIME,
    shift_period    VARCHAR(50),                    -- Morning, afternoon, evening or night
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

------------------------------------------------------------

-- dim rota 

------------------------------------------------------------
CREATE TABLE Gold.dim_rota (
    rota_key       INT PRIMARY KEY,  -- surrogate key
    rota_id        VARCHAR(50),                    -- source system id
    date_key       INT,                            -- FK → dim_date
    time_key       INT,                            -- FK → dim_time (shift start time)
    shift_key      VARCHAR(50),                    -- FK → dim_shift
    staff_key    VARCHAR(50),                    -- FK → dim_staff
    dwh_create_date DATETIME2 DEFAULT GETDATE()

);

----------------------- Facts ------------------------------

------------------------------------------------------------

-- fact orders 

------------------------------------------------------------

CREATE TABLE Gold.fact_orders (
    order_key   INT             NOT NULL,
    date_key    INT             NOT NULL,
    time_key    INT             NOT NULL,
    item_key    INT             NOT NULL,
    order_id    VARCHAR(50)     NULL,
    quantity    INT             NOT NULL,
    item_price  DECIMAL(10, 2)  NOT NULL,
    total_price DECIMAL(10, 2)  NOT NULL,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
    
    CONSTRAINT PK_fact_orders PRIMARY KEY CLUSTERED (order_key ASC),
    
    CONSTRAINT FK_fact_orders_date FOREIGN KEY (date_key) 
        REFERENCES Gold.dim_date (date_key),
    CONSTRAINT FK_fact_orders_item FOREIGN KEY (item_key) 
        REFERENCES Gold.dim_items (item_key),
    CONSTRAINT FK_fact_orders_time FOREIGN KEY (time_key) 
        REFERENCES Gold.dim_time (time_key)
);

------------------------------------------------------------

-- fact labor 

------------------------------------------------------------

CREATE TABLE [Gold].[fact_labor] (
    [rota_key]       INT IDENTITY(1,1) PRIMARY KEY,  -- surrogate key
    [date_key]       INT NOT NULL,                  -- FK → dim_date
    [shift_key]      INT NOT NULL,                  -- FK → dim_shift
    [staff_key]      INT NOT NULL,                  -- FK → dim_staff
    [hours_worked]   DECIMAL(5,2) NOT NULL,        -- shift duration in hours
    [labor_cost]     DECIMAL(10,2) NOT NULL,       -- hours_worked * salary per hour
    dwh_create_date DATETIME2 DEFAULT GETDATE()

    CONSTRAINT FK_fact_rota_date  FOREIGN KEY ([date_key])  REFERENCES [Gold].[dim_date] ([date_key]),
    CONSTRAINT FK_fact_rota_shift FOREIGN KEY ([shift_key]) REFERENCES [Gold].[dim_shift] ([shift_key]),
    CONSTRAINT FK_fact_rota_staff FOREIGN KEY ([staff_key]) REFERENCES [Gold].[dim_staff] ([staff_key])
);


------------------------------------------------------------

-- fact recipe

------------------------------------------------------------

CREATE TABLE Gold.fact_recipe (
    recipe_key      INT IDENTITY(1,1) PRIMARY KEY,
    item_key             INT NOT NULL,                   
    ingredient_key              INT NOT NULL,                   
    item_inventory       DECIMAL(18,4) NOT NULL,         
    quantity_needed      DECIMAL(18,4) NOT NULL,
    shortage_quantity    DECIMAL(18,4) NOT NULL, 
    cost_per_unit        DECIMAL(18,4) NOT NULL,           
    cost                 DECIMAL(18,4) NOT NULL,         
    is_available         BIT NOT NULL,                   
    is_recipe_feasible   BIT NOT NULL,                   
    dwh_load_date        DATETIME2 DEFAULT GETDATE(),  
    CONSTRAINT FK_fact_recipe_item  FOREIGN KEY (item_key)  REFERENCES Gold.dim_items (item_key),
    CONSTRAINT FK_fact_recipe_ing FOREIGN KEY (ingredient_key) REFERENCES Gold.dim_ingredients(ingredient_key),
);


