-- Active: 1733959918675@@127.0.0.1@5432@beta_fund
-- Drop existing tables
DROP TABLE IF EXISTS LETTER CASCADE;
DROP TABLE IF EXISTS DONOR CASCADE;
DROP TABLE IF EXISTS DONOR_CIRCLE CASCADE;
DROP TABLE IF EXISTS CLASSYEAR CASCADE;
DROP TABLE IF EXISTS EMPLOYER CASCADE;
DROP TABLE IF EXISTS DONATION CASCADE;
DROP TABLE IF EXISTS PAYMENT CASCADE;
DROP TABLE IF EXISTS DEFERREDPAYMENT CASCADE;
DROP TABLE IF EXISTS EVENTATTENDANCE CASCADE;
DROP TABLE IF EXISTS CLASSCOORDINATOR CASCADE;
DROP TABLE IF EXISTS VOLUNTEER CASCADE;
DROP TABLE IF EXISTS VOLUNTEERASSIGNMENT CASCADE;
DROP TABLE IF EXISTS PHONOTHON CASCADE;
DROP TABLE IF EXISTS "event" CASCADE;

-- Create CLASSYEAR table
CREATE TABLE CLASSYEAR (
    ClassID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    ClassYear INTEGER NOT NULL,
	CONSTRAINT ClassPK PRIMARY KEY (ClassID)
);

--Create CLASSCOORDINATOR table
CREATE TABLE CLASSCOORDINATOR
(
    CoordinatorID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL,
    ClassID INTEGER NULL,
    CONSTRAINT CoordinatorPK PRIMARY KEY (CoordinatorID),
    CONSTRAINT CoordinatorFK1 FOREIGN KEY (ClassID)
    REFERENCES CLASSYEAR (ClassID)
);

--Create VOLUNTEER table
CREATE TABLE VOLUNTEER
(
    VolunteerID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL,
    CONSTRAINT VolunteerPK PRIMARY KEY (VolunteerID)
);

--Create PHONOTHON table
CREATE TABLE PHONOTHON
(
    PhonothonID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    PhonothonDate DATE NOT NULL,
    CONSTRAINT PhonothonPK PRIMARY KEY (PhonothonID)
);

-- Create DONOR_CIRCLE table
CREATE TABLE DONOR_CIRCLE (
    CircleID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    CircleName TEXT NOT NULL,
    MinAmount NUMERIC(10, 2) NOT NULL,
    MaxAmount NUMERIC(10, 2) NOT NULL,
    CONSTRAINT CirclePK PRIMARY KEY (CircleID)
);

-- Create DONOR table
CREATE TABLE DONOR (
    DonorID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL,
    Street TEXT NULL,
    City Text NULL,
    State_ TEXT NULL CHECK (State_ IN
			('AL', 'AK', 'AZ', 'AR', 'AS',
			 'CA', 'CO', 'CT', 'DE', 'DC',
			 'FL', 'FM', 'GA', 'GU', 'HI',
			 'ID', 'IL', 'IN', 'IA', 'KS',
			 'KY', 'LA', 'ME', 'MH', 'MD',
			 'MA', 'MI', 'MN', 'MS', 'MO',
			 'MT', 'NE', 'NV', 'NH', 'NJ',
			 'NM', 'NY', 'NC', 'ND', 'MP',
			 'OH', 'OK', 'OR', 'PW', 'PA',
			 'PR', 'RI', 'SC', 'SD', 'TN',
			 'TX', 'UT', 'VT', 'VA', 'VI',
			 'WA', 'WV', 'WI', 'WY',
			 'AE', 'AP', 'AA')),
    Zip TEXT NULL,
    PhoneNumber TEXT NULL,
    Email TEXT NULL,
    Category TEXT NOT NULL CHECK (Category IN ('Alumni', 'Parent', 'Family', 'Faculty', 'Student', 'Other')),
    ClassID INTEGER NULL,
    CircleID INTEGER NULL,
    CONSTRAINT DonorPK PRIMARY KEY (DonorID),
    CONSTRAINT DonorFK1 FOREIGN KEY (ClassID)
    REFERENCES CLASSYEAR(ClassID),
    CONSTRAINT DonorFK2 FOREIGN KEY (CircleID)
	REFERENCES DONOR_CIRCLE (CircleID)
);

