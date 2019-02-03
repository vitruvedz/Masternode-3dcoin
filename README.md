# Masternode-3dcoin

****************************************
### Bash Updater for masternode on Ubuntu 16.04 LTS x64 <This script must be run as root user!>
****************************************
 > **Version: 1.0.1:**
* Add Automatique update for scripts.
* Random time update for every ip.
* Clear debug log every 2 days.
* Add log file to UpdateNode shell.
* Using this shell to single update or Multi update.

 > **This shell script comes with 4 cronjobs:**

1. Automatique update scripts: [Check-scripts.sh](https://github.com/vitruvedz/Masternode-3dcoin/blob/master/Masternode/Check-scripts.sh)
2. Make sure the daemon is never stuck: [daemon_check.sh](https://github.com/vitruvedz/Masternode-3dcoin/blob/master/Masternode/daemon_check.sh)
3. Clear the log file: [clearlog.sh](https://github.com/vitruvedz/Masternode-3dcoin/blob/master/Masternode/clearlog.sh)
4. Automatique Update 3dcoin Core: [UpdateNode.sh](https://github.com/vitruvedz/Masternode-3dcoin/blob/master/Masternode/UpdateNode.sh)


> **How to use:**

Login to your vps as root, download the Update.sh file and then run it:

```
curl -O https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Update.sh > Update.sh
bash Update.sh
```

> **List of options:**

1. **Update Masternode & Auto-update script**
2. **Update only Auto-update script**
3. **Exit**

#### 1. Update Masternode & Auto-update script:
-----------------------------------------------------------------
This option make update 3dcoin core & script update in your vps & always you can use a single update or multi update: 

 > ##### 1.1-Update Single Masternode:
  
    This option update only local vps where you run this shell.
    
 > ##### 1.2- Update Multi Masternode
  
    This option update multi vps's and with 2 options to:
    
       1.2.1. Use Same SSH Port and Password for all vps's:
      
             Enter your vps ip's: (Exemple: 111.111.111.111-222.222.222.222-... )
             
             SSH port: (Exemple: 22 )
             
             password: (Exemple: Des53G2v3P )
             
       1.2.2. Not Same SSH Port and Password for all vps's:
      
             Eter your vps's data: 'Host:Password:SSHPort' ( Exemple: 111.111.111.111:ERdX5h64dSer:22-222.222.222.222:Wz65D232Fty:165-... )
             
#### 2. Update only Auto-update script:
-------------------------------------------------------------
This option make update only scripts in your vps & always you can use a single update or multi update: 

 > ##### 2.1-Update Single Masternode:
  
    This option update only local vps where you run this shell.
    
 > ##### 2.2- Update Multi Masternode
  
    This option update multi vps's and with 2 options to:
    
      2.2.1. Use Same SSH Port and Password for all vps's:
      
             Enter your vps ip's: (Exemple: 111.111.111.111-222.222.222.222-... )
             
             SSH port: (Exemple: 22 )
             
             password: (Exemple: Des53G2v3P )
             
      2.2.2. Not Same SSH Port and Password for all vps's:
      
             Eter your vps's data: 'Host:Password:SSHPort' ( Exemple: 111.111.111.111:ERdX5h64dSer:22-222.222.222.222:Wz65D232Fty:165-... )
             
#### 3. Exit:
-------------------------------------------------------------   
This option to close Shell script. 



****************************************
### Bash Checker for Masternodes on Ubuntu 16.04 LTS x64 <This script must be run as root user!>
***************************************

```
curl -O https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/check-masternode.sh > check-masternode.sh
bash check-masternode.sh
```


