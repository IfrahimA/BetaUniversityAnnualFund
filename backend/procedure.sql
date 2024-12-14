CREATE OR REPLACE PROCEDURE record_event_attendance(
    event_id INTEGER,
    donor_id INTEGER
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO EVENTATTENDANCE (EventID, DonorID)
    VALUES (event_id, donor_id);
END;

CREATE OR REPLACE PROCEDURE process_donors_by_category(category_filter TEXT)
LANGUAGE plpgsql AS $$
DECLARE
    donor_cursor CURSOR FOR 
        SELECT DonorID, FirstName, LastName, Email 
        FROM DONOR
        WHERE Category = category_filter;
    donor_record RECORD;
BEGIN
    -- Open the cursor
    OPEN donor_cursor;

    -- Fetch each record and process it
    LOOP
        FETCH donor_cursor INTO donor_record;
        EXIT WHEN NOT FOUND;

        -- Example: Log donor information (replace with your desired logic)
        RAISE NOTICE 'Processing Donor: ID=% Name=% % Email=%',
        donor_record.DonorID, donor_record.FirstName, donor_record.LastName, donor_record.Email;
    END LOOP;

    -- Close the cursor
    CLOSE donor_cursor;
END;

/* Example */
CALL process_donors_by_category('Alumni');