SELECT
    "event".eventid,
    "event".eventname,
    "event".eventdate,
donor.donorid,
donor.lastname,
    donor.firstname,
donation.donationid,
donation.amount AS donation_amount
FROM
(
(
            "event"
            INNER JOIN
            eventattendance ON ("event".eventid = eventattendance.eventid)
        )
        INNER JOIN donor ON eventattendance.donorid = donor.donorid
)
LEFT OUTER JOIN donation ON eventattendance.donorid = donation.donorid
WHERE
eventattendance.eventid = 1
ORDER BY
donor.lastname, donor.firstname ASC,
donation.amount DESC
