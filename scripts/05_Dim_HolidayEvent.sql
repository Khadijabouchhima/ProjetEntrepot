/*
    Table: Dim_HolidayEvent
    Purpose: Store holiday and event information.
    Warning: Do NOT re-execute unless you intend to drop and recreate the table.
*/

CREATE TABLE Dim_HolidayEvent (
    Holiday_ID    INT PRIMARY KEY,
    Date          DATE NOT NULL,
    Holiday_Name  VARCHAR(100) NOT NULL,
    Is_Known      BIT NOT NULL
);
