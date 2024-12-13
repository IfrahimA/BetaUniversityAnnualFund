'use client';

import { useState } from 'react';

export default function Page() {
	const [firstName, setFirstName] = useState('');
	const [lastName, setLastName] = useState('');
	const [email, setEmail] = useState('');
	const [phoneNumber, setPhoneNumber] = useState('');
	const [donationAmount, setDonation] = useState('');
	const [classYear, setClassYear] = useState('');
	const [category, setCategory] = useState('');
	const [payment, setPayment] = useState('');
	const [matchingGiftEligible, setMatchingGiftEligible] = useState('');

	const submitForm = async (e) => {
		const date = new Date();
		const formattedDate = date.toISOString().split('T')[0]; // "2024-01-01"

		e.preventDefault();
		try {
			const donorApi = await fetch('/api/donor', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({
					firstName,
					lastName,
					phoneNumber,
					email,
					category,
				}),
			});

			const donorId = donorApi.donorId;

			const donationApi = await fetch('/api/donation', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({
					donationAmount,
					formattedDate,
					matchingGiftEligible,
					donorId,
				}),
			});

			const classApi = await fetch('/api/class', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({
					classYear,
					donorId,
				}),
			});

			const paymentApi = await fetch('/api/payment', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({
					classYear,
					donorId,
				}),
			});

			if (donorApi.ok && donationApi.ok && classApi.ok && paymentApi.ok) {
				alert('Your donation have been added successfully!');
				revalidatePath('/dashboard')
			}
		} catch (error) {
			console.error('Request failed:', error); // Log any unexpected errors
			alert('An unexpected error occurred.');
		}
	};

	return (
		<div className='min-h-screen flex justify-center items-center'>
			<form className='w-full max-w-md px-4' onSubmit={submitForm}>
				<div className='mb-4'>
					<label className='block text-sm font-medium text-gray-700'>
						First Name
					</label>
					<input
						type='text'
						id='firstName'
						name='firstName'
						onChange={(e) => setFirstName(e.target.value)}
						className='mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-orange-500 focus:border-orange-500 block w-full'
					/>
				</div>

				<div className='mb-4'>
					<label className='block text-sm font-medium text-gray-700'>
						Last Name
					</label>
					<input
						type='text'
						id='lastName'
						name='lastName'
						onChange={(e) => setLastName(e.target.value)}
						className='mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-orange-500 focus:border-orange-500 block w-full'
					/>
				</div>

				<div className='mb-4'>
					<label className='block text-sm font-medium text-gray-700'>
						Email (Optional)
					</label>
					<input
						type='email'
						id='email'
						name='email'
						onChange={(e) => setEmail(e.target.value)}
						className='mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-orange-500 focus:border-orange-500 block w-full'
					/>
				</div>

				<div className='mb-4'>
					<label className='block text-sm font-medium text-gray-700'>
						Phone Number (Optional)
					</label>
					<input
						type='tel'
						id='phone'
						name='phone'
						onChange={(e) => setPhoneNumber(e.target.value)}
						className='mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-orange-500 focus:border-orange-500 block w-full'
					/>
				</div>

				<div className='mb-4'>
					<label className='block text-sm font-medium text-gray-700'>
						Donation Amount
					</label>
					<input
						type='number'
						id='donationAmount'
						name='donationAmount'
						min='1'
						step='0.01'
						onChange={(e) => setDonation(e.target.value)}
						className='mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-orange-500 focus:border-orange-500 block w-full'
					/>
				</div>

				<div className='mb-4'>
					<label className='block text-sm font-medium text-gray-700'>
						Matching Gift Eligible
					</label>
					<div className='mt-2 flex items-center'>
						<label className='inline-flex items-center mr-4'>
							<input
								type='radio'
								id='matchingGiftYes'
								name='matchingGiftEligible'
								value='yes'
								onChange={() => setMatchingGiftEligible('Yes')}
								className='h-4 w-4 text-orange-500 border-gray-300 rounded focus:ring-orange-500'
							/>
							<span className='ml-2 text-sm text-gray-700'>Yes</span>
						</label>
						<label className='inline-flex items-center'>
							<input
								type='radio'
								id='matchingGiftNo'
								name='matchingGiftEligible'
								value='no'
								onChange={() => setMatchingGiftEligible('No')}
								className='h-4 w-4 text-orange-500 border-gray-300 rounded focus:ring-orange-500'
							/>
							<span className='ml-2 text-sm text-gray-700'>No</span>
						</label>
					</div>
				</div>

				<div className='mb-4'>
					<label className='block text-sm font-medium text-gray-700'>
						Year (2015 and higher)
					</label>
					<input
						type='number'
						id='year'
						name='year'
						min='2015'
						onChange={(e) => setClassYear(e.target.value)}
						className='mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-orange-500 focus:border-orange-500 block w-full'
					/>
				</div>

				<div className='mb-4'>
					<label className='block text-sm font-medium text-gray-700'>
						Category
					</label>
					<select
						id='class'
						name='class'
						onChange={(e) => setCategory(e.target.value)}
						className='mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-orange-500 focus:border-orange-500 block w-full'
					>
						<option value='Alumni'>Alumni</option>
						<option value='Parent'>Parent</option>
						<option value='Family'>Family</option>
						<option value='Faculty'>Faculty</option>
						<option value='Student'>Student</option>
						<option value='Other'>Other</option>
					</select>
				</div>

				<div className='mb-4'>
					<label className='block text-sm font-medium text-gray-700'>
						Payment Method
					</label>
					<select
						id='payment'
						name='payment'
						onChange={(e) => setPayment(e.target.value)}
						className='mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-orange-500 focus:border-orange-500 block w-full'
					>
						<option value='credit'>Credit Card</option>
						<option value='debit'>Debit Card</option>
						<option value='deferred'>Deferred</option>
					</select>
				</div>

				<button
					type='submit'
					className='bg-orange-500 hover:bg-orange-700 text-white font-bold py-2 px-4 rounded'
				>
					Submit
				</button>
			</form>
		</div>
	);
}
