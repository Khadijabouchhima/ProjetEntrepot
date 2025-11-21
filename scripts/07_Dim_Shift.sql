/*
    Table: Dim_Shift
    Purpose: Store working shifts information.
    Warning: Do NOT re-execute unless you intend to drop and recreate the table.
*/

CREATE TABLE Dim_Shift (
    Shift_ID        VARCHAR(10) PRIMARY KEY,
    DayOfWeek       VARCHAR(20) NOT NULL,
    Start_Time      TIME NOT NULL,
    End_Time        TIME NOT NULL,
    Shift_Name      VARCHAR(50) NULL,
    Shift_Duration  DECIMAL(5,2) NULL,
    Is_Weekend      BIT NULL
);
