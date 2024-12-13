CREATE OR REPLACE FUNCTION has_attended_event(p_donor_id INTEGER, p_event_id INTEGER)
RETURNS BOOLEAN AS $$
DECLARE
    attended BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1 FROM EVENTATTENDANCE
        WHERE DonorID = p_donor_id AND EventID = p_event_id
    ) INTO attended;

    RETURN attended;
END;

SELECT DonorID, EventID, has_attended_event(DonorID, EventID) AS Attended
FROM EVENTATTENDANCE;

/* ------------------------------------------------------------------------ */

CREATE OR REPLACE FUNCTION get_total_donations(p_donor_id INTEGER)
RETURNS NUMERIC AS $$
DECLARE
    total_donated NUMERIC(10, 2);
BEGIN
    SELECT SUM(Amount) INTO total_donated
    FROM DONATION
    WHERE DonorID = p_donor_id;

    RETURN COALESCE(total_donated, 0);  -- Return 0 if no donations are found
END;

SELECT DonorID, FirstName, LastName, get_total_donations(DonorID) AS TotalDonated
FROM DONOR;
