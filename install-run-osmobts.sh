#!/bin/bash
# Install OsmoBTS on kalilinux
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
sayAndDo () {
        echo 🆙 $@
        eval $@
        if [ $? -ne 0 ]
        then
                echo "ERROR: command failed!"
                exit 1
        fi
}

xTrim() {
    local var="$*"
    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   
    return $var
}

DownloadExtract(){
		toilet   -f smblock -W $3
		zfile = $1 | xargs
		echo -e "↓ Download  $WORKINGDIR/$1"
		sayAndDo cd $WORKINGDIR
		if [[ -f $WORKINGDIR/$1 ]]; then
		   echo "file exist";
		   else
		   sayAndDo wget $2;
		fi 
		rm -rf $WORKINGDIR/$3
		{ # try

		   sayAndDo gzip -dc < $WORKINGDIR/$1 | tar -xf - 
		    #save your output

		} || { # catch
			tar xvzf $WORKINGDIR/$1
		    # save log for exception 
		}
		

}

DirClone(){
	echo -e "☢️ clone " $2
	cd $WORKINGDIR
	if [ -d $WORKINGDIR/$2 ]; then
		cd $WORKINGDIR/$2
		sayAndDo git pull
	else			
		sayAndDo git clone $1 $2
	fi
	cd $WORKINGDIR
}

DirInstall(){
	echo -e "♨️ install " $1	
	cd $WORKINGDIR/$1
	sayAndDo autoreconf -f -i
	sayAndDo ./configure $2
	sayAndDo make
	sayAndDo sudo make install 
	sayAndDo sudo ldconfig
}

