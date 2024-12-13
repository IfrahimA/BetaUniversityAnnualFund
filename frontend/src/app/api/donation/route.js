import pool from '@/app/utils/postgres';

export async function POST(req) {
	try {
		const { donationAmount, formattedDate, matchingGiftEligible, donorId } =
			await req.json();

		// Instead of connecting and releasing manually, use the pool directly
		const result = await pool.query(
			`INSERT INTO DONATION (Amount, "Date", MatchingGiftEligible, DonorID) 
            VALUES ($1, $2, $3, $4)`,
			[donationAmount, formattedDate, matchingGiftEligible, donorId]
		);

		return new Response(JSON.stringify({ message: 'Success' }), {
			status: 200,
			headers: { 'Content-Type': 'application/json' },
		});
	} catch (error) {
		console.error('Donation insertion error:', error);
		return new Response(
			JSON.stringify({
				error: 'Failed to create donation',
				details: error instanceof Error ? error.message : 'Unknown error',
			}),
			{
				status: 500,
				headers: { 'Content-Type': 'application/json' },
			}
		);
	}
}
