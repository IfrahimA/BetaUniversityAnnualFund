CREATE OR REPLACE VIEW EventParticipation AS
SELECT 
    d.DonorID,
    d.FirstName,
    d.LastName,
    e.EventName,
    e.EventDate,
    e.EventLocation
FROM 
    DONOR d
JOIN EVENTATTENDANCE ea ON d.DonorID = ea.DonorID
JOIN "event" e ON ea.EventID = e.EventID;

CREATE VIEW DonorOverview AS
SELECT 
    d.DonorID,
    d.FirstName,
    d.LastName,
    d.Email,
    SUM(do.Amount) AS TotalDonated,
    COUNT(ea.EventID) AS EventsAttended
FROM 
    DONOR d
LEFT JOIN 
    DONATION do ON d.DonorID = do.DonorID
LEFT JOIN 
    EVENTATTENDANCE ea ON d.DonorID = ea.DonorID
GROUP BY 
    d.DonorID, d.FirstName, d.LastName, d.Email;
