/*
    Table: Inventory
    Purpose: Track ingredient stock quantities.
    Warning: Do NOT re-execute unless you intend to drop and recreate the table.
*/

CREATE TABLE Inventory (
    Inv_ID      VARCHAR(10) PRIMARY KEY,
    Ingredient_ID VARCHAR(10) NOT NULL,
    Quantity    DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (Ingredient_ID) REFERENCES Dim_Ingredient(Ingredient_ID)
);
