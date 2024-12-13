import pool from '@/app/utils/postgres';

export async function POST(req) {
	const client = await pool.connect();

	try {
		const { firstName, lastName, phoneNumber, email, category } =
			await req.json();

		await client.query('BEGIN');

		const result = await client.query(
			`INSERT INTO DONOR (FirstName, LastName, PhoneNumber, Email, Category) 
            VALUES ($1, $2, $3, $4, $5) RETURNING donorid`,
			[firstName, lastName, phoneNumber, email, category]
		);

		const donorId = result.rows[0].donorid;

		await client.query('COMMIT');

		return new Response(
			JSON.stringify({ message: 'Success', donorId: donorId }),
			{
				status: 200,
				headers: { 'Content-Type': 'application/json' },
			}
		);
	} catch (error) {
		await client.query('ROLLBACK');
		console.error('Donor creation error:', error);
		return new Response(
			JSON.stringify({
				error: 'Failed to create donor',
				details: error instanceof Error ? error.message : 'Unknown error',
			}),
			{
				status: 500,
				headers: { 'Content-Type': 'application/json' },
			}
		);
	} finally {
		client.release();
	}
}
