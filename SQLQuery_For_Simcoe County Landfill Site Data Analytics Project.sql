/* Create database finalexam; */
CREATE DATABASE finalexam;
GO
USE finalexam;
GO
--Making connections as per the diagram
ALTER TABLE dbo.visits
ADD CONSTRAINT FK_visitor_id FOREIGN KEY (visitor_id) REFERENCES dbo.visits;
GO 

ALTER TABLE dbo.services
ADD CONSTRAINT FK_visit_id FOREIGN KEY (visit_id) REFERENCES dbo.services;
GO  

ALTER TABLE dbo.services
ADD CONSTRAINT FK_service_used_id FOREIGN KEY (service_used_id) REFERENCES dbo.services;
GO  

ALTER TABLE dbo.visits
ADD CONSTRAINT FK_site_id FOREIGN KEY (site_id) REFERENCES dbo.visits;
GO  


-- 1. Calculate the min, max, average, standard deviation, and count for total time spent at the landfill by vehicle type.

SELECT 
    vehicle_type, 
    MIN(wait_length + visit_length) AS MinTime,
    MAX(wait_length + visit_length) AS MaxTime,
    AVG(wait_length + visit_length) AS AvgTime,
    STDEV(wait_length + visit_length) AS StdDevTime,  -- Using STDEV for SQL Server
    COUNT(*) AS TotalVisits
FROM 
    visits
GROUP BY 
    vehicle_type;

-- 2. Create a table with the sum and count of visits.total_cost by visits.visitor_id.

SELECT 
    v.visitor_id, 
    r.visitor_name, 
    r.visitor_location,
    SUM(v.total_cost) AS TotalCost, 
    COUNT(v.visitor_id) AS VisitCount
INTO 
    VisitorCostSummary
FROM 
    visits v
JOIN 
    residents r ON v.visitor_id = r.visitor_id
GROUP BY 
    v.visitor_id, r.visitor_name, r.visitor_location;


-- 3. Create a varchar column called resident_decade from residents.county_resident_since.

-- Add the new column
ALTER TABLE residents
ADD resident_decade VARCHAR(50);

-- Update the new column with the decade
UPDATE residents
SET resident_decade = CONCAT(SUBSTRING(CONVERT(VARCHAR, county_residence_since, 120), 1, 3), '0s');


-- 4. Create a table that provides the sum and count of the visits

SELECT 
    v.site_id,
    l.site_name,
    CASE 
        WHEN v.vehicle_type LIKE '%Commercial%' THEN 'Commercial'
        ELSE 'Private' 
    END AS vehicle_class,
    SUM(v.total_cost) AS TotalCost,
    COUNT(v.total_cost) AS VisitCount
INTO 
    SiteVehicleCostSummary
FROM 
    visits v
JOIN 
    locations l ON v.site_id = l.site_id
GROUP BY 
    v.site_id, l.site_name, 
    CASE 
        WHEN v.vehicle_type LIKE '%Commercial%' THEN 'Commercial'
        ELSE 'Private'
    END;



-- 5. Create a table from the visits table that includes ‘Commercial’ vehicles and total_cost=0.

SELECT *
INTO CommercialVisitsFree
FROM visits
WHERE vehicle_type LIKE '%Commercial%' AND total_cost = 0;


-- 6. Create a table with counts from the residents table by year and residents.visitor_location.

SELECT 
    DATEPART(YEAR, county_residence_since) AS ResidenceYear, 
    visitor_location,
    COUNT(*) AS TotalResidents
INTO 
    ResidentYearLocationCount
FROM 
    residents
GROUP BY 
    DATEPART(YEAR, county_residence_since), visitor_location;


-- 7. Create a table with records from the visits table where visit.wait_length>= 10 and locations closing.

SELECT 
    v.site_id, 
    v.wait_length
INTO 
    LongWaitClosingLocations
FROM 
    visits v
JOIN 
    locations l ON v.site_id = l.site_id
WHERE 
    v.wait_length >= 10 AND l.decommission_date IS NOT NULL;


-- 8. Create a table that has the time the resident left the landfill site.

SELECT 
    visitor_id, 
    site_id,
    visit_date,
    visit_time,
    wait_length,
    visit_length,
    DATEADD(MINUTE, wait_length + visit_length, CAST(CAST(visit_date AS DATETIME) + CAST(visit_time AS DATETIME) AS DATETIME)) AS exit_time
INTO 
    VisitExitTimes
FROM 
    visits;

-- 9. create a master table in SQL

SELECT 
    l.site_name, 
    l.decommission_date, 
    s.cost, 
    su.service_used_label, 
    v.visit_date, 
    v.visit_time, 
    v.wait_length, 
    v.visit_length, 
    v.visit_id, 
    s.service_id
INTO 
    MasterServiceTable
FROM 
    visits v
JOIN 
    locations l ON v.site_id = l.site_id
JOIN 
    services s ON v.visit_id = s.visit_id
JOIN 
    services_used su ON s.service_used_id = su.service_used_id;



