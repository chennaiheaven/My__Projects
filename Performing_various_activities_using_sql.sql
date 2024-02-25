-- Create database
CREATE DATABASE assign3;
USE assign3;

CREATE SCHEMA vet;

/* 1. Create Customers Table */
CREATE TABLE vet.Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    City VARCHAR(20)
);

/* Insert synthetic data into the Customers Table */
INSERT INTO vet.Customers (CustomerID, FirstName, LastName, Email, City)
VALUES
    (1, 'John', 'Doe', 'john.doe@email.com', 'City1'),
    (2, 'Jane', 'Smith', 'jane.smith@email.com', 'City2'),
    (3, 'Bob', 'Johnson', 'bob.johnson@email.com', 'City3'),
    (4, 'Alice', 'Williams', 'alice.williams@email.com', 'City1'),
    (5, 'Charlie', 'Brown', 'charlie.brown@email.com', 'City2'),
    (6, 'David', 'Jones', 'david.jones@email.com', 'City3'),
    (7, 'Eva', 'Miller', 'eva.miller@email.com', 'City1'),
    (8, 'Frank', 'Taylor', 'frank.taylor@email.com', 'City2'),
    (9, 'Grace', 'Martin', 'grace.martin@email.com', 'City3'),
    (10, 'Henry', 'Clark', 'henry.clark@email.com', 'City1');
	SELECT * FROM vet.Customers;