--Create VOLUNTEERASSIGNMENT table
CREATE TABLE VOLUNTEERASSIGNMENT
(
    VolunteerID INTEGER NOT NULL,
    DonorID INTEGER NOT NULL,
    PhonothonID INTEGER NOT NULL,
    CONSTRAINT VolunteerAssignmentPK PRIMARY KEY (VolunteerID, DonorID, PhonothonID),
    CONSTRAINT VolunteerAssignmentFK1 FOREIGN KEY (VolunteerID)
    REFERENCES VOLUNTEER (VolunteerID),
    CONSTRAINT VolunteerAssignmentFK2 FOREIGN KEY (DonorID)
    REFERENCES DONOR (DonorID),
    CONSTRAINT VolunteerAssignmentFK3 FOREIGN KEY (VolunteerID)
    REFERENCES VOLUNTEER (VolunteerID)
);

-- Create LETTER table
CREATE TABLE LETTER (
    LetterID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    LetterType TEXT NULL,
    LetterDate TEXT NOT NULL,
    DonorID INTEGER NOT NULL,
    CONSTRAINT LetterPK PRIMARY KEY (LetterID),
    CONSTRAINT LetterFK1 FOREIGN KEY (DonorID)
    REFERENCES DONOR(DonorID)
);

-- Create "event" table
CREATE TABLE "event" (
    EventID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    EventName TEXT NOT NULL,
    EventDate DATE NOT NULL,
    EventLocation TEXT NULL,
    CONSTRAINT EventPK PRIMARY KEY (EventID)
);

--Create EVENTATTENDANCE table
--Allows keeping history of which events a donor went to
CREATE TABLE EVENTATTENDANCE (
    EventID INTEGER NOT NULL,
    DonorID INTEGER NOT NULL,
    CONSTRAINT EventAttendancePK PRIMARY KEY (EventID, DonorID),
    CONSTRAINT EventAttendanceFK1 FOREIGN KEY (EventID)
    REFERENCES "event"(EventID),
    CONSTRAINT EventAttendanceFK2 FOREIGN KEY (DonorID)
    REFERENCES DONOR(DonorID)
);

-- Create DONATION table
CREATE TABLE DONATION (
    DonationID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    Amount NUMERIC(10, 2) NOT NULL,
    "Date" DATE NOT NULL,  -- Date field changed to DATE type
    MatchingGiftEligible BOOLEAN NOT NULL DEFAULT FALSE,
    DonorID INTEGER NOT NULL,
    CONSTRAINT DonationPK PRIMARY KEY (DonationID),
    CONSTRAINT DonationFK1 FOREIGN KEY (DonorID)
    REFERENCES DONOR(DonorID)
);

-- Create EMPLOYER table
CREATE TABLE EMPLOYER (
    EmployerID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    EmployerName TEXT NOT NULL,
    DonorID INTEGER NULL,
    CONSTRAINT EmployerPK PRIMARY KEY (EmployerID),
    CONSTRAINT EmployerFK1 FOREIGN KEY (DonorID)
    REFERENCES DONOR(DonorID)
);

-- Create PAYMENT table
CREATE TABLE PAYMENT (
    PaymentID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    PaymentMethod TEXT NOT NULL CHECK (PaymentMethod IN ('Check', 'Credit Card', 'Deferred')),
    DonationID INTEGER NOT NULL,
    CONSTRAINT PaymentPK PRIMARY KEY (PaymentID),
    CONSTRAINT PaymentFK1 FOREIGN KEY (DonationID)
    REFERENCES DONATION(DonationID)
);

