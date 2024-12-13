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