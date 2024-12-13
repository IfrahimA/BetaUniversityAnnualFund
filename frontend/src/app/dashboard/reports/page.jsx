'use client';

import React from 'react';
import { Bar } from 'react-chartjs-2';
import {
	Chart as ChartJS,
	CategoryScale,
	LinearScale,
	BarElement,
	Title,
	Tooltip,
	Legend,
} from 'chart.js';

ChartJS.register(
	CategoryScale,
	LinearScale,
	BarElement,
	Title,
	Tooltip,
	Legend
);

const Page = () => {
	const annualData = {
		labels: ['2019', '2020', '2021', '2022', '2023'],
		datasets: [
			{
				label: '$ Donated',
				data: [5000, 7000, 10000, 12000, 15000],
				backgroundColor: 'rgba(255, 165, 0, 0.5)',
			},
		],
	};

	const monthlyData = {
		labels: [
			'Jan',
			'Feb',
			'Mar',
			'Apr',
			'May',
			'Jun',
			'Jul',
			'Aug',
			'Sep',
			'Oct',
			'Nov',
			'Dec',
		],
		datasets: [
			{
				label: '$ Donated',
				data: [
					400, 600, 800, 700, 900, 1100, 1000, 1200, 1500, 1300, 1400, 1600,
				],
				backgroundColor: 'rgba(204, 132, 0, 0.5)',
			},
		],
	};

	const options = {
		responsive: true,
		plugins: {
			legend: {
				position: 'top',
			},
			title: {
				display: true,
				text: 'Donation Report',
			},
		},
	};

	return (
		<div style={{ padding: '20px' }}>
			<h1>Report Page</h1>

			<section style={{ marginBottom: '40px' }}>
				<h2>Annual Report</h2>
				<Bar data={annualData} options={options} />
			</section>

			<section>
				<h2>Monthly Report</h2>
				<Bar data={monthlyData} options={options} />
			</section>
		</div>
	);
};

export default Page;
