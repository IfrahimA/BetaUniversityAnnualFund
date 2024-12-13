CREATE OR REPLACE FUNCTION validate_donor()
RETURNS TRIGGER AS $$
BEGIN
    -- Example validation: Ensure email contains '@'
    IF NEW.Email IS NOT NULL AND POSITION('@' IN NEW.Email) = 0 THEN
        RAISE EXCEPTION 'Invalid email format for donor with ID: %', NEW.DonorID;
    END IF;

    -- Example action: Auto-format phone numbers (basic example)
    IF NEW.PhoneNumber IS NOT NULL THEN
        NEW.PhoneNumber := regexp_replace(NEW.PhoneNumber, '\D', '', 'g'); -- Remove non-numeric characters
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE TRIGGER donor_insert_trigger
BEFORE INSERT ON DONOR
FOR EACH ROW
EXECUTE FUNCTION validate_donor();
