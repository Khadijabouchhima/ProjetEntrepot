/*
    Table: Dim_Staff
    Purpose: Store staff information.
    Warning: Do NOT re-execute unless you intend to drop and recreate the table.
*/

CREATE TABLE Dim_Staff (
    Staff_ID       VARCHAR(10) PRIMARY KEY,
    First_Name     VARCHAR(50) NOT NULL,
    Last_Name      VARCHAR(50) NOT NULL,
    Full_Name      VARCHAR(100) NULL,
    Position       VARCHAR(50) NOT NULL,
    Hourly_Salary  DECIMAL(10,2) NOT NULL,
    Shift_Count    INT NULL
);
