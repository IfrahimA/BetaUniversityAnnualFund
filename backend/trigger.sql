CREATE OR REPLACE FUNCTION validate_donor()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.Email IS NOT NULL AND POSITION('@' IN NEW.Email) = 0 THEN
        RAISE EXCEPTION 'Invalid email format for donor with ID: %', NEW.DonorID;
    END IF;

    IF NEW.PhoneNumber IS NOT NULL THEN
        NEW.PhoneNumber := regexp_replace(NEW.PhoneNumber, '\D', '', 'g');
    END IF;

    RETURN NEW;
END;

-- Create the trigger
CREATE TRIGGER donor_insert_trigger
BEFORE INSERT ON DONOR
FOR EACH ROW
EXECUTE FUNCTION validate_donor();
