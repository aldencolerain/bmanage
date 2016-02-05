#!/bin/sh

# settings
BORING_SETTINGS_FOLDER="$HOME/.wine/drive_c/users/$USER/Local Settings/Application Data/BoringManGame"

# install
install() {
	
	# setup machine
	apt-get update && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
	apt-get install xvfb -y
	apt-get install x11vnc -y
	# setup vnc password
	mkdir ~/.vnc
	x11vnc -storepasswd $1 ~/.vnc/passwd
	# setup wine
	echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
	apt-get install wine -y
	# disable sound
	wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
	bash winetricks sound=disabled
	# install boring man
	installbm
}

# install / update boring man
installbm() {
	# install latest boring man
	BM_VERSION="$(wget -O - http://spasmangames.com/boringman/ | grep downloads | awk -v FS='(downloads/|.zip)' '{print $2}')"
	rm -r ~/BoringMan
	wget http://spasmangames.com/downloads/$BM_VERSION.zip -O ~/BoringMan.zip
	unzip ~/BoringMan.zip -d ~/.wine/drive_c/BoringMan
}


# start all processes (and hide output)
start() {
	# start display
	Xvfb :1 -screen 0 320x240x16 -cc 4 -nolisten tcp -ac > /dev/null 2>&1 &
	sleep 1
	# start vnc
	x11vnc -noxdamage -many -usepw -display :1 > /dev/null 2>&1 &
	# start boringman
	env DISPLAY=":1.0" wine ~/.wine/drive_c/BoringMan/BoringManGame.exe > /dev/null 2>&1 &
	# print status
	status
}


# helper: kill a process by name
kill() {
	ps -ef | grep $1 | grep -v grep | awk '{print $2}' | xargs kill -9
}


# stop all processes
stop() {
	# kill all processes
	#wineserver -k
	kill "BoringMan"
	kill "vnc"
	kill "Xvfb"
	# print status
	status
}


# helper: check status of process
check() {
	if ps -ef | grep $1 | grep -v grep;
		then echo "The $1 process is running.";
		else echo "The $1 process is stopped.";
	fi
}


# print status of aech
status() {
	check "BoringMan"
	check "vnc"
	check "Xvfb"
}

# copy settings file into current directory
pull() {
	cp "$BORING_SETTINGS_FOLDER/bm_settings.ini" ./settings.ini
}

# copy settings file into boring man directory
push() {
	if [ ! -f "$BORING_SETTINGS_FOLDER/bm_settings.ini.bak" ];
		then cp "$BORING_SETTINGS_FOLDER/bm_settings.ini" "$BORING_SETTINGS_FOLDER/bm_settings.ini.bak"
	fi
	cp ./$1 "$BORING_SETTINGS_FOLDER/bm_settings.ini"
}

# copy settings file into boring man directory
pushmaps() {
	if [ ! -f "$BORING_SETTINGS_FOLDER/maplist.txt.bak" ];
		then cp "$BORING_SETTINGS_FOLDER/maplist.txt" "$BORING_SETTINGS_FOLDER/maplist.txt.bak"
	fi
	cp ./$1 "$BORING_SETTINGS_FOLDER/maplist.txt"
}

# check command line arguments
if [[ "$1" == "install" && "$#" < 2 ]];
	then echo "Please provide a vnc password when installing. Usage: $0 install myvncpassword"
	exit 1
fi
if [[ "$1" == "push" && "$#" < 2 ]];
	then echo "Please provide a settings file to push to boring man. Usage: $0 push mysettings.ini"
	exit 1
fi

# process command line arguments
case "$1" in
	install)                install $2;;
	start)                  start ;;
	stop)                   stop ;;
	restart)                stop; sleep 1; start ;;
	status)                 status ;;
	update)                 start; installbm; stop;;
	pull)                   pull;;
	push)                   push $2;;
	pushmaps)               pushmaps $2;;
	*)                      echo "Usage: $0 install myvncpassword|start|stop|restart|status|update|push|pushmaps" >&2
							exit 1
							;;
esac