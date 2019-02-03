#!/bin/bash
HOME=/root
LOGNAME=root
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
LANG=en_US.UTF-8
SHELL=/bin/sh
PWD=/root
3dcoin-cli getblockcount > /usr/local/bin/Masternode/blockcount
previousBlock=$(cat /usr/local/bin/Masternode/blockcount)
currentBlock=$(3dcoin-cli getblockcount)

if [ "$previousBlock" == "$currentBlock" ]; then
  3dcoin-cli stop
  sleep 10
	rm -f /root/.3dcoin/banlist.dat
	rm -f /root/.3dcoin/mncache.dat
	rm -f /root/.3dcoin/mnpayments.dat
	rm -f /root/.3dcoin/netfulfilled.dat
	rm -f /root/.3dcoin/3dcoin.pid
	rm -f /root/.3dcoin/governance.dat
	rm -f /root/.3dcoin/peers.dat
	rm -rf /root/.3dcoin/blocks
	rm -rf /root/.3dcoin/chainstate
  3dcoind
fi