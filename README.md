# Masternode-3dcoin

****************************************
**Bash Updater for masternode on Ubuntu 16.04 LTS x64**
****************************************
**Version: 1.0.1:**

* Add Automatique update for scripts.
* Random time update for every ip.
* Clear debug log every 2 days.
* Add log file to UpdateNode shell.
* Using this shell to single update or Multi update.
****************************************

This shell script comes with 4 cronjobs:
1. Automatique update scripts: Check-scripts.sh
2. Make sure the daemon is never stuck: daemon_check.sh
3. Clear the log file every other day: clearlog.sh
4. Automatique Update 3dcoin Core: UpdateNode.sh

**Warning: This script must be run as root user!**

**How to use:**

```
curl -O https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Update.sh > Update.sh
bash Update.sh
```


****************************************
Check 3DCoin masternode
****************************************

```
curl -O https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/check-masternode.sh > check-masternode.sh
bash check-masternode.sh
```


