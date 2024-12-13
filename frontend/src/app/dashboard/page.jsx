import React from 'react';
import { totalRaised } from '../utils/queries';
import { RaisedPerClassYear } from '../components/RaisedPerClass';
import { DonorByCategory } from '../components/DonorPerCategory';
import { DonationPerCircle } from '../components/DonationPerCircle';
import { PaymentsDue } from '../components/PaymentsDue';
import { DonationPerEvent } from '../components/DonationPerEvent';

export default async function Page() {
	const data = await totalRaised();
	const percentage = 95;
	return (
		<div className='flex flex-col items-center justify-center min-h-screen p-6'>
			<div className='text-3xl font-semibold text-gray-800 text-center'>
				Annual Report
			</div>
			<div className='grid grid-cols-1 md:grid-cols-2 gap-6 w-full max-w-4xl'>
				<div className='bg-white rounded-lg p-6 shadow-lg w-80'>
					<div className='text-center mb-4'>
						<h3 className='text-xl font-semibold text-gray-800'>
							Fundraising Progress
						</h3>
					</div>
					<div className='text-center mb-4'>
						<div className='mb-2'>
							<h4 className='text-lg text-gray-700'>Total Raised</h4>
							<p className='text-2xl font-bold text-orange-600'>
								${data[0].total_raised_from_all_donors}
							</p>
						</div>
						<div className='w-full bg-gray-200 rounded-full h-2.5 mb-4'>
							<div
								className='bg-orange-500 h-2.5 rounded-full'
								style={{ width: `${percentage}%` }}
							></div>
						</div>
						<div>
							<p className='text-sm text-gray-500'>Goal: $50,000$</p>
						</div>
					</div>
				</div>
				<RaisedPerClassYear />
				<DonorByCategory />
				<DonationPerCircle />
				<PaymentsDue />
				<DonationPerEvent />
			</div>
		</div>
	);
}
