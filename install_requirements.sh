#!/bin/bash

# color define
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'
curd="$PWD"

usage(){
	 echo -e "${GREEN}\nUsage:${NC}"
         echo -e "\t $0  /path/to/instalation/directory 'any env paramters to use with the script'"
         echo -e "\t $0  /path/to/instalation/directory proxy=http://127.0.0.1:8080"
}

#Verify if script run as root
if [ $(id -u)  -ne 0 ]; then 
        echo  -e "${YELLOW}This script must be run as root, use sudo "$0" instead\n" 1>&2
        exit 1
fi

# verify the command 
if [ ${#} -lt 1 ]; then
   echo -e "${RED}\nERROR: This script take at least one argument !!${NC}\n"
    . ~/.bashrc
    usage 
    exit 1
elif [ -d "$1" ]; then
    VALUE="$1"
    if expr "$VALUE" : '/.*/$' >/dev/null || [ ${#VALUE} = 1 ]; then
        rootDir=$VALUE
    else
        rootDir="$VALUE/"
    fi 
    if [ ! -z "$2" ]; then
       env_cmd="export $2"
    fi
else
    echo -e "${RED}\n[ERROR]: the path \"$1\" is not a directory !!${NC}\n"
    usage 
    exit 1
fi

execute_as_sudo_user(){
  cur_cmd="$1"
  # if script runs with sudo
  if [ "$SUDO_USER" != "" ]; then
   	 # execute commmand as the sudo user 
     if [ ! -z "$env_cmd" ]; then
        su -c "$env_cmd && $cur_cmd" $SUDO_USER
     else
        su -c "$cur_cmd" $SUDO_USER
     fi
  else
    $cur_cmd
  fi
}

command_exists(){
  if ! cmd="$(type -p "$1")" || [[ -z $cmd ]]; then
    return 1
  else
  	return 0
  fi
}

# set env vars if exists
if [ ! -z "$env_cmd" ]; then
  $env_cmd
fi

#Update apt sources list:
apt update

#Read env vars
if [ -f ~/.zshrc ]; then
   . ~/.zshrc
elif [ -f ~/.bashrc ]; then
   . ~/.bashrc
fi

# fct install packages
install_aval_package() {
for i in $1
  do 
     if [ -z "$(apt-cache madison $i 2>/dev/null)" ]; then
       echo " > Package $i not available on repo."
     else
       echo " > Add package $i to the install list"
     packages="$packages $i"
     fi
 done
 echo "$packages" #you could comment this.
 apt-get -y install $packages
}

# install curl
install_aval_package "curl"

# install python-pip, if dosent exist install it manually 
if [ -z "$(apt-cache madison python-pip  2>/dev/null)" ] && [ -z "$(pip2 --version 2> /dev/null)" ] ; then
       echo " > Package python-pip  not available on repo. Install it manually"
       add-apt-repository universe
       apt update 
       apt install python2
       curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output /tmp/get-pip.py
       python2 /tmp/get-pip.py
fi
       
# install pip, alien 
install_aval_package  "python3-venv python3-pip libaio1 python3-dev alien"
pip install setuptools

# Install some python lib
apt-get install -y python3-scapy && \
pip3 install  colorlog termcolor pycrypto passlib && \
pip3 install argcomplete && activate-global-python-argcomplete && \
pip3 install pyinstaller

# Install keepnote
command_exists "keepnote"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInstall keepnote${NC}"
	curl -o /tmp/python-gtk.deb http://archive.ubuntu.com/ubuntu/pool/universe/p/pygtk/python-gtk2_2.24.0-5.1ubuntu2_amd64.deb  
	apt-get install -y /tmp/python-gtk.deb 
	curl -o /tmp/python-glad.deb http://archive.ubuntu.com/ubuntu/pool/universe/p/pygtk/python-glade2_2.24.0-5.1ubuntu2_amd64.deb 
        apt-get install -y /tmp/python-glad.deb
	apt-get install -y  libgtk2.0-dev libsqlite3-0 
	curl -o /tmp/keepnote.deb http://archive.ubuntu.com/ubuntu/pool/universe/k/keepnote/keepnote_0.7.8-1.1_all.deb
	apt-get install -y /tmp/keepnote.deb
fi

# Install nmap
command_exists "nmap"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInstall nmap${NC}"
	apt-get install -y nmap
	execute_as_sudo_user "git clone https://github.com/vulnersCom/nmap-vulners.git ${rootDir}nmap-vulners"
	cp ${rootDir}nmap-vulners/vulners.nse /usr/share/nmap/scripts/ && \
	cd /usr/share/nmap/scripts/ && nmap --script-updatedb
fi

## Install nmap scripts
nmap_script="/usr/share/nmap/scripts/"
if [  -d "$nmap_script" ]; then
  if [ ! -f "${nmap_script}vulners.nse" ]; then
    git clone https://github.com/vulnersCom/nmap-vulners.git /tmp/nmap-vulners
    cp -r /tmp/nmap-vulners/*.nse ${nmap_script}/
    nmap --script-updatedb
  fi
else
  echo -e "${RED}\n[ERROR]: the path \"$nmap_script\" is not found, find the nmap scripts emplacement !!${NC}\n"
fi

#Install curl
command_exists "curl"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInstall curl${NC}"
	apt-get install -y curl
fi

#Install smbclient
command_exists "smbclient"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInstall smbclient${NC}"
	apt-get install -y smbclient
fi


#Install snmpwalk
command_exists "snmpwalk"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInstall snmpwalk${NC}"
	apt-get install -y snmp libsnmp-dev && \
	apt-get install -y snmp-mibs-downloader && \
	sed  -i "s/^mibs :$/#mibs :/g" /etc/snmp/snmp.conf
fi

#Install requirements
apt-get install -y git gcc make libpcap-dev

#Install masscan
command_exists "masscan"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInstall masscan${NC}"
	execute_as_sudo_user "git clone https://github.com/robertdavidgraham/masscan ${rootDir}masscan" 
	execute_as_sudo_user "cd ${rootDir}masscan && make -j"
	cd ${rootDir}masscan
	make install
fi

#Install sslyze
command_exists "sslyze"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInstall sslyze${NC}"
        pip install --upgrade setuptools
        pip install sslyze
fi

#Install ssltest.py
command_exists "ssltest.py"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInstall ssltest${NC}"
	execute_as_sudo_user "git clone https://github.com/Lekensteyn/pacemaker.git ${rootDir}pacemaker" 
	ln -s  ${rootDir}pacemaker/ssltest.py /usr/bin/ssltest.py
fi

#Install joomscan
command_exists "joomscan"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInstall joomscan${NC}"
	execute_as_sudo_user "git clone https://github.com/rezasp/joomscan.git ${rootDir}joomscan" 
	ln -s  ${rootDir}joomscan/joomscan.pl /usr/local/bin/joomscan
fi

#Install wpscan
command_exists "wpscan"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInstall wpscan${NC}"
	apt install -y ruby && \
	apt install -y build-essential libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev  libgmp-dev zlib1g-dev && \
	gem install  wpscan
fi

#Install droopescan
command_exists "droopescan"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInstall droopescan${NC}"
	pip install droopescan
fi

#Install gobuster
command_exists "gobuster"
if [ $? -ne 0 ]; then
    echo -e "${GREEN}\nInstall gobuster${NC}"
    command_exists "go"
    if [ $? -ne 0 ]; then
      curl -SL  https://golang.org/dl/go1.16.linux-amd64.tar.gz -o /tmp/go1.16.linux-amd64.tar.gz && \
      tar -C /usr/local -xzf /tmp/go1.16.linux-amd64.tar.gz && \
      rm -rf /tmp/go1.16.linux-amd64.tar.gz && \
      execute_as_sudo_user 'echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile' 
    fi  
    execute_as_sudo_user "curl -SL https://github.com/OJ/gobuster/archive/v3.0.1.tar.gz -o /tmp/v3.0.1.tar.gz && tar -C ${rootDir} -xzf /tmp/v3.0.1.tar.gz && rm -rf /tmp/v3.0.1.tar.gz && mv ${rootDir}gobuster-3.0.1 ${rootDir}gobuster && cd ${rootDir}gobuster && export PATH='$PATH:/usr/local/go/bin' && go get && go build"
    ln -s  ${rootDir}gobuster/gobuster /usr/bin/gobuster
fi

#Install smbmap
command_exists "smbmap"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInstall smbmap${NC}"
    execute_as_sudo_user "git clone https://github.com/ShawnDEvans/smbmap.git ${rootDir}smbmap" 
    cd ${rootDir}smbmap && python3 -m pip install -r requirements.txt
	ln -s  ${rootDir}smbmap/smbmap.py /usr/local/bin/smbmap
fi

#Install enum4linux
command_exists "enum4linux"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInstall enum4linux${NC}"
    execute_as_sudo_user "git clone https://github.com/CiscoCXSecurity/enum4linux.git ${rootDir}enum4linux" 
	ln -s  ${rootDir}enum4linux/enum4linux.pl /usr/local/bin/enum4linux
fi

#Install hydra
command_exists "hydra"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInstall hydra${NC}"
	# Install depenciesrootDir
	apt-get install -y libssl-dev libssh-dev libidn11-dev libpcre3-dev libgtk2.0-dev libmysqlclient-dev libpq-dev libsvn-dev && \
    apt-get install -y  firebird-dev libmemcached-dev libgpg-error-dev libgcrypt11-dev libgcrypt20-dev
    execute_as_sudo_user "git clone https://github.com/vanhauser-thc/thc-hydra.git ${rootDir}thc-hydra" 
    execute_as_sudo_user "cd ${rootDir}thc-hydra  && ./configure && make"
    cd ${rootDir}thc-hydra && make install
fi

#Install Impacket
command_exists "lookupsid.py"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInstall Impacket${NC}"
    execute_as_sudo_user "git clone https://github.com/SecureAuthCorp/impacket.git ${rootDir}impacket" 
    cd  ${rootDir}impacket && pip3 install .
fi

#Install Redis
command_exists "redis-exploit.py"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInstall redis-exploit.py${NC}"
    execute_as_sudo_user "git clone https://github.com/roughiz/Redis-Server-Exploit-Enum.git ${rootDir}Redis-Server-Exploit-Enum && chmod +x ${rootDir}Redis-Server-Exploit-Enum/redis-exploit.py && cd ${rootDir}Redis-Server-Exploit-Enum && pip install -r requirements.txt" 
    ln -s  ${rootDir}Redis-Server-Exploit-Enum/redis-exploit.py /usr/local/bin/redis-exploit.py
fi

#Install wfuzz
command_exists "wfuzz"
if [ $? -ne 0 ]; then
    echo -e "${GREEN}\nInstall wfuzz${NC}"
    execute_as_sudo_user "curl -SL  https://github.com/xmendez/wfuzz/archive/v3.1.0.tar.gz -o /tmp/v3.1.0.tar.gz && tar -C ${rootDir} -xzf /tmp/v3.1.0.tar.gz && rm -rf /tmp/v3.1.0.tar.gz && mv ${rootDir}wfuzz-3.1.0 ${rootDir}wfuzz"
    cd ${rootDir}wfuzz && pip3 install .
fi

#Install odat.py
command_exists "odat.py"
if [ $? -ne 0 ]; then
    echo -e "${GREEN}\nInstall odat.py${NC}"
    destination="/usr/share/odat"
    if [ -d "$destination" ];then rm -rf $destination;fi
    git clone https://github.com/quentinhardy/odat.git $destination && \
    cd $curd && cp -r wordlist/oracle/accounts_multiple_lower.txt wordlist/oracle/heavy*txt ${destination}/accounts/ && \
    cp wordlist/oracle/sids.txt ${destination}/ && \
    cd $destination && \
    git submodule init && \
    git submodule update && \
    mkdir /tmp/odat_rpm  
    if [ ! $(dpkg -l | grep -i oracle-instantclient | wc -l) -ge 3 ];then
      curl -SL https://download.oracle.com/otn_software/linux/instantclient/211000/oracle-instantclient-basic-21.1.0.0.0-1.x86_64.rpm -o /tmp/odat_rpm/oracle-instantclient-basic.rpm && \
      curl -SL https://download.oracle.com/otn_software/linux/instantclient/211000/oracle-instantclient-tools-21.1.0.0.0-1.x86_64.rpm -o /tmp/odat_rpm/oracle-instantclient-tools.rpm && \
      curl -SL https://download.oracle.com/otn_software/linux/instantclient/211000/oracle-instantclient-devel-21.1.0.0.0-1.x86_64.rpm -o /tmp/odat_rpm/oracle-instantclient-devel.rpm && \
      cd /tmp/odat_rpm/ && alien --to-deb *.rpm && \
      dpkg -i *.deb 
    fi
   version=$(dir /usr/lib/oracle/) && \
   echo "export ORACLE_HOME=/usr/lib/oracle/${version}/client64/" >> /etc/profile && \
   echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$ORACLE_HOME/lib" >> /etc/profile  && \
   echo "export PATH=\${ORACLE_HOME}bin:\$PATH" >> /etc/profile  && \
   echo "/usr/lib/oracle/${version}/client64/lib/" >  /etc/ld.so.conf.d/oracle.conf && \
   ldconfig && source /etc/profile && pip3 install cx_Oracle && pip3 install python-libnmap && \
   ln -s ${destination}/odat.py /usr/bin/odat.py && \
   sed -i "s|#!/usr/bin/python|#!/usr/bin/python3|g" ${destination}/odat.py
   odat.py -h
   rm -rf /tmp/odat_rpm
fi

