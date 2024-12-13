import pool from '../utils/postgres';

const totalRaisedPerClass = async () => {
	try {
		const client = await pool.connect();
		const result = await client.query(
			`SELECT
    donor_circle.circleid,
    donor_circle.circlename,
    SUM(donation.amount) AS total_raised_per_donor_circle
FROM
    donation,
    donor_circle,
    donor
WHERE
    (donor.donorid = donation.donorid)
    AND (donor.circleid = donor_circle.circleid)
    AND
    (
        to_char(donation."Date", 'YYYY') = to_char(CURRENT_DATE, 'YYYY')
    )
GROUP BY
    donor_circle.circleid
ORDER BY
    donor_circle.circleid DESC;`
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

export const DonationPerCircle = async () => {
	const donorData = await totalRaisedPerClass();
    console.log(donorData);
	return (
		<div className='bg-white rounded-lg p-6 shadow-lg w-80'>
			<div className='text-center mb-4'>
				<h3 className='text-xl font-semibold text-gray-800'>
					Donation Per Circle
				</h3>
			</div>
			<div>
				{donorData.map((data, index) => (
					<div
						key={index}
						className='flex justify-between items-center py-2 border-b last:border-none'
					>
						<div className='text-lg text-gray-700'>{data.circlename}</div>
						<div className='text-lg text-orange-600 font-semibold'>
							${data.total_raised_per_donor_circle}
						</div>
					</div>
				))}
			</div>
		</div>
	);
};