-- 2.Create Pets Table
CREATE TABLE Pets (
    PetID INT PRIMARY KEY,
    CustomerID INT,
    PetName VARCHAR(50),
    PetType VARCHAR(50),
    Birthdate DATE,
    Deathdate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

/* Insert synthetic data into the Pets Table */
INSERT INTO vet.Pets (PetID, CustomerID, PetName, PetType, Birthdate, Deathdate)
VALUES
    (1, 1, 'Buddy', 'Dog', '2019-01-15', '2023-10-22'),
    (2, 1, 'Whiskers', 'Cat', '2020-03-20', '2023-10-22'),
    (3, 2, 'Max', 'Dog', '2020-05-10', '2023-10-22'),
    (4, 2, 'Fluffy', 'Cat', '2021-02-08', NULL),
    (5, 3, 'Spike', 'Hedge Hog', '2018-12-01', NULL),
    (6, 3, 'Mittens', 'Dog', '2022-04-12', NULL),
    (7, 3, 'Coco', 'Dog', '2023-07-05', NULL),
    (8, 4, 'Oreo', 'Cat', '2019-09-30', '2023-10-22'),
    (9, 4, 'Daisy', 'Cat', '2021-11-18', NULL),
    (10, 5, 'Rocky', 'Dog', '2022-01-05', NULL);
SELECT * FROM vet.Pets;

/* 3. Create Appointments Table */
CREATE TABLE vet.Appointments (
    AppointmentID INT PRIMARY KEY,
    CustomerID INT,
    PetID INT,
    AppointmentDate DATETIME,
    AppointmentLenMinutes INT,
    VisitCost DECIMAL(8,2),
    FOREIGN KEY (CustomerID) REFERENCES vet.Customers(CustomerID),
    FOREIGN KEY (PetID) REFERENCES vet.Pets(PetID)
);

-- Insert updated synthetic data into the Appointments table
INSERT INTO vet.Appointments (AppointmentID, CustomerID, PetID, AppointmentDate, AppointmentLenMinutes, VisitCost)
VALUES
    
    -- One pet had four appointments
    (21, 1, 1, '2023-09-05 10:00:00', 30, 50.00),
    (22, 1, 1, '2023-09-10 14:00:00', 45, 75.00),
    (23, 1, 1, '2023-09-15 11:00:00', 60, 100.00),
    (24, 1, 1, '2023-09-20 09:30:00', 30, 50.00),

    -- Two pets had three appointments
    (25, 2, 2, '2023-09-25 15:00:00', 45, 75.00),
    (26, 2, 2, '2023-10-01 12:30:00', 60, 100.00),
    (27, 2, 2, '2023-10-05 10:00:00', 30, 50.00),

    (28, 3, 3, '2023-10-10 14:30:00', 45, 75.00),
    (29, 3, 3, '2023-10-15 11:00:00', 60, 100.00),
    (30, 3, 3, '2023-10-20 09:30:00', 30, 50.00),

    -- Three pets had two appointments
    (31, 4, 4, '2023-10-25 15:00:00', 45, 75.00),
    (32, 4, 4, '2023-10-29 12:30:00', 60, 100.00),

    (33, 5, 5, '2023-10-22 10:00:00', 30, 50.00),
    (34, 5, 5, '2023-10-22 14:30:00', 45, 75.00),

    (35, 6, 6, '2023-10-22 12:00:00', 60, 100.00),
    (36, 6, 6, '2023-10-22 10:00:00', 30, 50.00),

    -- Four pets had one appointment
    (37, 7, 7, '2023-10-22 14:30:00', 45, 75.00),
    (38, 8, 8, '2023-10-22 11:00:00', 60, 100.00),
    (39, 9, 9, '2023-10-22 09:30:00', 30, 50.00),
    (40, 10, 10, '2023-10-22 14:00:00', 30, 50.00),

    -- One of the pets that died had an appointment a week before they passed away
    (41, 1, 1, '2023-10-15 14:00:00', 30, 50.00),

    -- Two of the pets had an appointment the day they passed away
    (42, 2, 2, '2023-10-22 10:00:00', 45, 75.00),
    (43, 3, 3, '2023-10-22 11:30:00', 60, 100.00);


-- View the contents of the Appointments table
SELECT * FROM vet.Appointments;





-- 4. Create a variable in the Customers table for each customer’s full name called fullname
ALTER TABLE vet.Customers
ADD fullname AS (LastName + ' - ' + FirstName);

-- Separate batch using GO
GO

--Create a view with customer full names
CREATE VIEW vet.CustomerFullNames AS
SELECT
    CustomerID,
    FirstName,
    LastName,
    CONCAT(LastName, ' - ', FirstName) AS FullName,
    Email,
    City
FROM vet.Customers;

-- Separate batch using GO
GO

-- Query the view
SELECT * FROM vet.CustomerFullNames;


/* 5. Create a table with all pet information and owner's information */
SELECT P.*, C.FirstName, C.LastName, C.Email, C.City
INTO vet.PetOwnerInfo
FROM vet.Pets P
JOIN vet.Customers C ON P.CustomerID = C.CustomerID;

-- Query the newly created table
SELECT * FROM vet.PetOwnerInfo;


-- 6. Create a table with customer, pet, and appointment information for pets that passed away
SELECT
    C.CustomerID,
    C.FirstName,
    C.LastName,
    C.Email,
    C.City,
    P.PetID,
    P.PetName,
    P.PetType,
    P.Birthdate,
    P.Deathdate,
    A.AppointmentID,
    A.AppointmentDate,
    A.AppointmentLenMinutes,
    A.VisitCost
INTO vet.PassedAwayInfo
FROM vet.Customers C
JOIN vet.Pets P ON C.CustomerID = P.CustomerID
JOIN vet.Appointments A ON P.PetID = A.PetID
WHERE P.Deathdate IS NOT NULL;

-- View the contents of the new PassedAwayInfo table
SELECT * FROM vet.PassedAwayInfo;






-- 7. Create a table with the average length of visit for customers with more than one visit and living pets
SELECT
    C.CustomerID,
    C.FirstName,
    C.LastName,
    AVG(A.AppointmentLenMinutes) AS AvgVisitLength
INTO vet.AvgVisitLength
FROM vet.Customers C
JOIN vet.Appointments A ON C.CustomerID = A.CustomerID
JOIN vet.Pets P ON A.PetID = P.PetID
WHERE P.Deathdate IS NULL
GROUP BY C.CustomerID, C.FirstName, C.LastName
HAVING COUNT(A.AppointmentID) > 1;
SELECT * FROM vet.AvgVisitLength;



-- 8. Utilize WINDOW functions to calculate the average age of pets by PetType as of September 31, 2023
WITH AvgAgeCTE AS (
    SELECT
        PetType,
        DATEDIFF(YEAR, Birthdate, '2023-09-30') AS Age
    FROM vet.Pets
)
SELECT
    PetType,
    AVG(Age) AS AvgAge
INTO vet.AvgAgeByPetType
FROM AvgAgeCTE
GROUP BY PetType;
SELECT * FROM vet.AvgAgeByPetType;



-- 9. Create a table for pets that do not exist in the Appointments table and have not passed away
IF OBJECT_ID('vet.PetsWithoutAppointments', 'U') IS NOT NULL
    DROP TABLE vet.PetsWithoutAppointments;
-- The corrected query using EXCEPT
SELECT P.*
INTO vet.PetsWithoutAppointments
FROM vet.Pets P
WHERE P.Deathdate IS NULL

EXCEPT

SELECT P.*
FROM vet.Pets P
JOIN vet.Appointments A ON P.PetID = A.PetID;
-- Add specific values along with the existing query
INSERT INTO vet.PetsWithoutAppointments (PetID, CustomerID, PetName, PetType, Birthdate, Deathdate)
VALUES
    (100, 11, 'NewPet1', 'Dog', '2023-01-01', NULL),
    (101, 12, 'NewPet2', 'Cat', '2022-03-15', NULL);

-- Update the table based on the existing query
INSERT INTO vet.PetsWithoutAppointments
SELECT P.*
FROM vet.Pets P
WHERE P.Deathdate IS NULL

EXCEPT

SELECT P.*
FROM vet.Pets P
JOIN vet.Appointments A ON P.PetID = A.PetID;
SELECT * FROM vet.PetsWithoutAppointments;



-- 10. Create a stored procedure that returns all appointment records for pets that filter on PetType
CREATE PROCEDURE vet.GetAppointmentsByPetType(@PetType VARCHAR(50))
AS
BEGIN
    SELECT *
    FROM vet.Appointments A
    JOIN vet.Pets P ON A.PetID = P.PetID
    WHERE P.PetType = @PetType;
END;
EXEC vet.GetAppointmentsByPetType @PetType = 'Dog';


-- 11. Calculate the total VisitCost revenue by customer City
SELECT
    C.City,
    SUM(A.VisitCost) AS TotalRevenue
INTO vet.TotalVisitCostByCity
FROM vet.Customers C
JOIN vet.Appointments A ON C.CustomerID = A.CustomerID
GROUP BY C.City;
SELECT * FROM vet.TotalVisitCostByCity;
