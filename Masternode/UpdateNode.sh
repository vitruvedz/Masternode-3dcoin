#!/bin/bash
HOME=/root
LOGNAME=root
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
LANG=en_US.UTF-8
SHELL=/bin/sh
PWD=/root
LOGFILE='/usr/local/bin/Masternode/update.log'
dt=`date '+%d/%m/%Y %H:%M:%S'`
latestrelease=$(curl --silent https://api.github.com/repos/BlockchainTechLLC/3dcoin/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
localrelease=$(3dcoin-cli -version | awk -F' ' '{print $NF}' | cut -d "-" -f1)
if [ -z "$latestrelease" ] || [ "$latestrelease" == "$localrelease" ]; then 
echo "[$dt]    ==============================================================" >> $LOGFILE
echo "[$dt]==> Info: There is no New Update latest release is $latestrelease" >> $LOGFILE
echo "[$dt]    ==============================================================" >> $LOGFILE
exit;
else
echo "[$dt]    ==============================================================" >> $LOGFILE
echo "[$dt]==> Info: Starting Update 3DCoin core to $latestrelease" >> $LOGFILE
echo "[$dt]    ==============================================================" >> $LOGFILE
echo "[$dt]==> Info: Install unzip" >> $LOGFILE
apt-get update
apt-get install unzip || { echo "[$dt]==> Error: When install unzip" >> $LOGFILE && exit;  }
cd ~
localfile=${localrelease//[Vv]/3dcoin-}
echo "[$dt]==> Info: Remove file $localfile" >> $LOGFILE
rm -rf $localfile
link="https://github.com/BlockchainTechLLC/3dcoin/archive/$latestrelease.zip"
echo "[$dt]==> Info: Download Last Update $link" >> $LOGFILE
wget $link  || { echo "[$dt]==> Error: When Download $link" >> $LOGFILE && exit;  }
echo "[$dt]==> Info: Unzip $latestrelease.zip" >> $LOGFILE
unzip $latestrelease.zip || { echo "[$dt]==> Error: When unzip $latestrelease.zip" >> $LOGFILE && exit;  }
file=${latestrelease//[Vv]/3dcoin-}
cd $file  || { echo "[$dt]==> Error: File $file not found" >> $LOGFILE && exit;  }
echo "[$dt]==> Info: Stop 3DCoin core $localrelease" >> $LOGFILE
3dcoin-cli stop || { echo "[$dt]==> Error: 3DCoin core not running but we continue installation" >> $LOGFILE;  }
sleep 10
echo "[$dt]==> Info: Start Compiling 3Dcoin core $latestrelease" >> $LOGFILE
./autogen.sh && ./configure --disable-tests --disable-gui-tests --without-gui && make install-strip || { echo "[$dt]==> Error: When Compiling 3Dcoin core" >> $LOGFILE && exit;  }
cd ~
echo "[$dt]==> Info: Remove $latestrelease.zip" >> $LOGFILE
rm $latestrelease.zip
echo "[$dt]==> Info: Remove $file" >> $LOGFILE
rm -rf $file
echo "[$dt]==> Info: Rebooting " >> $LOGFILE 
echo "[$dt]    ==============================================================" >> $LOGFILE
reboot
fi
