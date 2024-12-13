import pool from './postgres';

export const fetchMembers = async () => {
	try {
		const client = await pool.connect();
		const result = await client.query(
			'SELECT * FROM DONOR ORDER BY lastname, firstname'
		);
		const data = result.rows;
		console.log('Fetched data:', data);
		client.release();
		return data;
	} catch (error) {
		console.error('Error fetching data:', error);
		return [];
	}
};

export const totalRaised = async () => {
	try {
		const client = await pool.connect();
		const result = await client.query(
			`SELECT to_char(donation."Date", 'YYYY') AS donation_year, COUNT(DISTINCT (donor.donorid)) AS total_donors, SUM(amount) AS total_raised_from_all_donors FROM donor INNER JOIN donation ON donor.donorid = donation.donorid WHERE to_char(donation."Date", 'YYYY') = to_char(CURRENT_DATE, 'YYYY') GROUP BY donation_year`
		);
		const data = result.rows;
		client.release();
		return data;
	} catch (error) {
		console.error('Error fetching data:', error);
	}
};

export const fetchDonations = async () => {
	try {
		const client = await pool.connect();

		const result = await client.query(
			'SELECT donor.donorid, firstname, lastname, sum(donation.amount) as total_donation FROM donor INNER JOIN donation ON (donor.donorid = donation.donorid) GROUP BY donor.donorid, firstname, lastname ORDER BY total_donation DESC'
		);
		const data = result.rows;
		client.release();
		return data;
	} catch (error) {
		console.error('Error fetching data:', error);
		return [];
	}
};