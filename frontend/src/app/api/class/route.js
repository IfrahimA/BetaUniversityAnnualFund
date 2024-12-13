'use server';

import pool from '@/app/utils/postgres';

export async function POST(req) {
	const { classYear, donorId } = await req.json();

	try {
		const client = await pool.connect();
		const result = await client.query(
			`INSERT INTO CLASSYEAR (Year, DonorID) VALUES ($1, $2)`,
			[classYear, donorId]
		);

		client.release();
		return new Response(JSON.stringify({ message: 'Success' }), {
			status: 200,
			headers: { 'Content-Type': 'application/json' },
		});
	} catch (error) {
		return new Response(JSON.stringify({ error: 'Failed to create donor' }), {
			status: 500,
		});
	}
}
