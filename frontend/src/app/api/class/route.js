'use server';

import pool from '@/app/utils/postgres';

export async function POST(req) {
	const { classYear } = await req.json();

	try {
		const client = await pool.connect();
		const result = await client.query(
			`INSERT INTO CLASSYEAR (ClassYear) VALUES ($1)`,
			[classYear]
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
