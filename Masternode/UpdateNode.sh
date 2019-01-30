#!/bin/bash
HOME=/root
LOGNAME=root
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
LANG=en_US.UTF-8
SHELL=/bin/sh
PWD=/root
LOGFILE='/usr/local/bin/Masternode/update.log'
dt=`date '+%d/%m/%Y_%H:%M:%S'`
latestrelease=$(curl --silent https://api.github.com/repos/BlockchainTechLLC/3dcoin/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
localrelease=$(3dcoin-cli -version | awk -F' ' '{print $NF}' | cut -d "-" -f1)
if [ -z "$latestrelease" ] || [ "$latestrelease" == "$localrelease" ]; then 
echo "[$dt] : There is no New Update latest release is $latestrelease" >> $LOGFILE
exit;
else
echo "[$dt] : Starting Update $latestrelease" >> $LOGFILE
echo "[$dt] : apt install unzip" >> $LOGFILE
apt install unzip
cd ~
localfile=${localrelease//[Vv]/3dcoin-}
echo "[$dt] : remove $localfile" >> $LOGFILE
rm -rf $localfile
link="https://github.com/BlockchainTechLLC/3dcoin/archive/$latestrelease.zip"
echo "[$dt] : Download Last Update $link" >> $LOGFILE
wget $link
echo "[$dt] : Unzip $latestrelease.zip" >> $LOGFILE
unzip $latestrelease.zip
file=${latestrelease//[Vv]/3dcoin-}
cd $file
echo "[$dt] : Stop 3DCoin core $localrelease" >> $LOGFILE
3dcoin-cli stop
sleep 10
echo "[$dt] : autogen.sh" >> $LOGFILE
./autogen.sh
echo "[$dt] : configure" >> $LOGFILE
./configure --disable-tests --disable-gui-tests --without-gui
echo "[$dt] : make install-strip" >> $LOGFILE
make install-strip
cd ~
echo "[$dt] : remove $latestrelease.zip" >> $LOGFILE
rm $latestrelease.zip
echo "[$dt] : remove $file" >> $LOGFILE
rm -rf $file
echo "[$dt] : rebooting " >> $LOGFILE  
reboot
fi
