import Link from 'next/link';
import Image from 'next/image';

export default function Page() {
	return (
		<main className='flex min-h-screen flex-col p-6'>
			<div className='flex h-20 shrink-0 items-end rounded-lg bg-orange-500 p-4 md:h-52'></div>
			<div className='mt-4 flex grow flex-col gap-4 md:flex-row'>
				<div className='flex flex-col justify-center gap-6 rounded-lg bg-gray-50 px-6 py-10 md:w-2/5 md:px-20'>
					<div className='h-0 w-0 border-b-10 border-orange-500 border-l-5 border-transparent border-r-5' />
					<p
						className={`antialiased text-xl text-gray-800 md:text-3xl md:leading-normal`}
					>
						<strong>Welcome to Beta Annual Fund.</strong>
						<br />
						Brought to you by Ifrahim A., Luke H.
					</p>
					<Link
						href='/dashboard'
						className='flex items-center gap-5 self-start rounded-lg bg-orange-500 px-6 py-3 text-sm font-medium text-white transition-colors hover:bg-blue-400 md:text-base'
					>
						Get Started
					</Link>
				</div>
			</div>
		</main>
	);
}
