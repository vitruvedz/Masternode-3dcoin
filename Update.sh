#####################################################################################
#                           Update 3DCoin Core V 0.14 	                            #
#####################################################################################
RED='\033[0;97;41m'
STD='\033[0;0;39m'
GREEN='\e[1;97;42m'
BLUE='\e[1;97;44m'

show_menus() {
	clear
	echo ""	
	echo  -e "${BLUE} U P D A T E  3 D C O I N  M A S T E R N O D E ${STD}"
	echo ""
	echo "1. Update Masternode & Auto-update script"
	echo "2. Update only Auto-update script"
	echo "3. Exit"
	echo ""
    echo  -e "\e[1;97;41m Note!!: Update 3DCoin Core V 0.14 & Update for Auto-update   ${STD}"
	echo ""
}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 3] " choice
	case $choice in
	1) Update="Update Masternode & Auto-update"
	    echo ""
		echo  -e "${GREEN} Choose Type of Update                  ${STD}" 
        PS3='Please enter your choice: '
		options=("Update Single Masternode" "Update Multi Masternode")
		select opt in "${options[@]}"
		do
			case $opt in
				"Update Single Masternode")
					break
				;;
				"Update Multi Masternode")
					break
				;;
				*) echo invalid option;;
			esac
		done
		#### 3Dcoin Single Node installation
		if [ "$opt" == "Update Single Masternode" ]; then
			echo ""
			h=$(( RANDOM % 23 + 1 ));
			echo  -e "${BLUE} Start ${Update}                    ${STD}"
			rm -f /usr/local/bin/check.sh
			rm -f /usr/local/bin/update.sh
			rm -f /usr/local/bin/UpdateNode.sh
			rm -rf /usr/local/bin/Masternode
			echo ""
			cd ~
			apt-get update
			apt-get install unzip || { echo "Error: When install unzip" && exit;  }
			echo  -e "${GREEN} Get latest release                ${STD}"
			latestrelease=$(curl --silent https://api.github.com/repos/BlockchainTechLLC/3dcoin/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
			link="https://github.com/BlockchainTechLLC/3dcoin/archive/$latestrelease.zip"
			wget $link
			unzip $latestrelease.zip
			file=${latestrelease//[Vv]/3dcoin-}
			echo ""
			echo  -e "${GREEN} Stop Cron                         ${STD}" 
			sudo /etc/init.d/cron stop
			echo ""
			echo  -e "${GREEN} Stop 3Dcoin core                  ${STD}"
			3dcoin-cli stop || { echo "Error: 3DCoin core not running but we continue installation";  }
			sleep 10
			echo ""		
			echo  -e "${GREEN} Make install                      ${STD}"
			cd $file
			./autogen.sh && ./configure --disable-tests --disable-gui-tests --without-gui && make install-strip || { echo "Error: When Compiling 3Dcoin core" && exit && 3dcoind;  }
			sleep 10
			echo ""
			echo  -e "${GREEN} Update crontab                    ${STD}"
            cd ~
            cd /usr/local/bin
			mkdir Masternode
			cd Masternode
			wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/Check-scripts.sh
			wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/Update-scripts.sh
			wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/UpdateNode.sh
			wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/clearlog.sh
			wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/Version
            chmod 755 UpdateNode.sh
            chmod 755 Check-scripts.sh
            chmod 755 Update-scripts.sh
            chmod 755 clearlog.sh
            cd ~
            crontab -r
            line="@reboot /usr/local/bin/3dcoind
0 0 * * * /usr/local/bin/Masternode/Check-scripts.sh
0 $h * * * /usr/local/bin/Masternode/UpdateNode.sh
* * */2 * * /usr/local/bin/Masternode/clearlog.sh"
			echo "$line" | crontab -u root -
			echo "Crontab updated successfully"
			echo ""
			echo  -e "${GREEN} Start Cron                        ${STD}"
			sudo /etc/init.d/cron start
			echo ""		
			echo  -e "${GREEN} Update Finished,rebooting server  ${STD}" 
			cd ~
			rm $latestrelease.zip 
			rm -rf $file 
			reboot
			#### ---------------------------------------------------------- ####
		else
		#### 3Dcoin Multi Node updatw
			echo ""
			echo  -e "${BLUE} Start ${Update}                    ${STD}"
			echo ""
			
			read -p "Same SSH Port and Password for all vps's? (Y/N)" -n 1 -r
			echo ""   # (optional) move to a new line
			if [[ $REPLY =~ ^[Yy]$ ]]; then
			echo ""
			echo  -e "${GREEN} Enter Vps ip's                    ${STD}"
			echo ""			
			sleep 2
			echo  -e "Please enter your vps ip's: ${RED}(Exemple: 111.111.111.111-222.222.222.222-... ) ${STD}"
			
			unset ip
			while [ -z ${ip} ]; do
			read -p "IP HERE: " ip
			done

			unset sshport
			while [ -z ${sshport} ]; do
			read -p "SSH Port: " sshport
			done

			unset rootpass
			while [ -z ${rootpass} ]; do
			read -s -p "Password: " rootpass
			done
			echo ""
			
			vpsip=$(echo $ip | tr "-" " ")
			
			apt-get update
			yes | apt-get install sshpass
			for i in $vpsip
			do
			echo  -e "${GREEN} Connexion Vps ip $i               ${STD}"
			echo ""
		
        sshpass -p $rootpass ssh -p$sshport -o StrictHostKeyChecking=no root@$i '
		h=$(( RANDOM % 23 + 1 ));
        rm -f /usr/local/bin/check.sh
        rm -f /usr/local/bin/update.sh
        rm -f /usr/local/bin/UpdateNode.sh
		rm -rf /usr/local/bin/Masternode
		apt-get update
		apt-get install unzip || { echo "Error: When install unzip" && exit;  }
		cd ~
		echo "-----------------------------------------------------"
        echo  -e "${GREEN} Git checkout master               ${STD}"
        echo "-----------------------------------------------------"
        latestrelease=$(curl --silent https://api.github.com/repos/BlockchainTechLLC/3dcoin/releases/latest | grep '"'"\\$"\"tag_name"\\$"\":'"' | sed -E '"'s/.*"\\$"\"([^"\\$"\"]+)"\\$"\".*/\1/'"')
        link="https://github.com/BlockchainTechLLC/3dcoin/archive/$latestrelease.zip"
        wget $link
        unzip $latestrelease.zip
        file=${latestrelease//[Vv]/3dcoin-}
        echo ""
        echo "-----------------------------------------------------"
        echo  -e "${GREEN} Stop Cron                         ${STD}"
        echo "-----------------------------------------------------"
        sudo /etc/init.d/cron stop
        echo ""
        echo "-----------------------------------------------------"
        echo  -e "${GREEN} Stop 3Dcoin core                  ${STD}"
        echo "-----------------------------------------------------"
		3dcoin-cli stop || { echo "Error: 3DCoin core not running but we continue installation";  }
		sleep 10
        echo ""		
        echo "-----------------------------------------------------"
        echo  -e "${GREEN} Make install                      ${STD}"
        echo "-----------------------------------------------------"
        cd $file
		./autogen.sh && ./configure --disable-tests --disable-gui-tests --without-gui && make install-strip || { echo "Error: When Compiling 3Dcoin core" && exit && 3dcoind;  }
		sleep 10
        echo ""
        echo "-----------------------------------------------------"
        echo  -e "${GREEN} Update crontab                    ${STD}"
        echo "-----------------------------------------------------" 
        cd ~
        cd /usr/local/bin
		mkdir Masternode
		cd Masternode
		wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/Check-scripts.sh
		wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/Update-scripts.sh
		wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/UpdateNode.sh
		wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/clearlog.sh
		wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/Version
		chmod 755 UpdateNode.sh
        chmod 755 Check-scripts.sh
        chmod 755 Update-scripts.sh
        chmod 755 clearlog.sh
        cd ~
        crontab -r
        line="@reboot /usr/local/bin/3dcoind
0 0 * * * /usr/local/bin/Masternode/Check-scripts.sh
0 $h * * * /usr/local/bin/Masternode/UpdateNode.sh
* * */2 * * /usr/local/bin/Masternode/clearlog.sh"
        echo "$line" | crontab -u root -
        echo "Crontab updated successfully"
        echo "" 
        echo "-----------------------------------------------------"
	    echo  -e "${GREEN} Update Finished,rebooting server  ${STD}" 
        echo "-----------------------------------------------------"
		cd ~
        rm $latestrelease.zip
		rm -rf $file 
        reboot'
        done
		
	elif [[ $REPLY =~ ^[Nn]$ ]]; then
	sleep 2
	echo  -e "Please enter your vps's data: 'Host:Password:SSHPort' ${RED}( Exemple: 111.111.111.111:ERdX5h64dSer:22-222.222.222.222:Wz65D232Fty:165-... )${STD}"

	unset ip
	while [ -z ${ip} ]; do
	read -p "DATA HERE: " ip
	done

	apt-get update
	yes | apt-get install sshpass
			
	data=$(echo $ip | tr "-" " ")
	for i in $data
	do
	vpsdata=$(echo $i | tr ":" "\n")
	declare -a array=($vpsdata)
	host=${array[0]}
	pass=${array[1]}
	port=${array[2]}
	if [ -z "$pass" ] || [ -z "$port" ] || [ -z "$host" ]
	then
	echo -e "Please enter a correct vps's data ${RED}( Exemple: 111.111.111.111:ERdX5h64dSer:22 222.222.222.222:Wz65D232Fty:165 ... )${STD}"
	else
	
	sshpass -p $pass ssh -p$port -o StrictHostKeyChecking=no root@$host '
		h=$(( RANDOM % 23 + 1 ));
        rm -f /usr/local/bin/check.sh
        rm -f /usr/local/bin/update.sh
        rm -f /usr/local/bin/UpdateNode.sh
		rm -rf /usr/local/bin/Masternode
		apt-get update
		apt-get install unzip || { echo "Error: When install unzip" && exit;  }
		cd ~
		echo "-----------------------------------------------------"
        echo  -e "${GREEN} Git checkout master               ${STD}"
        echo "-----------------------------------------------------"
        latestrelease=$(curl --silent https://api.github.com/repos/BlockchainTechLLC/3dcoin/releases/latest | grep '"'"\\$"\"tag_name"\\$"\":'"' | sed -E '"'s/.*"\\$"\"([^"\\$"\"]+)"\\$"\".*/\1/'"')
        link="https://github.com/BlockchainTechLLC/3dcoin/archive/$latestrelease.zip"
        wget $link
        unzip $latestrelease.zip
        file=${latestrelease//[Vv]/3dcoin-}
        echo ""
        echo "-----------------------------------------------------"
        echo  -e "${GREEN} Stop Cron                         ${STD}"
        echo "-----------------------------------------------------"
        sudo /etc/init.d/cron stop
        echo ""
        echo "-----------------------------------------------------"
        echo  -e "${GREEN} Stop 3Dcoin core                  ${STD}"
        echo "-----------------------------------------------------"
		3dcoin-cli stop || { echo "Error: 3DCoin core not running but we continue installation";  }
		sleep 10
        echo ""		
        echo "-----------------------------------------------------"
        echo  -e "${GREEN} Make install                      ${STD}"
        echo "-----------------------------------------------------"
        cd $file
		./autogen.sh && ./configure --disable-tests --disable-gui-tests --without-gui && make install-strip || { echo "Error: When Compiling 3Dcoin core" && exit && 3dcoind;  }
		sleep 10
        echo ""
        echo "-----------------------------------------------------"
        echo  -e "${GREEN} Update crontab                    ${STD}"
        echo "-----------------------------------------------------" 
        cd ~
        cd /usr/local/bin
		mkdir Masternode
		cd Masternode
		wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/Check-scripts.sh
		wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/Update-scripts.sh
		wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/UpdateNode.sh
		wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/clearlog.sh
		wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/Version
		chmod 755 UpdateNode.sh
        chmod 755 Check-scripts.sh
        chmod 755 Update-scripts.sh
        chmod 755 clearlog.sh
        cd ~
        crontab -r
        line="@reboot /usr/local/bin/3dcoind
0 0 * * * /usr/local/bin/Masternode/Check-scripts.sh
0 $h * * * /usr/local/bin/Masternode/UpdateNode.sh
* * */2 * * /usr/local/bin/Masternode/clearlog.sh"
        echo "$line" | crontab -u root -
        echo "Crontab updated successfully"
        echo "" 
        echo "-----------------------------------------------------"
	    echo  -e "${GREEN} Update Finished,rebooting server  ${STD}" 
        echo "-----------------------------------------------------"
		cd ~
        rm $latestrelease.zip
		rm -rf $file 
        reboot'
		fi
		done
		else
		exit;
		fi
		
		fi
        exit 0;;
		
        2) Update="Update only Auto-update script"
	    echo "" 
		echo  -e "${GREEN} Choose Type of Update                  ${STD}" 
        PS3='Please enter your choice: '
		options=("Update Single Masternode" "Update Multi Masternode")
		select opt in "${options[@]}"
		do
			case $opt in
				"Update Single Masternode")
					break
				;;
				"Update Multi Masternode")
					break
				;;
				*) echo invalid option;;
			esac
		done
		#### 3Dcoin Single Node installation
		if [ "$opt" == "Update Single Masternode" ]; then
			echo ""
            h=$(( RANDOM % 23 + 1 ));
			echo  -e "${BLUE} Start ${Update}                    ${STD}"
			rm -f /usr/local/bin/check.sh
			rm -f /usr/local/bin/update.sh
			rm -f /usr/local/bin/UpdateNode.sh
			rm -rf /usr/local/bin/Masternode
			echo ""
			cd ~
			echo  -e "${GREEN} Stop Cron                         ${STD}" 
			sudo /etc/init.d/cron stop
			echo ""
			echo  -e "${GREEN} Update crontab                    ${STD}"
			cd ~
			cd /usr/local/bin
			mkdir Masternode
			cd Masternode
			wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/Check-scripts.sh
			wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/Update-scripts.sh
			wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/UpdateNode.sh
			wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/clearlog.sh
			wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/Version
			chmod 755 UpdateNode.sh
			chmod 755 Check-scripts.sh
			chmod 755 Update-scripts.sh
			chmod 755 clearlog.sh
			cd ~
            crontab -r
        line="@reboot /usr/local/bin/3dcoind
0 0 * * * /usr/local/bin/Masternode/Check-scripts.sh
0 $h * * * /usr/local/bin/Masternode/UpdateNode.sh
* * */2 * * /usr/local/bin/Masternode/clearlog.sh"
			echo "$line" | crontab -u root -
			echo "Crontab updated successfully"
			echo ""
			echo  -e "${GREEN} Start Cron                        ${STD}"
			sudo /etc/init.d/cron start
			echo ""		
			echo  -e "${GREEN} Update Finished                   ${STD}" 
			echo ""
			#### ---------------------------------------------------------- ####
		else
		
		
        echo ""
        echo  -e "${BLUE} Start ${Update}                    ${STD}"
        echo ""
		
        echo  -e "${GREEN} Enter Vps ip's                    ${STD}"
		echo ""
		echo  -e "Please enter your vps ip's: ${RED}(Exemple: 111.111.111.111 222.222.222.222 ) ${STD}"
		unset ip
        while [ -z ${ip} ]; do
        read -p "IP HERE: " ip
        done
		apt-get update
		yes | apt-get install sshpass
        for i in $ip
        do
        h=$(( RANDOM % 23 + 1 ));
        echo  -e "${GREEN} Connexion Vps ip $i               ${STD}"
        echo ""
		unset rootpass
        while [ -z ${rootpass} ]; do
        read -s -p "Please Enter Password Root $i: " rootpass
        done
        echo  -e "${STD}"
        echo ""
        echo  -e "${GREEN} SSH port Vps ip $i               ${STD}"
        echo ""
		unset sshport
        while [ -z ${sshport} ]; do
        read -s -p "Please Enter ssh port $i: " sshport
        done
		
        sshpass -p $rootpass ssh -p$sshport -o StrictHostKeyChecking=no root@$i '
			rm -f /usr/local/bin/check.sh
			rm -f /usr/local/bin/update.sh
			rm -f /usr/local/bin/UpdateNode.sh
			rm -rf /usr/local/bin/Masternode
			cd ~
			echo ""
			echo "-----------------------------------------------------"
			echo  -e "${GREEN} Stop Cron                         ${STD}"
			echo "-----------------------------------------------------"
			sudo /etc/init.d/cron stop
			echo ""
			echo "-----------------------------------------------------"
			echo  -e "${GREEN} Update crontab                    ${STD}"
			echo "-----------------------------------------------------" 
			cd ~
			cd /usr/local/bin
			mkdir Masternode
			cd Masternode
			wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/Check-scripts.sh
			wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/Update-scripts.sh
			wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/UpdateNode.sh
			wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/clearlog.sh
			wget https://raw.githubusercontent.com/vitruvedz/Masternode-3dcoin/master/Masternode/Version
			chmod 755 UpdateNode.sh
			chmod 755 Check-scripts.sh
			chmod 755 Update-scripts.sh
			chmod 755 clearlog.sh
			cd ~
			crontab -r
        line="@reboot /usr/local/bin/3dcoind
0 0 * * * /usr/local/bin/Masternode/Check-scripts.sh
0 $h * * * /usr/local/bin/Masternode/UpdateNode.sh
* * */2 * * /usr/local/bin/Masternode/clearlog.sh"
			echo "$line" | crontab -u root -
			echo "Crontab updated successfully"
			sudo /etc/init.d/cron start
			echo "" 
			echo "-----------------------------------------------------"
			echo  -e "${GREEN} Update Finished                   ${STD}" 
			echo "-----------------------------------------------------"
			echo ""'
        done
		fi
        exit 0;;
		
	
		3) exit 0;;
		*) echo -e "${RED} Please choose the right choice... ${STD}" && sleep 2  
	    esac
}

while true
do
show_menus
read_options
done