#!/bin/bash
HOME=/root
LOGNAME=root
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
LANG=en_US.UTF-8
SHELL=/bin/sh
PWD=/root
latestrelease=$(curl --silent https://api.github.com/repos/BlockchainTechLLC/3dcoin/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
localrelease=$(3dcoin-cli -version | awk -F' ' '{print $NF}' | cut -d "-" -f1)
if [ -z "$latestrelease" ] || [ "$latestrelease" == "$localrelease" ]; then 
exit;
else
apt install unzip
cd ~
localfile=${localrelease//[Vv]/3dcoin-}
rm -rf $localfile
link="https://github.com/BlockchainTechLLC/3dcoin/archive/$latestrelease.zip"
wget $link
unzip $latestrelease.zip
file=${latestrelease//[Vv]/3dcoin-}
cd $file
3dcoin-cli stop
sleep 10
./autogen.sh
./configure --disable-tests --disable-gui-tests --without-gui
make install-strip
cd ~
rm $latestrelease.zip
rm -rf $file
reboot
fi
