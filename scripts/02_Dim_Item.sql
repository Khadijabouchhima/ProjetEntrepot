/*
    Table: Dim_Item
    Purpose: Store all items sold in Bloom Coffee Shop.
    Warning: Do NOT re-execute unless you intend to drop and recreate the table.
*/

CREATE TABLE Dim_Item (
    Item_ID       VARCHAR(10) PRIMARY KEY,
    SKU           VARCHAR(20) NOT NULL,
    Item_Name     VARCHAR(100) NOT NULL,
    Category      VARCHAR(50) NOT NULL,
    Item_Size     VARCHAR(20) NULL,
    Price         DECIMAL(10,2) NOT NULL,
    Temperature   VARCHAR(20) NULL,
    Cost          DECIMAL(10,2) NULL,
    Recipe_ID     VARCHAR(10) NULL
);