DirCloneInstall(){
	toilet   -f smblock -W $2
	DirClone $1 $2 
	DirInstall $2 $3
}
WORKINGDIR=/usr/local/src
TRXPDIR=~
TRXDIR=$TRXPDIR/trx
ARFCN=85
installIfMissing toilet
toilet --metal -f smblock -W "Calypso-OsmoBTS"
echo -e "\U0001F1EE\U0001F1E9 Fatahillah \e[0m Firdaus \e[49m@2020 "
echo -e "\U0001F1EE\U0001F1E9 Tested with kali linux 2019"
echo -e "⚠️ DO WITH YOUR OWN RISK"
echo -e "\U0001F1EE\U0001F1E9 Available \e[93mOptions \e[49m.	\e[39m"
PS3="🎁 Please enter your choice: "
options=("Install Depedencies" "Install cross-compiler" "Install OsmoBTS"  "Install Linux-Call-Router"   "Run OsmocomBB" "Run OsmoNITB" "Run Osmobts-trx" "Run LCR" "Run Asterisk" "Telnet NITB" "Telnet BTS" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Install Depedencies")
		echo -e "\U0001F1EE\U0001F1E9 Install \e[42mDepedencies \e[39m \e[49m."		
		locale-gen id_ID.UTF-8
		sudo apt update
		installIfMissing speedtest-cli
		#sayAndDo speedtest-cli
		installIfMissing git
		installIfMissing dialog
		installIfMissing build-essential
		installIfMissing libgmp-dev
		installIfMissing libx11-6 
		installIfMissing libx11-dev
		installIfMissing flex
		installIfMissing libncurses5
		installIfMissing libncurses5-dev
		installIfMissing libncursesw6
		installIfMissing libpcsclite-dev
		installIfMissing zlib1g-dev
		installIfMissing libmpfr4
		installIfMissing libmpc3
		installIfMissing lemon
		installIfMissing aptitude
		installIfMissing libtinfo-dev
		installIfMissing libtool 
		installIfMissing shtool 
		installIfMissing autoconf 
		installIfMissing git-core 
		installIfMissing pkg-config 
		installIfMissing make 
		installIfMissing libmpfr-dev 
		installIfMissing libmpc-dev 
		installIfMissing libtalloc-dev 
		installIfMissing libfftw3-dev 
		installIfMissing libgnutls28-dev 
		
		installIfMissing libtool-bin 
		installIfMissing libxml2-dev 
		installIfMissing sofia-sip-bin 
		installIfMissing libsofia-sip-ua-dev 
		installIfMissing sofia-sip-bin 
		installIfMissing libncursesw5-dev  
		installIfMissing bison 
		installIfMissing libgmp3-dev 
		installIfMissing alsa-oss 
		installIfMissing cmake 
		installIfMissing asn1c
		installIfMissing libdbd-sqlite3
		installIfMissing sqlite3
		installIfMissing libsqlite3-dev 
		installIfMissing libtool 
		installIfMissing shtool 
		installIfMissing automake 
		installIfMissing autoconf 
		installIfMissing git-core 
		installIfMissing pkg-config 
		installIfMissing gcc 
		installIfMissing libusb-1.0 
		installIfMissing dahdi-source
		installIfMissing build-essential 
		installIfMissing libtool 
		installIfMissing libtalloc-dev 
		installIfMissing shtool 
		installIfMissing autoconf 
		installIfMissing automake 
		installIfMissing git-core 
		installIfMissing libdbd-sqlite3 
		installIfMissing libortp-dev 
		installIfMissing libtalloc-dev 
		installIfMissing libpcsclite-dev 
		installIfMissing libsctp-dev 
		installIfMissing libsctp1 
		installIfMissing libc-ares-dev 
		installIfMissing libgtp-dev 
		installIfMissing libsofia-sip-ua-glib-dev 
		installIfMissing libpcap-dev 
		installIfMissing libpcap0.8 
		installIfMissing libpcap0.8-dbg 
		installIfMissing libpcap0.8-dev 
		installIfMissing libmnl-dev 
		installIfMissing libc-ares-dev
		installIfMissing alsa-oss 
		installIfMissing libncursesw5
		
		echo -e "🐍Switch to repository ubuntu 16.04"
		sed -i  's/^\([^#]\)/#\1/g' /etc/apt/sources.list
		
		echo "deb http://deb.debian.org/debian/ jessie main" >> /etc/apt/sources.list
		#cat /etc/apt/sources.list
		sudo apt update 
		installIfMissing libortp9
		installIfMissing libsrtp-dev
		installIfMissing gcc-4.9
		installIfMissing g++-4.9
		installIfMissing gcc-4.8
		installIfMissing g++-4.8
		#apt install gcc-4.9 g++-4.9
		#installIfMissing libstdc++6-4.7-dev 
		installIfMissing libunistring0
		#installIfMissing dh-translations
		installIfMissing python-scour
		installIfMissing python-zmq
		installIfMissing libssl1.0-dev 
		sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 49 --slave /usr/bin/g++ g++ /usr/bin/g++-4.9
		sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 48 --slave /usr/bin/g++ g++ /usr/bin/g++-4.8
		#sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 90 --slave /usr/bin/g++ g++ /usr/bin/g++-9
		#sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 48 
		#sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 49
		#sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 48  

		sayAndDo update-alternatives --config gcc 
		sayAndDo update-alternatives --config g++
		echo -e "🐍 Switch back to Kali-Linux Repository"
		sed -i  's/^\([^#]\)/#\1/g' /etc/apt/sources.list
		echo "deb http://http.kali.org/kali kali-rolling main non-free contrib" >> /etc/apt/sources.list
		sayAndDo sudo apt update 
		#apt autoremove -y
	;;
	"Install cross-compiler")
		toilet   -f smblock -W "Cross Compiler"
		cd $WORKINGDIR
		 
		
		toilet   -f smblock -W "texinfo"
		sayAndDo apt remove texinfo  	
		DownloadExtract texinfo-4.13.tar.gz http://ftp.gnu.org/gnu/texinfo/texinfo-4.13.tar.gz texinfo-4.13 
		cd $WORKINGDIR/texinfo-4.13
		./configure 
		sayAndDo make
		sayAndDo make install 
		sayAndDo ldconfig
		
		cd $WORKINGDIR
		
		toilet   -f smblock -W "GNU-arm"
		DirClone https://github.com/axilirator/gnu-arm-installer.git gnuarm
		sayAndDo cd $WORKINGDIR/gnuarm
		sayAndDo ./download.sh 
		sayAndDo ./build.sh 
		
		
		echo  PATH=$PATH:$WORKINGDIR/gnuarm/install/bin >> ~/.bashrc
		export PATH=$PATH:$WORKINGDIR/gnuarm/install/bin
	;;
	 "Install OsmoBTS")
	 	clear
	 	toilet   -f smblock -W "Install OsmoBTS"
		echo -e "\U0001F1EE\U0001F1E9 Switch working directory     $WORKINGDIR \e[39m"
		cd $WORKINGDIR
		echo -e "\U0001F1EE\U0001F1E9 ==start== \e[39m"
		
		#opencore
		DownloadExtract opencore-amr-0.1.5.tar.gz https://nchc.dl.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-0.1.5.tar.gz opencore-amr-0.1.5
		DirInstall opencore-amr-0.1.5  
		
		cd $WORKINGDIR
		DownloadExtract libdbi-0.8.3.tar.gz  https://liquidtelecom.dl.sourceforge.net/project/libdbi/libdbi/libdbi-0.8.3/libdbi-0.8.3.tar.gz libdbi-0.8.3
		#DownloadExtract libdbi-0.8.3.tar.gz  https://sourceforge.net/projects/libdbi/files/libdbi/libdbi-0.8.3/libdbi-0.8.3.tar.gz/download libdbi-0.8.3 libdbi-0.8.3
		cd libdbi-0.8.3
		./autogen.sh
		DirInstall libdbi-0.8.3 --disable-docs	
		
		DownloadExtract libdbi-drivers-0.8.3.alterado.tar.gz https://raw.githubusercontent.com/spm81/CalypsoBTS/master/libdbi-drivers-0.8.3.alterado.tar.gz
		cd libdbi-drivers-0.8.3.alterado 
		./autogen.sh
		DirInstall libdbi-drivers-0.8.3.alterado  --disable-docs --with-sqlite3 --with-sqlite3-dir=/usr/bin --with-dbi-incdir=/usr/local/include
		
		DirCloneInstall git://git.osmocom.org/libosmocore.git libosmocore
		DirCloneInstall git://git.osmocom.org/libosmo-dsp.git libosmo-dsp
		DirCloneInstall git://git.osmocom.org/libsmpp34.git libsmpp34-dsp
	 
		https://github.com/osmocom/libgtpnl.git
		DirCloneInstall https://github.com/osmocom/libgtpnl.git libgtpnl
		#DirCloneInstall https://github.com/osmocom/libosmo-abis libosmo-abis	
		DirCloneInstall git://git.osmocom.org/libosmo-abis.git libosmo-abis
		DirCloneInstall git://git.osmocom.org/libosmo-netif.git libosmo-netif
		DirCloneInstall https://github.com/osmocom/osmo-hlr osmo-hlr
		DirCloneInstall git://git.osmocom.org/osmo-ggsn.git osmo-ggsn --enable-gtp-linux 
 		DirCloneInstall git://git.osmocom.org/osmo-sgsn.git osmo-sgsn
 		
 		
		DirClone  git://git.osmocom.org/openbsc.git openbsc
		
		sayAndDo cd openbsc/openbsc/
		sayAndDo autoreconf -i
		sayAndDo ./configure
		sayAndDo make
		sayAndDo sudo make install
		
		DirCloneInstall git://git.osmocom.org/osmo-bts.git osmo-bts --enable-trx
		
		
		toilet   -f smblock -W "OsmocomBB~trx"
		sayAndDo rm -rf $TRXDIR/
		sayAndDo cd $TRXPDIR
		sayAndDo 	
		sayAndDo cd $TRXDIR/src		 
		sayAndDo echo "CFLAGS += -DCONFIG_TX_ENABLE" >> $TRXDIR/src/target/firmware/Makefile
		#sed -i '32 s/^/\/\//' $TRXDIR/trx/src/target/firmware/include/stdint.h
		#sed -i '33 s/^/\/\//' $TRXDIR/trx/src/target/firmware/include/stdint.h
		sayAndDo make HOST_layer23_CONFARGS=--enable-transceiver
		
		

		
		
		
		
		;;
		
	"Install Linux-Call-Router")
		#misdn
		installIfMissing linux-headers-$(uname -r)
		sayAndDo cd $WORKINGDIR
		depmod -a 
		DirClone https://github.com/ISDN4LINUX/mISDN mISDN
		DirClone https://github.com/bbaranoff/osmocombb-ansible bbaranoff-ansible
		sayAndDo cd $WORKINGDIR/mISDN
		sayAndDo aclocal; automake --add-missing 
		sayAndDo ./configure
		sayAndDo cp ../bbaranoff-ansible/mISDN.cfg.default standalone/mISDN.cfg 
		echo "CONFIG_MISDN_HDLC" >> standalone/mISDN.cfg 
		sayAndDo make modules 
		sayAndDo make modules_install 
		
		sayAndDo cd $WORKINGDIR
		DirCloneInstall https://github.com/ISDN4LINUX/mISDNuser mISDNuser
		
		
		#asterisk
		cd $WORKINGDIR
		DownloadExtract asterisk-1.8.13.1.tar.gz  https://downloads.asterisk.org/pub/telephony/asterisk/old-releases/asterisk-1.8.13.1.tar.gz asterisk-1.8.13.1
		sed -i -e 's/SSL_CTX_new(SSLv3_client_method())/SSL_CTX_new(SSLv23_client_method())/g' $WORKINGDIR/asterisk-1.8.13.1/main/tcptls.c 
		sed -i -e 's/SSL_CTX_new(SSLv2_client_method())/SSL_CTX_new(SSLv23_client_method())/g' $WORKINGDIR/asterisk-1.8.13.1/main/tcptls.c 
		 
		 
		    read -p "Do you wish to install this Asterisk prereq? (y/n)" yn
		    case $yn in
			[Yy]* ) 
				$WORKINGDIR/asterisk-1.8.13.1/contrib/scripts/install_prereq install
			;;
			[Nn]* ) echo "skip..."
			 
			;;
			* ) echo "Please answer yes or no.";;
		    esac
		 
		#DirInstall asterisk-1.8.13.1 
		sayAndDo cd $WORKINGDIR/asterisk-1.8.13.1 
		sayAndDo ./configure --with-ssl --enable-ssl 
		sayAndDo make
		sayAndDo sudo make install
		sayAndDo ldconfig
		
		
		#lcr
		DirCloneInstall https://github.com/fairwaves/lcr  lcr --with-sip --with-gsm-bs --with-gsm-ms --with-asterisk 
		
		modprobe snd_pcm_oss
		modprobe snd_mixer_oss 
		modprobe mISDN_core
		modprobe mISDN_dsp
		#
	;;
	 
	"Run OsmocomBB")
		clear
		toilet   -f smblock -W "OsmocomBB trx"
		#!/bin/bash

		HEIGHT=15
		WIDTH=40
		CHOICE_HEIGHT=4
		BACKTITLE="Run Apps"
		TITLE="OsmocomBB"
		MENU="Choose one of the following options:"

		OPTIONS=(1 "Phone 1"
			 2 "Phone 2"
			 3 "Transceiver")

		CHOICE=$(dialog --clear \
				--backtitle "$BACKTITLE" \
				--title "$TITLE" \
				--menu "$MENU" \
				$HEIGHT $WIDTH $CHOICE_HEIGHT \
				"${OPTIONS[@]}" \
				2>&1 >/dev/tty)

		clear
		#
		case $CHOICE in
			1)
			    cd $TRXDIR/src
			    ./host/osmocon/osmocon -m c123xor -p /dev/ttyUSB0 -s /tmp/osmocom_l2 -c target/firmware/board/compal_e88/trx.highram.bin -r 99
			    ;;
			2)
			    cd $TRXDIR/src
			    ./host/osmocon/osmocon -m c123xor -p /dev/ttyUSB1 -s /tmp/osmocom_l2.2 -c target/firmware/board/compal_e88/trx.highram.bin -r 99
			    ;;
			3)
			    exec 3>&1;
			    ZCHOICE=$(dialog --clear --backtitle "Backtitle here" --title "Title here" --inputbox "Input ARFCN number" 10 20 $ARFCN 2>&1 >/dev/tty )
			    clear
			    ARFCN=$ZCHOICE
			    cd $TRXDIR/src/host/layer23/src/transceiver/
			    ./transceiver -a $ARFCN -2 -r 99
			    ;;
		esac

	;;
	"Run OsmoNITB")
		clear
		toilet   -f smblock -W "OsmoNITB"
		osmo-nitb -c ~/.osmocom/open-bsc.cfg -l ~/.osmocom/hlr.sqlite3 -P -m -C --debug=DRLL:DCC:DMM:DRR:DRSL:DNM    
	;;
	"Run Osmobts-trx")
		osmo-bts-trx -c ~/.osmocom/osmo-bts.cfg -r 99
	;;
	"Run LCR")
		clear
		toilet   -f smblock -W "LCR"
		 modprobe snd_pcm_oss 
		 modprobe snd_mixer_oss 
		 modprobe mISDN_core
		 modprobe mISDN_dsp
		lcr start
	;;
	"Run Asterisk")
		clear
		toilet   -f smblock -W "Asterisk"
		asterisk
		asterisk -rvvvvvv
	;; 
	"Telnet NITB")
		
		telnet localhost 4242
	;;
	"Telnet BTS")
		telnet localhost 4241
	;; 
 	 "Quit")
            break
	    clear
            ;;
        *) echo "invalid option $REPLY";;
    esac
done







