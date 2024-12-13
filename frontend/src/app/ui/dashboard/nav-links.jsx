'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import clsx from 'clsx';

const links = [
	{ name: 'Dashboard', href: '/dashboard' },
	{
		name: 'Donations',
		href: '/dashboard/donations',
	},
	{ name: 'Members', href: '/dashboard/members' },
	{ name: 'Reports', href: '/dashboard/reports' },
	{ name: 'Contact', href: '/dashboard/contacts' },
];

export default function NavLinks() {
	const pathname = usePathname();
	return (
		<>
			{links.map((link) => {
				return (
					<Link
						key={link.name}
						href={link.href}
						className={clsx(
							'flex h-[48px] grow items-center justify-center gap-2 rounded-md bg-gray-50 p-3 text-sm font-medium hover:bg-sky-100 hover:text-orange-600 md:flex-none md:justify-start md:p-2 md:px-3',
							{
								'bg-sky-100 text-orange-600': pathname === link.href,
							}
						)}
					>
						<p className='hidden md:block'>{link.name}</p>
					</Link>
				);
			})}
		</>
	);
}
