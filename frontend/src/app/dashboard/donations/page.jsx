import React from 'react';
import { fetchDonations } from '@/app/utils/queries';

export default async function DonationsPage() {
	const data = await fetchDonations();

	return (
		<div className='flex justify-center items-center min-h-screen bg-gray-50 p-4'>
			<div className='bg-white rounded-lg p-6 shadow-lg w-96'>
				<div className='text-center mb-4'>
					<h3 className='text-2xl font-semibold text-gray-800'>
						Donor Contributions
					</h3>
				</div>
				<div>
					{data.length > 0 ? (
						data.map((donation, index) => (
							<div
								key={donation.donorid || index}
								className='flex justify-between items-center py-3 border-b last:border-none'
							>
								<div className='text-lg text-gray-700'>
									{donation.firstname} {donation.lastname}
								</div>
								<div className='text-lg text-orange-600 font-semibold'>
									${parseFloat(donation.total_donation).toFixed(2)}
								</div>
							</div>
						))
					) : (
						<p className='text-center text-gray-500'>No donations found</p>
					)}
				</div>
			</div>
		</div>
	);
}
