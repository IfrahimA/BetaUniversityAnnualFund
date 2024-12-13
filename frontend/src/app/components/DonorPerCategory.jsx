import pool from "../utils/postgres";

const totalRaisedPerClass = async () => {
	try {
		const client = await pool.connect();
		const result = await client.query(
			`SELECT
    to_char(donation."Date", 'YYYY') AS donation_year,
    donor.category AS donor_category,
    SUM(amount) AS total_raised_per_category
FROM
    donor
    INNER JOIN donation ON donor.donorid = donation.donorid
WHERE
    (
        to_char(donation."Date", 'YYYY') = to_char(CURRENT_DATE, 'YYYY')
    )
GROUP BY
    donation_year,
    donor.category
ORDER BY
    donor.category ASC
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

export const DonorByCategory = async () => {
    const donorData = await totalRaisedPerClass();

	return (
		<div className='bg-white rounded-lg p-6 shadow-lg w-80'>
			<div className='text-center mb-4'>
				<h3 className='text-xl font-semibold text-gray-800'>
					Donor Types and Amounts
				</h3>
			</div>
			<div>
				{donorData.map((data, index) => (
					<div
						key={index}
						className='flex justify-between items-center py-2 border-b last:border-none'
					>
						<div className='text-lg text-gray-700'>{data.donor_category}</div>
						<div className='text-lg text-orange-600 font-semibold'>
							${data.total_raised_per_category}
						</div>
					</div>
				))}
			</div>
		</div>
	);
};