#!/bin/sh

# color define
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'

usage(){
	 echo -e "${GREEN}\nUsage:${NC}"
     echo -e "\t $0  /path/to/instalation/directory "
}

#Verify if script run as root
if [ $(id -u)  -ne 0 ]; then 
        echo  -e "${YELLOW}This script must be run as root, use sudo "$0" instead\n" 1>&2
        exit 1
fi

# verify the command 
if [ ${#} -ne 1 ]; then
   echo -e "${RED}\n[ERROR]: This script take one argument !!${NC}\n"
    usage 
    exit 1
elif [ -d "$1" ]; then
    VALUE="$1"
    if expr "$VALUE" : '/.*/$' >/dev/null || [ ${#VALUE} = 1 ]; then
        rootDir=$VALUE
    else
        rootDir="$VALUE/"
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
     su -c "$cur_cmd" $SUDO_USER 
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

#Update apt sources list:
apt update

# Install keepnote
command_exists "keepnote"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInsall keepnote${NC}"
	apt-get install -y  python python-gtk2 python-glade2 libgtk2.0-dev libsqlite3-0 && \
	apt-get install -y keepnote
fi

# Install nmap
command_exists "nmap"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInsall nmap${NC}"
	apt-get install -y nmap
	execute_as_sudo_user "git clone https://github.com/vulnersCom/nmap-vulners.git ${rootDir}nmap-vulners"
	cp ${rootDir}nmap-vulners/vulners.nse /usr/share/nmap/scripts/ && \
	cd /usr/share/nmap/scripts/ && nmap --script-updatedb
fi

#Install curl
command_exists "curl"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInsall curl${NC}"
	apt-get install -y curl
fi

#Install smbclient
command_exists "smbclient"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInsall smbclient${NC}"
	apt-get install -y smbclient
fi


#Install snmpwalk
command_exists "snmpwalk"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInsall snmpwalk${NC}"
	apt-get install -y snmp libsnmp-dev && \
	apt-get install -y snmp-mibs-downloader && \
	sed  -i "s/^mibs :$/#mibs :/g" /etc/snmp/snmp.conf
fi

#Install requirements
apt-get install git gcc make libpcap-dev

#Install masscan
command_exists "masscan"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInsall masscan${NC}"
	execute_as_sudo_user "git clone https://github.com/robertdavidgraham/masscan ${rootDir}masscan" 
	execute_as_sudo_user "cd ${rootDir}masscan && make -j"
	cd ${rootDir}masscan
	make install
fi


# install pip
apt install -y python-pip python3-venv python3-pip && \
pip install -y setuptools

#Install sslyze
command_exists "sslyze"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInsall sslyze${NC}"
	execute_as_sudo_user "git clone https://github.com/nabla-c0d3/sslyze.git ${rootDir}sslyze" 
	cd ${rootDir}sslyze
	pip install .
fi

#Install ssltest.py
command_exists "ssltest.py"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInsall ssltest${NC}"
	execute_as_sudo_user "git clone https://github.com/Lekensteyn/pacemaker.git ${rootDir}pacemaker" 
	ln -s  ${rootDir}pacemaker/ssltest.py /usr/bin/ssltest.py
fi

#Install joomscan
command_exists "joomscan"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInsall joomscan${NC}"
	execute_as_sudo_user "git clone https://github.com/rezasp/joomscan.git ${rootDir}joomscan" 
	ln -s  ${rootDir}joomscan/joomscan.pl /usr/local/bin/joomscan
fi

#Install wpscan
command_exists "wpscan"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInsall wpscan${NC}"
	apt install -y ruby && \
	apt install -y build-essential libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev  libgmp-dev zlib1g-dev && \
	gem install -y wpscan
fi

#Install droopescan
command_exists "droopescan"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInsall droopescan${NC}"
	apt-get install -y python-pip && \
	pip install droopescan
fi

#Install gobuster
command_exists "gobuster"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInsall gobuster${NC}"
	command_exists "go"
    if [ $? -ne 0 ]; then
      curl -SL  https://golang.org/dl/go1.15.4.linux-amd64.tar.gz -o /tmp/go1.15.4.linux-amd64.tar.gz && \
      tar -C /usr/local -xzf /tmp/go1.15.4.linux-amd64.tar.gz && \
      rm -rf /tmp/go1.15.4.linux-amd64.tar.gz && \
      execute_as_sudo_user 'echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile' 
      
    fi  
    execute_as_sudo_user "git clone https://github.com/OJ/gobuster.git ${rootDir}gobuster && cd ${rootDir}gobuster && source ~/.profile && go get && go build"
    ln -s  ${rootDir}gobuster/gobuster /usr/bin/gobuster
fi

#Install smbmap
command_exists "smbmap"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInsall smbmap${NC}"
    execute_as_sudo_user "git clone https://github.com/ShawnDEvans/smbmap.git ${rootDir}smbmap" 
    cd ${rootDir}smbmap && python3 -m pip install -r requirements.txt
	ln -s  ${rootDir}smbmap/smbmap.py /usr/local/bin/smbmap
fi

#Install enum4inux
command_exists "enum4inux"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInsall enum4inux${NC}"
    execute_as_sudo_user "git clone https://github.com/CiscoCXSecurity/enum4linux.git ${rootDir}enum4linux" 
	ln -s  ${rootDir}enum4linux/enum4linux.pl /usr/local/bin/enum4linux
fi

#Install hydra
command_exists "hydra"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInsall hydra${NC}"
	# Install depencies
	apt-get install -y libssl-dev libssh-dev libidn11-dev libpcre3-dev libgtk2.0-dev libmysqlclient-dev libpq-dev libsvn-dev && \
    apt-get install -y  firebird-dev libmemcached-dev libgpg-error-dev libgcrypt11-dev libgcrypt20-dev
    execute_as_sudo_user "git clone https://github.com/vanhauser-thc/thc-hydra.git ${rootDir}thc-hydra" 
    execute_as_sudo_user "cd ${rootDir}thc-hydra  && ./configure && make"
    cd ${rootDir}thc-hydra && make install
fi

#Install Impacket
command_exists "lookupsid.py"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInsall Impacket${NC}"
    execute_as_sudo_user "git clone https://github.com/SecureAuthCorp/impacket.git ${rootDir}impacket" 
    cd  ${rootDir}impacket && pip3 install .
fi

#Install Redis
command_exists "redis-exploit.py"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInsall redis-exploit.py${NC}"
    execute_as_sudo_user "git clone https://github.com/roughiz/Redis-Server-Exploit-Enum.git ${rootDir}Redis-Server-Exploit-Enum" 
    ln -s  ${rootDir}Redis-Server-Exploit-Enum/redis-exploit.py /usr/local/bin/redis-exploit.py
fi

#Install wfuzz
command_exists "redis-exploit.py"
if [ $? -ne 0 ]; then
   pip install wfuzz
fi