'use server';

import pool from '@/app/utils/postgres';

export async function POST(req) {
	const { firstName, lastName, phoneNumber, email, category } =
		await req.json();
	try {
		const client = await pool.connect();
		const result = await client.query(
			`INSERT INTO DONOR (FirstName, LastName, PhoneNumber, Email, Category) 
			VALUES ($1, $2, $3, $4, $5) RETURNING DonorID;`,
			[firstName, lastName, phoneNumber, email, category]
		);

		const donorId = result.rows[0].donorid;

		client.release();
		return new Response(
			JSON.stringify({ message: 'Success', donorId: donorId }),
			{
				status: 200,
				headers: { 'Content-Type': 'application/json' },
			}
		);
	} catch (error) {
		console.log(error);
		return new Response(JSON.stringify({ error: 'Failed to create donor' }), {
			status: 500,
		});
	}
}
