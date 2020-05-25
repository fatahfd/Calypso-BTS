#!/bin/bash
# Install OpenBTS on kalilinux
clear

installIfMissing () {
	dpkg -s $@ > /dev/null
	if [ $? -ne 0 ]; then
		echo "# - missing $@, installing dependency"
		sudo apt-get install $@ -y
		if [ $? -ne 0 ]; then
			echo "# - ERROR : $@ package was unable to be installed"
			exit 1
		fi
	fi
}
WORKINGDIR=/usr/local/src
installIfMissing toilet
toilet --metal -f smblock -W "Calypso-OpenBTS"
echo -e "\U0001F1EE\U0001F1E9 Fatahillah \e[0m Firdaus \e[49m@2020 "
echo -e "\U0001F1EE\U0001F1E9 Tested with kali linux 2019"
echo -e "⚠️ DO WITH YOUR OWN RISK"
echo -e "\U0001F1EE\U0001F1E9 Available \e[93mOptions \e[49m.	\e[39m"
PS3="🎁 Please enter your choice: "
options=("Install Depedencies" "Clone & Download OPENBTS"  "Patch" "Install OPENBTS" "Build dpkg" "Test Instalation" "Run OsmocomBB" "Run smqueue" "Run sipauthserve" "Run OpenBTS" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Install Depedencies")
		echo -e "\U0001F1EE\U0001F1E9 Install \e[42mDepedencies \e[39m \e[49m."		
		locale-gen id_ID.UTF-8
		installIfMissing m4
		installIfMissing autoconf
		installIfMissing autotools-dev
		installIfMissing automake
		installIfMissing libsqlite3-dev
		installIfMissing sqlite3
		installIfMissing libssl-dev
		installIfMissing libssl-doc
		installIfMissing zlib1g-dev
		installIfMissing build-essential
		installIfMissing dh-apparmor 
		installIfMissing dpkg-dev
		installIfMissing fakeroot
		installIfMissing g++ 
		installIfMissing gettext
		installIfMissing html2text
		installIfMissing intltool-debian 
		installIfMissing libalgorithm-diff-perl
		installIfMissing libalgorithm-diff-xs-perl
		installIfMissing libalgorithm-merge-perl
		installIfMissing libdpkg-perl
		installIfMissing libgettextpo0
		installIfMissing libmail-sendmail-perl
		installIfMissing libncurses5-dev
		installIfMissing libsys-hostname-long-perl
		
		installIfMissing dh-apparmor
		installIfMissing dpkg-dev 
		
		installIfMissing intltool
		installIfMissing libxml-parser-perl 
		
		installIfMissing libsqlite0
		installIfMissing libsqlite0-dev 
		installIfMissing libodbc1
		installIfMissing odbcinst
		installIfMissing odbcinst1debian2
		installIfMissing unixodbc-dev
		installIfMissing ntp
		installIfMissing ntpdate
		installIfMissing bind9
		
		installIfMissing libosip2-dev
		installIfMissing libortp-dev
		installIfMissing libusb-1.0-0-dev
		installIfMissing git
		echo -e "🐍Switch to repository ubuntu 16.04"
		sed -i  's/^\([^#]\)/#\1/g' /etc/apt/sources.list
		
		echo "deb http://deb.debian.org/debian/ jessie main" >> /etc/apt/sources.list
		#cat /etc/apt/sources.list
		sudo apt update 
		installIfMissing libortp9
		installIfMissing libsrtp-dev
		installIfMissing gcc-4.9
		installIfMissing g++-4.9
		#apt install gcc-4.9 g++-4.9
		#installIfMissing libstdc++6-4.7-dev 
		installIfMissing libunistring0
		#installIfMissing dh-translations
		installIfMissing python-scour
		installIfMissing python-zmq
		sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 49 --slave /usr/bin/g++ g++ /usr/bin/g++-4.9
		#sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 90 --slave /usr/bin/g++ g++ /usr/bin/g++-9
		update-alternatives --config gcc # update-alternatives --config g++
		echo -e "🐍 Switch back to Kali-Linux Repository"
		sed -i  's/^\([^#]\)/#\1/g' /etc/apt/sources.list
		echo "deb http://http.kali.org/kali kali-rolling main non-free contrib" >> /etc/apt/sources.list
		sudo apt update 
		#apt autoremove -y
	;;
	 "Clone & Download OPENBTS")
		echo -e "\U0001F1EE\U0001F1E9 Switch working directory    /usr/local/src \e[39m"
		cd $WORKINGDIR
		echo -e "\U0001F1EE\U0001F1E9 Clone    OpenBTS \e[39m" 
		rm -Rf $WORKINGDIR/dev
		git clone https://github.com/RangeNetworks/dev.git
		cd $WORKINGDIR/dev
		./clone.sh
		./switchto.sh master
		./switchto.sh 4.0
		./switchto.sh 5.0
		git clone https://github.com/tom-2015/fakecoredumper.git
		cd fakecoredumper
		chmod +x install.sh
		./install.sh	
		cd ..
		
		;;
	"Patch")
		echo -e "Patch   OpenBTS \e[39m" 
		sed -e '/installIfMissing python-software-properties/ s/^#*/#/' -i $WORKINGDIR/dev/build.sh
		sed -i '150 s/^/#/' $WORKINGDIR/dev/build.sh
		sed -i '151 s/^/#/' $WORKINGDIR/dev/build.sh
		#sed -i '151,153 s/^/#/' $WORKINGDIR/dev/build.sh
		sed -i '153 s/^/#/' $WORKINGDIR/dev/build.sh
		sed -i '52 s/^/\/\//' $WORKINGDIR/dev/CommonLibs/Logger.h
		sed -i '52 s/^/\/\//' $WORKINGDIR/dev/openbts/CommonLibs/Logger.h
		sed -i '52 s/^/\/\//' $WORKINGDIR/dev/smqueue/CommonLibs/Logger.h
		sed -i '52 s/^/\/\//' $WORKINGDIR/dev/smqueue/SR/CommonLibs/Logger.h
		sed -i '52 s/^/\/\//' $WORKINGDIR/dev/subscriberRegistry/CommonLibs/Logger.h
		
		echo "9" > $WORKINGDIR/dev/asterisk/debian/compat
		echo "9" > $WORKINGDIR/dev/smqueue/debian/compat
		echo "9" > $WORKINGDIR/dev/subscriberRegistry/debian/compat
		echo "9" > $WORKINGDIR/dev/smqueue/SR/debian/compat
		echo "9" > $WORKINGDIR/dev/liba53/debian/compat
		echo "9" > $WORKINGDIR/dev/openbts/debian/compat
		
		sed -i -e 's/--upstart-only/ /g' $WORKINGDIR/dev/smqueue/debian/rules
		sed -i -e 's/--upstart-only/ /g' $WORKINGDIR/dev/subscriberRegistry/debian/rules
		sed -i -e 's/ourRtpTimestampJumpCallback,dialogId/ourRtpTimestampJumpCallback,(void*)\&dialogId/g' $WORKINGDIR/dev/openbts/SIP/SIPRtp.cpp
		#todo : error OrtpLogFunc
		echo -e "Patch   done!! \e[39m \e[49m.." 
		;;
	"Install OPENBTS")
		apt --fix-broken install
		apt install -f
		rm -rf cd $WORKINGDIR/dev/BUILDS/*
		cd $WORKINGDIR/dev/liba53/
		make
		make install
		cd $WORKINGDIR/dev/
		./build.sh RAD1
		apt install -f
	;;
	"Run OsmocomBB")
		gnome-terminal -e ifconfig
	;;
 	 "Quit")
            break
	    clear
            ;;
        *) echo "invalid option $REPLY";;
    esac
done