CREATE TABLE DEFERREDPAYMENT
(
	DefPaymentID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
	DueDate DATE NOT NULL,
    AmountDue NUMERIC(9,2) NOT NULL,
    IsSubmitted BOOLEAN NOT NULL DEFAULT FALSE,
    SubmittedDate DATE NULL DEFAULT NULL,
    PaymentID INTEGER NOT NULL,
	CONSTRAINT DefPaymentPK PRIMARY KEY (DefPaymentID),
	CONSTRAINT DefPaymentFK1 FOREIGN KEY (PaymentID)
	REFERENCES PAYMENT(PaymentID)
);

-- Insert data into "class" table
INSERT INTO CLASSYEAR (ClassYear)
VALUES 
    (2024),
    (2023),
    (2022),
    (2021),
    (2020),
    (2019);

--Insert data into CLASSCOORDINATOR table
INSERT INTO CLASSCOORDINATOR (FirstName, LastName, ClassID)
VALUES 
    ('Emily', 'Davis', 1),
    ('Michael', 'Brown', 2),
    ('Sophia', 'Lee', 3),
    ('William', 'Harris', 4),
    ('Olivia', 'Martin', 5),
    ('James', 'Wilson', 6);

--Insert data into VOLUNTEER table
INSERT INTO VOLUNTEER (FirstName, LastName)
VALUES 
    ('Ava', 'Garcia'),
    ('Liam', 'Martin'),
    ('Isabella', 'Hernandez'),
    ('Noah', 'Diaz'),
    ('Mia', 'Gonzalez'),
    ('Ethan', 'Rodriguez');

--Insert data into PHONOTHON table
INSERT INTO PHONOTHON (PhonothonDate)
VALUES 
    ('2023-02-15'),
    ('2022-03-10'),
    ('2021-04-05'),
    ('2020-05-01'),
    ('2019-06-15'),
    ('2018-07-10');

-- Insert data into DONOR_CIRCLE table
INSERT INTO DONOR_CIRCLE (CircleName, MinAmount, MaxAmount)
VALUES --'E' indicates that the backslash escape sequence is used
    (E'Friend\'s Circle', 100.00, 249.99),
    ('Bronze Circle', 250.00, 499.99),
    ('Silver Circle', 500.00, 999.99),
    ('Gold Circle', 1000.00, 2499.99),
    ('Grand Circle', 2500.00, 4999.99),
    ('Elite Circle', 5000.00, 7499.99),
    ('Ruby Circle', 7500.00, 14999.99),
    ('Diamond Circle', 15000.00, 24999.99),
    ('Platinum Circle', 25000.00, 49999.99),
    (E'President\' Circle', 50000.00, 99999999.99);

-- Insert data into DONOR table
INSERT INTO DONOR (FirstName, LastName, Street, City, State_, Zip, PhoneNumber, Email, Category, ClassID, CircleID) 
VALUES 
    ('John', 'Doe', 'Long Lane', 'Small Town', 'OK', '55599', '123-555-1234', 'john.doe@example.com', 'Alumni', 1, 1),
    ('Jane', 'Smith', 'Station Avenue', 'Center Valley', 'PA', '18034', '889-555-5678', 'jane.smith@example.com', 'Parent', NULL, 2),
    ('Alice', 'Johnson', 'Wide Road', 'Redmond', 'WA', '88044', '703-555-8765', 'alice.johnson@example.com', 'Faculty', NULL, 3),
    ('Bob', 'Williams', 'Narrow Avenue', 'New York', 'NY', '23994', '231-555-4321', 'bob.williams@example.com', 'Student', 4, 4),
    ('Charlie', 'Brown', 'Short Street', 'Brickville', 'OH', '22211', '222-555-6789', 'charlie.brown@example.com', 'Alumni', 5, 5),
    ('Stewart','Smith', 'Shady Lane', 'Arborville', 'NJ', '33918', '267-212-1212', 'ssmith@my.email', 'Alumni', 5, 10),
    ('Diana', 'Clark', 'Cherry Street', 'Sakura', 'CA', '13955', '610-555-9876', 'diana.clark@example.com', 'Other', NULL, 6);

