/*
    Table: Rota
    Purpose: Map staff to shifts for each date.
    Warning: Do NOT re-execute unless you intend to drop and recreate the table.
*/

CREATE TABLE Rota (
    Rota_ID     VARCHAR(10) NOT NULL,
    Date        DATE NOT NULL,
    Shift_ID    VARCHAR(10) NOT NULL,
    Staff_ID    VARCHAR(10) NOT NULL,
    PRIMARY KEY (Rota_ID, Date, Shift_ID, Staff_ID),
    FOREIGN KEY (Shift_ID) REFERENCES Dim_Shift(Shift_ID),
    FOREIGN KEY (Staff_ID) REFERENCES Dim_Staff(Staff_ID)
);
