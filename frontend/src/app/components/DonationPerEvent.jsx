'use client';
import React, { useState } from 'react';

// Define the event types
const EVENT_TYPES = [
	'Annual Gala',
	'Homecoming',
	'Faculty Dinner',
	'Student Orientation',
	'Fundraising Banquet',
	'Alumni Meet & Greet',
];

export const DonationPerEvent = () => {
	// State to track selected event and donations
	const [selectedEvent, setSelectedEvent] = useState(EVENT_TYPES[0]);
	const [eventDonations, setEventDonations] = useState([]);

	// Handler for event dropdown change
	const handleEventChange = async (event) => {
		const newSelectedEvent = event.target.value;
		setSelectedEvent(newSelectedEvent);

		// Fetch donations for the selected event
		try {
			const donations = await fetchEventDonations(newSelectedEvent);
			setEventDonations(donations);
		} catch (error) {
			console.error('Failed to fetch event donations:', error);
			setEventDonations([]);
		}
	};

	return (
		<div className='bg-white rounded-lg p-6 shadow-lg w-80'>
			<div className='mb-4'>
				<h3 className='text-xl font-semibold text-gray-800 text-center mb-2'>
					Event Donations
				</h3>

				{/* Event Dropdown */}
				<select
					value={selectedEvent}
					onChange={handleEventChange}
					className='w-full p-2 border rounded-md text-gray-700'
				>
					{EVENT_TYPES.map((event) => (
						<option key={event} value={event}>
							{event}
						</option>
					))}
				</select>
			</div>

			{/* Donations List */}
			<div>
				{eventDonations.length > 0 ? (
					eventDonations.map((donation, index) => (
						<div
							key={index}
							className='flex justify-between items-center py-2 border-b last:border-none'
						>
							<div className='text-lg text-gray-700'>{donation.donor_name}</div>
							<div className='text-lg text-orange-600 font-semibold'>
								${donation.amount.toFixed(2)}
							</div>
						</div>
					))
				) : (
					<p className='text-center text-gray-500'>
						No donations found for this event
					</p>
				)}
			</div>
		</div>
	);
};

// Placeholder async function to fetch event donations
// Replace with actual API call in your implementation
async function fetchEventDonations(event) {
	// This is a mock implementation
	// In a real app, this would be an API call to your backend
	const mockDonations = {
		'Annual Gala': [
			{ donor_name: 'John Doe', amount: 5000 },
			{ donor_name: 'Jane Smith', amount: 7500 },
		],
		Homecoming: [
			{ donor_name: 'Mike Johnson', amount: 3000 },
			{ donor_name: 'Sarah Williams', amount: 4500 },
		],
		// Add mock data for other events...
		'Faculty Dinner': [],
		'Student Orientation': [],
		'Fundraising Banquet': [],
		'Alumni Meet & Greet': [],
	};

	// Simulate network delay
	await new Promise((resolve) => setTimeout(resolve, 500));

	return mockDonations[event] || [];
}
