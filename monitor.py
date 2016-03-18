import os
import glob
import requests
import subprocess
from time import sleep

api_secret = os.environ.get('API_SECRET')
bman_directory = "/root/.wine/drive_c/users/root/Local Settings/Application Data/BoringManGame/"
server_ip = subprocess.check_output('ifconfig | grep "inet addr" | grep -v "127.0.0.1" | cut -d ":" -f 2 | cut -d " " -f 1', shell=True)
server_name = subprocess.check_output("cat '{}bm_settings.ini' | grep ServerName |cut -d '\"' -f 2".format(bman_directory), shell=True)

def forward_log_file(path):
	lines = []
	with open(path, 'r+') as file:
		lines = [line.strip() for line in file]
		file.truncate(0)
	for line in lines:
		requests.post('http://boringmanclan.com/logs', data={'secret':api_s
ecret, 'line':line, 'ip':server_ip, 'name':server_name})
		print line

def find_log_files(directory):
	return glob.glob(directory + '*log*.txt')

while True:
	log_files = find_log_files(bman_directory)
	for path in log_files:
		forward_log_file(path)
	sleep(1)