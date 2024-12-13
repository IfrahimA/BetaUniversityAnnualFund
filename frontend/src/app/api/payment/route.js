import pool from '@/app/utils/postgres';

export async function POST(req) {
	const client = await pool.connect();

	try {
		const { paymentMethod, donationID } = await req.json();

		await client.query('BEGIN');

		const result = await client.query(
			`INSERT INTO PAYMENT (PaymentMethod, DonationID) VALUES ($1, $2)`,
			[paymentMethod, donationID]
		);

		await client.query('COMMIT');

		return new Response(JSON.stringify({ message: 'Success' }), {
			status: 200,
			headers: { 'Content-Type': 'application/json' },
		});
	} catch (error) {
		await client.query('ROLLBACK');
		console.error('Payment insertion error:', error);
		return new Response(
			JSON.stringify({
				error: 'Failed to create payment entry',
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
