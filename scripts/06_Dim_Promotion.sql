/*
    Table: Dim_Promotion
    Purpose: Store promotion campaigns and discounts.
    Warning: Do NOT re-execute unless you intend to drop and recreate the table.
*/

CREATE TABLE Dim_Promotion (
    Promotion_ID     VARCHAR(10) PRIMARY KEY,
    Promotion_Name   VARCHAR(100) NOT NULL,
    Promotion_Type   VARCHAR(50) NOT NULL,
    Start_Date       DATE NOT NULL,
    End_Date         DATE NOT NULL,
    Applicable_Items VARCHAR(200) NULL,
    Discount_Value   DECIMAL(10,2) NULL
);
