#!/bin/bash
HOME=/root
LOGNAME=root
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
LANG=en_US.UTF-8
SHELL=/bin/sh
PWD=/root
cd /usr/local/bin/Masternode
rm -f Version
rm -f UpdateNode.sh
rm -f clearlog.sh
wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/UpdateNode.sh
wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/clearlog.sh
wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/Version
chmod 755 UpdateNode.sh
chmod 755 clearlog.sh

