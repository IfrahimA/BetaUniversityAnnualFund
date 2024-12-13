import pool from "../utils/postgres";
const totalRaisedPerClass = async () => {
	try {
		const client = await pool.connect();
		const result = await client.query(
			`SELECT classyear.classyear AS classyears_with_donors, SUM(amount) AS total_raised_per_class FROM donor, donation, classyear WHERE (donor.donorid = donation.donorid) AND (donor.classid = classyear.classid) AND (to_char(donation."Date", 'YYYY') = to_char(CURRENT_DATE, 'YYYY')) GROUP BY classyear.classyear ORDER BY classyear.classyear ASC`
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

export const RaisedPerClassYear = async () => {
	const raisedData = await totalRaisedPerClass();


	return (
		<div className='bg-white rounded-lg p-6 shadow-lg w-80'>
			<div className='text-center mb-4'>
				<h3 className='text-xl font-semibold text-gray-800'>
					Total Raised per Class Year
				</h3>
			</div>
			<div>
				{raisedData.map((data, index) => (
					<div
						key={index}
						className='flex justify-between items-center py-2 border-b last:border-none'
					>
						<div className='text-lg text-gray-700'>{data.classyears_with_donors}</div>
						<div className='text-lg text-orange-600 font-semibold'>
							${data.total_raised_per_class}
						</div>
					</div>
				))}
			</div>
		</div>
	);
};
