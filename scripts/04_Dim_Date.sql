/*
    Table: Dim_Date
    Purpose: Store dates for orders and events.
    Warning: Do NOT re-execute unless you intend to drop and recreate the table.
*/

CREATE TABLE Dim_Date (
    Date_ID       INT PRIMARY KEY,
    Date          DATE NOT NULL,
    DayOfWeek     VARCHAR(20) NOT NULL,
    Month         INT NOT NULL,
    Quarter       INT NOT NULL,
    Year          INT NOT NULL,
    IsWeekend     BIT NULL,
    IsHoliday_Event BIT NULL,
    Event_Name    VARCHAR(100) NULL
);
