/*
    Table: Dim_Ingredient
    Schema: Dim
    Purpose: Store all ingredients used in recipes.
    Warning: This script is for documentation purposes. DO NOT re-execute in SSMS 
             unless you intend to drop and recreate the table.
*/

CREATE TABLE Dim_Ingredient (
    Ingredient_ID     VARCHAR(10) PRIMARY KEY,
    Ingredient_Name   VARCHAR(100) NOT NULL,
    Weight            DECIMAL(10,2) NOT NULL,
    Unit_Measure      VARCHAR(20) NOT NULL,
    Unit_Price        DECIMAL(10,2) NOT NULL,
    Total_Cost        DECIMAL(10,2) NULL,
    Ingredient_Type   VARCHAR(50) NULL
);
