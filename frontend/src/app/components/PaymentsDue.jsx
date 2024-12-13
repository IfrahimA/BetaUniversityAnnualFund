import pool from '../utils/postgres';

const paymentsDue = async () => {
	try {
		const client = await pool.connect();
		const result = await client.query(
			`SELECT
donor.donorid,
donor.lastname,
    donor.firstname,
(
donor.street || ' ' || donor.city || ' ' || donor.state_ || ' ' || donor.zip
) AS donor_address,
deferredpayment.amountdue,
deferredpayment.duedate,
d.amount AS pledge_amount,
COALESCE(round((
SELECT sum(deferredpayment.amountdue)
        FROM deferredpayment,
             payment,
             donation
        WHERE (deferredpayment.paymentid = payment.paymentid)
            AND (payment.donationid = d.donationid)
            AND (CAST(to_char(deferredpayment.duedate, 'YYYYMM') AS INTEGER) < CAST(to_char(CURRENT_DATE, 'YYYYMM') AS INTEGER))
            AND (issubmitted = TRUE)
), 2), 0.00) AS amount_received,
    (
        SELECT deferredpayment.submitteddate
        FROM deferredpayment,
             payment,
             donation
        WHERE (deferredpayment.paymentid = payment.paymentid)
            AND (payment.donationid = d.donationid)
            AND (CAST(to_char(deferredpayment.duedate, 'YYYYMM') AS INTEGER) < CAST(to_char(CURRENT_DATE, 'YYYYMM') AS INTEGER))
            AND (issubmitted = TRUE)
        ORDER BY deferredpayment.duedate ASC
        LIMIT 1
    ) AS date_of_previous_payment
FROM
donor,
donation AS d,
payment,
deferredpayment
WHERE
(donor.donorid = d.donorid)
AND (d.donationid = payment.donationid)
AND (
payment.paymentid = deferredpayment.defpaymentid
)
AND
(
to_char(deferredpayment.duedate, 'YYYY-MM') = to_char(CURRENT_DATE, 'YYYY-MM')
)
ORDER BY
deferredpayment.duedate ASC,
    deferredpayment.amountdue DESC
;`
		);
		console.log(result);
		const data = result.rows;
		console.log('Fetched data:', data);
		client.release();
		return data;
	} catch (error) {
		console.error('Error fetching data:', error);
	}
};

export const PaymentsDue = async () => {
	const donorData = await paymentsDue();

	return (
		<div className='bg-white rounded-lg p-6 shadow-lg w-80'>
			<div className='text-center mb-4'>
				<h3 className='text-xl font-semibold text-gray-800'>Payments Due</h3>
			</div>
			<div>
				{donorData.map((data, index) => (
					<div
						key={index}
						className='flex justify-between items-center py-2 border-b last:border-none'
					>
						<div className='text-lg text-gray-700'>
							{data.firstname} {data.lastname}
						</div>
						<div className='text-lg text-orange-600 font-semibold'>
							${data.amountdue}
						</div>
					</div>
				))}
			</div>
		</div>
	);
};
