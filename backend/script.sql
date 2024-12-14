DROP TABLE IF EXISTS LETTER CASCADE;
DROP TABLE IF EXISTS DONOR CASCADE;
DROP TABLE IF EXISTS DONOR_CIRCLE CASCADE;
DROP TABLE IF EXISTS CLASSYEAR CASCADE;
DROP TABLE IF EXISTS EMPLOYER CASCADE;
DROP TABLE IF EXISTS DONATION CASCADE;
DROP TABLE IF EXISTS PAYMENT CASCADE;
DROP TABLE IF EXISTS DEFERREDPAYMENT;
DROP TABLE IF EXISTS EVENTATTENDANCE;
DROP TABLE IF EXISTS "event" CASCADE;

CREATE TABLE CLASSYEAR (
    ClassID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    ClassYear INTEGER, 
	CONSTRAINT ClassPK PRIMARY KEY (ClassID)
);

CREATE TABLE DONOR_CIRCLE (
    CircleID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    CircleName TEXT,
    MinAmount NUMERIC(10, 2),
    MaxAmount NUMERIC(10, 2),
    CONSTRAINT CirclePK PRIMARY KEY (CircleID)
);

CREATE TABLE DONOR (
    DonorID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    FirstName TEXT,
    LastName TEXT,
    Street TEXT,
    City Text,
    State_ TEXT CHECK (State_ IN
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
    PhoneNumber TEXT,
    Email TEXT,
    Category TEXT CHECK (Category IN ('Alumni', 'Parent', 'Family', 'Faculty', 'Student', 'Other')),
    ClassID INTEGER,
    CircleID INTEGER,
    CONSTRAINT DonorPK PRIMARY KEY (DonorID),
    CONSTRAINT DonorFK1 FOREIGN KEY (ClassID)
    REFERENCES CLASSYEAR(ClassID),
    CONSTRAINT DonorFK2 FOREIGN KEY (CircleID)
	REFERENCES DONOR_CIRCLE (CircleID)
);

CREATE TABLE LETTER (
    LetterID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    LetterType TEXT,
    LetterDate TEXT,
    DonorID INTEGER,
    CONSTRAINT LetterPK PRIMARY KEY (LetterID),
    CONSTRAINT LetterFK1 FOREIGN KEY (DonorID)
    REFERENCES DONOR(DonorID)
);

CREATE TABLE "event" (
    EventID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    EventName TEXT,
    EventDate DATE,
    EventLocation TEXT,
    DonorID INTEGER,
    CONSTRAINT EventPK PRIMARY KEY (EventID),
    CONSTRAINT EventFK1 FOREIGN KEY (DonorID)
    REFERENCES DONOR(DonorID)
);

CREATE TABLE EVENTATTENDANCE (
    EventID INTEGER NOT NULL,
    DonorID INTEGER NOT NULL,
    CONSTRAINT EventAttendancePK PRIMARY KEY (EventID, DonorID),
    CONSTRAINT EventAttendanceFK1 FOREIGN KEY (EventID)
    REFERENCES "event"(EventID),
    CONSTRAINT EventAttendanceFK2 FOREIGN KEY (DonorID)
    REFERENCES DONOR(DonorID)
);

CREATE TABLE DONATION (
    DonationID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    Amount NUMERIC(10, 2),
    "Date" DATE,
    MatchingGiftEligible BOOLEAN,
    DonorID INTEGER,
    CONSTRAINT DonationPK PRIMARY KEY (DonationID),
    CONSTRAINT DonationFK1 FOREIGN KEY (DonorID)
    REFERENCES DONOR(DonorID)
);

CREATE TABLE EMPLOYER (
    EmployerID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    EmployerName TEXT,
    DonorID INTEGER,
    CONSTRAINT EmployerPK PRIMARY KEY (EmployerID),
    CONSTRAINT EmployerFK1 FOREIGN KEY (DonorID)
    REFERENCES DONOR(DonorID)
);

CREATE TABLE PAYMENT (
    PaymentID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    PaymentMethod TEXT CHECK (PaymentMethod IN ('Check', 'Credit Card', 'Deferred')),
    DonationID INTEGER,
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

INSERT INTO CLASSYEAR (ClassYear)
VALUES 
    (2024),
    (2023),
    (2022),
    (2021),
    (2020);

INSERT INTO DONOR_CIRCLE (CircleName, MinAmount, MaxAmount)
VALUES
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

INSERT INTO DONOR (FirstName, LastName, Street, City, State_, Zip, PhoneNumber, Email, Category, ClassID, CircleID) 
VALUES 
    ('John', 'Doe', 'Long Lane', 'Small Town', 'OK', '55599', '555-1234', 'john.doe@example.com', 'Alumni', 1, 1),
    ('Jane', 'Smith', 'Station Avenue', 'Center Valley', 'PA', '18034', '555-5678', 'jane.smith@example.com', 'Parent', 2, 2),
    ('Alice', 'Johnson', 'Wide Road', 'Redmond', 'WA', '88044', '555-8765', 'alice.johnson@example.com', 'Faculty', 3, 3),
    ('Bob', 'Williams', 'Narrow Avenue', 'New York', 'NY', '23994', '555-4321', 'bob.williams@example.com', 'Student', 4, 4),
    ('Charlie', 'Brown', 'Short Street', 'Brickville', 'OH', '22211', '555-6789', 'charlie.brown@example.com', 'Alumni', 5, 5),
    ('Diana', 'Clark', 'Cherry Street', 'Sakura', 'CA', '13955', '555-9876', 'diana.clark@example.com', 'Other', 1, 6);

INSERT INTO LETTER (LetterType, LetterDate, DonorID)
VALUES 
    ('Thank You', '2024-01-15', 1),
    ('Receipt', '2024-01-16', 2),
    ('Appeal', '2024-01-17', 3),
    ('Reminder', '2024-01-18', 4),
    ('Thank You', '2024-01-19', 5),
    ('Appeal', '2024-01-20', 6);

INSERT INTO "event" (EventName, EventDate, EventLocation, DonorID)
VALUES 
    ('Annual Gala', '2024-05-10', 'Grand Ballroom', 1),
    ('Homecoming', '2024-09-22', 'Campus Courtyard', 2),
    ('Faculty Dinner', '2024-11-05', 'Faculty Lounge', 3),
    ('Student Orientation', '2024-08-20', 'Student Center', 4),
    ('Fundraising Banquet', '2024-10-30', 'Hilton Hotel', 5),
    ('Alumni Meet & Greet', '2024-06-15', 'Alumni Hall', 6);

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
    (5, 5);

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
    (25000.00, '2024-06-10', TRUE, 6);

INSERT INTO EMPLOYER (EmployerName, DonorID)
VALUES 
    ('TechCorp', 1),
    ('EduFund', 2),
    ('UniCo', 3),
    ('StudentWorks', 4),
    ('GlobalTech', 5),
    ('BigBusiness', 6);

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

INSERT INTO DEFERREDPAYMENT (DueDate, AmountDue, IsSubmitted, SubmittedDate, PaymentID)
VALUES 
    ('2024-12-01', 50.00, TRUE, '2024-11-29', 4),
    ('2024-12-01', 150.00, FALSE, NULL, 7),
    ('2024-12-01', 50.00, FALSE, NULL, 8),
    ('2024-09-01', 50.00, FALSE, NULL, 9),
    ('2023-06-01', 150.00, FALSE, NULL, 10),
    ('2023-06-01', 50.00, TRUE, '2023-05-30', 11),
    ('2024-12-17', 250.00, FALSE, NULL, 12);