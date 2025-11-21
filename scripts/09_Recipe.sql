/*
    Table: Recipe
    Purpose: Map items to ingredients with quantities.
    Warning: Do NOT re-execute unless you intend to drop and recreate the table.
*/

CREATE TABLE Recipe (
    Recipe_ID   VARCHAR(10) NOT NULL,
    Ingredient_ID VARCHAR(10) NOT NULL,
    Quantity    DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (Recipe_ID, Ingredient_ID),
    FOREIGN KEY (Ingredient_ID) REFERENCES Dim_Ingredient(Ingredient_ID),
    FOREIGN KEY (Recipe_ID) REFERENCES Dim_Item(Item_ID)
);
