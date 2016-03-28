import os
import glob
import requests
import subprocess
from time import sleep

try: import secrets
except: pass

api_secret = os.environ['API_SECRET']
bman_directory = "/root/.wine/drive_c/users/root/Local Settings/Application Data/BoringManGame/"
server_ip = subprocess.check_output('ifconfig | grep "inet addr" | grep -v "127.0.0.1" | cut -d ":" -f 2 | cut -d " " -f 1', shell=True)
server_name = subprocess.check_output("cat '{}bm_settings.ini' | grep ServerName | cut -d '\"' -f 2".format(bman_directory), shell=True)

def forward_log_file(path):
	lines = []
	with open(path, 'r+') as file:
		lines = [line.strip() for line in file]
		file.truncate(0)
	for line in lines:
		requests.post('http://boringmanclan.com/api/logs', data={'secret':api_secret, 'line':line, 'ip':server_ip, 'name':server_name})
		print line

def find_log_files(directory):
	return glob.glob(directory + '*log*.txt')

def update_password():
	data = requests.post('http://boringmanclan.com/api/reservation', data={'secret':api_secret, 'ip':server_ip, 'name':server_name}).json()
	password = data.get('password')
	map = data.get('map')
	current_pass = subprocess.check_output("cat '{}bm_settings.ini' | grep ^Password | cut -d '\"' -f 2".format(bman_directory), shell=True)
	if str(password.strip()) != str(current_pass.strip()):
		subprocess.call('bash bmanage.sh stop', shell=True)
		sleep(1)
		subprocess.call('bash bmanage.sh password {}'.format(password), shell=True)
		subprocess.call('bash bmanage.sh map {}'.format('bm_' + map + '.bmap'), shell=True)
		subprocess.call('bash bmanage.sh start', shell=True)
		

	

while True:
	try:
		log_files = find_log_files(bman_directory)
		for path in log_files:
			forward_log_file(path)
		update_password()
	except:
		pass
	sleep(3)
