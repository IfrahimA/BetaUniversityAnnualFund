import Link from 'next/link';
import NavLinks from '../dashboard/nav-links';

export default function SideNav() {
	return (
		<div className='flex h-full flex-col px-3 py-4 md:px-2'>
			<Link
				className='mb-2 flex h-20 md:h-40 items-end justify-start rounded-md bg-orange-600 p-4  hover:bg-orange-700 transition-colors'
				href='/'
			>
				<div className='text-white text-2xl md:text-3xl font-bold tracking-wide'>
					Beta University Annual Fund
				</div>
			</Link>
			<div className='flex grow flex-row justify-between space-x-2 md:flex-col md:space-x-0 md:space-y-2'>
				<NavLinks />
				<div className='hidden h-auto w-full grow rounded-md bg-gray-50 md:block'></div>
			</div>
		</div>
	);
}
