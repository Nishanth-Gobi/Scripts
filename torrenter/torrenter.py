import argparse
import os
import sys

from tpblite import TPB

TPB_DOMAIN = 'https://tpb.party'

parser = argparse.ArgumentParser(description='Torrent Downloader')

# arguments
parser.add_argument('movie_name')
parser.add_argument('-b', '--best', action='store_true', help='Directly download the most seeded torrent')
parser.add_argument('-c', '--count', type=int, default=5, help='No. of torrents to show')
parser.add_argument('-v', '--verbose', action='store_true', help='Enable verbose mode')

args = parser.parse_args()


# ------------------------
# connect to Proton vpn
# ------------------------
try:
	if args.verbose:
		os.system('protonvpn-cli c')
	else:
		os.system('protonvpn-cli connect --fastest --protocol udp')
except:
	raise Exception('Error connecting to protoncpn-cli')
	print('Ensure you have protonvpn-cli installed.')
	sys.exit(1)


# ------------------------
# query for torrent list
# ------------------------
try: 
	tpb = TPB(TPB_DOMAIN)
except:
	raise Exception('Error creating tpb instance')
	sys.exit(1)

torrents = tpb.search(args.movie_name)

if args.verbose: print(f'\nTorrents found: {len(torrents)}\n')

if args.best:
	torrent = torrents.getBestTorrent(min_seeds=10)
	print(
			f'{"-"*50} \nBest Torrent\n'
			f'Name: {torrent.title}\n'
			f'Seeders: {torrent.seeds}\n'
			f'Size: {torrent.filesize}\n'
			f'Trusted: {torrent.is_trusted}\n'
			f'VIP: {torrent.is_vip}\n\n'
			'Magnet Link: \n'
			f'{torrent.magnetlink}\n'
			f'{"-"*50}'
		)
else:
	print('\nSelect preferred torrent: \n')
	for i, torrent in zip(range(1, args.count), torrents[:args.count+1]):
		print(
			f'Id: {i}\n'
			f'Name: {torrent.title}\n'
			f'Seeders: {torrent.seeds}\n'
			f'Size: {torrent.filesize}\n'
			f'Trusted: {torrent.is_trusted}\n'
			f'VIP: {torrent.is_vip}\n'
			f'{"-"*50}'
		)

	user_option = int(input('Enter prefered torrent: '))
	print('Magnet Link: ')
	print(torrents[user_option-1].magnetlink)
	print(f'{"-"*50}')