INSERT INTO VOLUNTEERASSIGNMENT  (VolunteerID, DonorID, PhonothonID)
VALUES
    (3, 5, 2),
    (3, 2, 2),
    (2, 1, 1),
    (4, 3, 2),
    (1, 1, 3),
    (2, 4, 4),
    (2, 1, 3),
    (4, 3, 5),
    (2, 1, 2),
    (5, 6, 1),
    (1, 6, 2);

-- Insert data into LETTER table
INSERT INTO LETTER (LetterType, LetterDate, DonorID)
VALUES 
    ('Thank You', '2024-01-15', 1),
    ('Receipt', '2024-01-16', 2),
    ('Appeal', '2024-01-17', 3),
    ('Reminder', '2024-01-18', 4),
    ('Thank You', '2024-01-19', 5),
    ('Appeal', '2024-01-20', 6);

-- Insert data into "event" table
INSERT INTO "event" (EventName, EventDate, EventLocation)
VALUES 
    ('Annual Gala', '2024-05-10', 'Grand Ballroom'),
    ('Homecoming', '2024-09-22', 'Campus Courtyard'),
    ('Faculty Dinner', '2024-11-05', 'Faculty Lounge'),
    ('Fall Carnival', '2024-08-20', 'University Park'),
    ('Fundraising Banquet', '2024-10-30', 'Hilton Hotel'),
    ('Alumni Meet & Greet', '2024-06-15', 'Alumni Hall');

--Insert data into EVENTATTENDANCE table
INSERT INTO EVENTATTENDANCE (EventID, DonorID)
VALUES
    (1, 2),
    (4, 5),
    (1, 6),
    (6, 2),
    (6, 3),
    (3, 3),
    (4, 4),
    (4, 1),
    (4, 2),
    (1, 3),
    (3, 1),
    (5, 1),
    (5, 6),
    (3, 6),
    (5, 5);

-- Insert data into DONATION table
INSERT INTO DONATION (Amount, "Date", MatchingGiftEligible, DonorID)
VALUES 
    (750.00, '2024-12-12', TRUE, 3),
    (3000.00, '2024-02-24', FALSE, 1),
    (1600.00, '2024-03-19', FALSE, 2),
    (5000.00, '2024-12-09', TRUE, 6),
    (200.00, '2024-01-01', TRUE, 1),
    (300.00, '2024-02-14', FALSE, 2),
    (1500.00, '2024-03-01', TRUE, 3),
    (50.00, '2024-04-10', FALSE, 4),
    (5000.00, '2024-05-01', TRUE, 5),
    (25000.00, '2024-06-10', TRUE, 6),
    (99999999.00, '2022-01-17', FALSE, 6),
    (830.00, '2023-02-13', TRUE, 2);

-- Insert data into EMPLOYER table
INSERT INTO EMPLOYER (EmployerName, DonorID)
VALUES 
    ('TechCorp', 1),
    ('EduFund', 2),
    ('UniCo', 3),
    ('StudentWorks', 4),
    ('GlobalTech', 5),
    ('BigBusiness', 6);

-- Insert data into PAYMENT table
INSERT INTO PAYMENT (PaymentMethod, DonationID)
VALUES 
    ('Credit Card', 1),
    ('Check', 2),
    ('Credit Card', 3),
    ('Deferred', 4),
    ('Credit Card', 5),
    ('Check', 6),
    ('Deferred', 1),
    ('Deferred', 3),
    ('Deferred', 6),
    ('Deferred', 5),
    ('Deferred', 2),
    ('Deferred', 3);

--Insert data into DEFERREDPAYMENT table
INSERT INTO DEFERREDPAYMENT (DueDate, AmountDue, IsSubmitted, SubmittedDate, PaymentID)
VALUES 
    ('2024-12-01', 50.00, TRUE, '2024-11-29', 4),
    ('2024-12-01', 150.00, FALSE, NULL, 7),
    ('2024-12-01', 50.00, FALSE, NULL, 8),
    ('2024-09-01', 50.00, FALSE, NULL, 9),
    ('2023-06-01', 150.00, FALSE, NULL, 10),
    ('2023-06-01', 50.00, TRUE, '2023-05-30', 11),
    ('2024-12-17', 250.00, FALSE, NULL, 12);