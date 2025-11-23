/*
    Table: Fact_Orders
    Schema: Fact
    Purpose: Store all transactional orders linking all dimensions.
    Warning: This script is for documentation purposes. DO NOT re-execute in SSMS
             unless you intend to drop and recreate the table.
*/

CREATE TABLE Fact_Orders (
    Order_ID       VARCHAR(10) PRIMARY KEY,
    Date_ID        INT NOT NULL,
    Shift_ID       VARCHAR(10) NOT NULL,
    Staff_ID       VARCHAR(10) NOT NULL,
    Item_ID        VARCHAR(10) NOT NULL,
    Quantity       INT NOT NULL,
    Revenue        DECIMAL(10,2) NOT NULL,
    Promotion_Flag BIT NULL,
    Holiday_Flag   BIT NULL,
    FOREIGN KEY (Date_ID) REFERENCES Dim_Date(Date_ID),
    FOREIGN KEY (Shift_ID) REFERENCES Dim_Shift(Shift_ID),
    FOREIGN KEY (Staff_ID) REFERENCES Dim_Staff(Staff_ID),
    FOREIGN KEY (Item_ID) REFERENCES Dim_Item(Item_ID)
);
