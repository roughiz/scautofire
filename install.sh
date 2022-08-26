#!/bin/bash

# color define
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'
curd="$PWD"
VENV="$PWD/.env"

PROXY=""
PIP_INSTALL="$VENV/bin/pip install --upgrade " 
# Usage function
function usage(){
    echo "Usage: ${0} -d /path/to/install/folder -p http://127.0.0.1:8080"
    echo
    echo 'SPECIFICATION:'
    echo '    -d/--destination: The destination folder path. where to install packages(required)'
    echo "    -p/--proxy: Proxy to use if there's any"
    echo
    echo '    -h/--help: Print this help summary page'
    echo
    echo 'EXAMPLES:'
    echo "    sh ${0}  -d /home/user/installer "
    echo "    sh ${0}  -d /home/user/installer -p http://127.0.0.1:8080"

}


# Main function
function main(){
    if [ -z "$*" ]; then
        usage
        exit 1
    fi

    while [ "$1" != "" ]; do
        local PARAM=$1
        shift
        local VALUE=$1
        case $PARAM in
            -d | --destination) 
               if [ -d "$VALUE" ]; then
                 if expr "$VALUE" : '/.*/$' >/dev/null || [ ${#VALUE} = 1 ]; then rootDir=$VALUE; else rootDir="$VALUE/"; fi 
               else
                 echo -e "${RED}\n[ERROR]: the path \"$1\" is not a directory !!${NC}\n"
                 usage
                 exit 1
               fi
               ;;
            -p | --proxy) PROXY=$VALUE
                        ;;
            -h | --help) usage
                        exit
                        ;;
            *) echo "Unknown parameter: $PARAM"
            usage
            exit 1
            ;;
        esac
        shift
    done

}
# Run the main fct
main $*

command_exists(){
  if ! cmd="$(type -p "$1")" || [[ -z $cmd ]]; then
    return 1
  else
  	return 0
  fi
}

#Update apt sources list:
sudo apt update

# install pip, alien 
# Install apt dependencies
sudo apt install -y python3-venv python3-dev python3-pip python-pip execstack nmap devscripts alien libaio1 python3-scapy \
		python python-gtk2 python-glade2 libgtk2.0-dev libsqlite3-0 keepnote \
                curl  smbclient snmp libsnmp-dev snmp-mibs-downloader git gcc make libpcap-dev \
		libssl-dev libssh-dev libidn11-dev libpcre3-dev libgtk2.0-dev default-libmysqlclient-dev libpq-dev libsvn-dev \
		firebird-dev libmemcached-dev libgpg-error-dev libgcrypt20 libgcrypt20-dev \
		ruby build-essential libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev  libgmp-dev zlib1g-dev 

# set proxy  if exists
if [ ! -z "$PROXY" ]; then
  export http_proxy=$PROXY && export https_proxy=$PROXY
  SUDO="sudo http_proxy=$PROXY https_proxy=$PROXY "
else
  SUDO="sudo "
fi

echo -e "${GREEN}\nInstall requirements ${NC}"

# Update gem
$SUDO  gem update --system      
       
# Delete current venv and create a new
if [ -d "$VENV" ]; then rm -rf $VENV; fi

# Create environment
cd ${curd}
python3 -m venv --copies $VENV
source $VENV/bin/activate
 
# install python pack requeirements
$PIP_INSTALL pip
$PIP_INSTALL pip-tools setuptools wheel


# Install some python lib
$PIP_INSTALL  colorlog termcolor pycrypto passlib 
$PIP_INSTALL argcomplete && $VENV/bin/activate-global-python-argcomplete 
$PIP_INSTALL pyinstaller

## Install nmap scripts
nmap_script="/usr/share/nmap/scripts/"
if [  -d "$nmap_script" ]; then
  if [ ! -f "${nmap_script}vulners.nse" ]; then
    git clone https://github.com/vulnersCom/nmap-vulners.git /tmp/nmap-vulners
    sudo cp -r /tmp/nmap-vulners/*.nse ${nmap_script}/
    sudo nmap --script-updatedb
  fi
else
  echo -e "${RED}\n[ERROR]: the path \"$nmap_script\" is not found, find the nmap scripts emplacement !!${NC}\n"
fi

# Conf nmap
git clone https://github.com/vulnersCom/nmap-vulners.git ${rootDir}nmap-vulners
sudo cp ${rootDir}nmap-vulners/vulners.nse /usr/share/nmap/scripts/ && \
cd /usr/share/nmap/scripts/ && sudo nmap --script-updatedb

#Conf snmpwalk
sudo sed  -i "s/^mibs :$/#mibs :/g" /etc/snmp/snmp.conf

#Install masscan
command_exists "masscan"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInstall masscan${NC}"
	git clone https://github.com/robertdavidgraham/masscan ${rootDir}masscan 
	cd ${rootDir}masscan && make -j
	cd ${rootDir}masscan
	sudo make install
        sudo ln -s ${rootDir}masscan/bin/masscan /usr/local/bin/masscan
fi

#Install sslyze
echo -e "${GREEN}\nInstall sslyze${NC}"
$PIP_INSTALL sslyze==1.3.4 

#Install ssltest.py
command_exists "ssltest.py"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInstall ssltest${NC}"
	git clone https://github.com/Lekensteyn/pacemaker.git ${rootDir}pacemaker 
	sudo ln -s  ${rootDir}pacemaker/ssltest.py /usr/local/bin/ssltest.py
fi

#Install joomscan
command_exists "joomscan"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInstall joomscan${NC}"
	git clone https://github.com/rezasp/joomscan.git ${rootDir}joomscan 
	sudo ln -s  ${rootDir}joomscan/joomscan.pl /usr/local/bin/joomscan
fi

#Install wpscan
command_exists "wpscan"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInstall wpscan${NC}"
	$SUDO gem install  wpscan
fi

# Install snmp-check
command_exists "snmp-check"
if [ $? -ne 0 ]; then
        echo -e "${GREEN}\nInstall snmp-check${NC}"
        #Install snmp package
        $SUDO gem install snmp
        git clone https://gitlab.com/kalilinux/packages/snmpcheck.git ${rootDir}snmp-check
        chmod +x ${rootDir}snmp-check/snmpcheck-1.9.rb
        sudo ln -s ${rootDir}snmp-check/snmpcheck-1.9.rb /usr/local/bin/snmp-check
fi

#Install droopescan
command_exists "droopescan"
if [ $? -ne 0 ]; then
	echo -e "${GREEN}\nInstall droopescan${NC}"
	$PIP_INSTALL droopescan
fi

#Install gobuster
command_exists "gobuster"
if [ $? -ne 0 ]; then
    echo -e "${GREEN}\nInstall gobuster${NC}"
    command_exists "go"
    if [ $? -ne 0 ]; then
      curl -SL  https://golang.org/dl/go1.16.linux-amd64.tar.gz -o /tmp/go1.16.linux-amd64.tar.gz && \
      sudo tar -C /usr/local -xzf /tmp/go1.16.linux-amd64.tar.gz && \
      rm -rf /tmp/go1.16.linux-amd64.tar.gz && \
      echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile 
    fi  
    curl -SL https://github.com/OJ/gobuster/archive/v3.0.1.tar.gz -o /tmp/v3.0.1.tar.gz && \
    tar -C ${rootDir} -xzf /tmp/v3.0.1.tar.gz && rm -rf /tmp/v3.0.1.tar.gz && \
    mv ${rootDir}gobuster-3.0.1 ${rootDir}gobuster && cd ${rootDir}gobuster && \
    $SUDO  /usr/local/go/bin/go get && $SUDO /usr/local/go/bin/go build
    sudo ln -s  ${rootDir}gobuster/gobuster /usr/local/bin/gobuster
fi

#Install smbmap
command_exists "smbmap"
if [ $? -ne 0 ]; then
    echo -e "${GREEN}\nInstall smbmap${NC}"
    git clone https://github.com/ShawnDEvans/smbmap.git ${rootDir}smbmap 
    cd ${rootDir}smbmap && $PIP_INSTALL -r requirements.txt
    sudo ln -s  ${rootDir}smbmap/smbmap.py /usr/local/bin/smbmap
fi

#Install enum4linux
command_exists "enum4linux"
if [ $? -ne 0 ]; then
    echo -e "${GREEN}\nInstall enum4linux${NC}"
    git clone https://github.com/CiscoCXSecurity/enum4linux.git ${rootDir}enum4linux 
    sudo ln -s  ${rootDir}enum4linux/enum4linux.pl /usr/local/bin/enum4linux
fi

#Install hydra
command_exists "hydra"
if [ $? -ne 0 ]; then
    echo -e "${GREEN}\nInstall hydra${NC}"
    # Install dependencies
    mkdir /tmp/hydra && cd /tmp/hydra
    curl -o libgcrypt11-dev -SL http://security.debian.org/debian-security/pool/updates/main/libg/libgcrypt20/libgcrypt11-dev_1.5.4-3+really1.7.6-2+deb9u4_amd64.deb && \
    sudo dpkg -i libgcrypt11-dev  
    git clone https://github.com/vanhauser-thc/thc-hydra.git ${rootDir}thc-hydra 
    cd ${rootDir}thc-hydra && ./configure && make
    cd ${rootDir}thc-hydra && sudo make install
    rm -rf /tmp/hydra
fi

#Install Impacket
command_exists "lookupsid.py"
if [ $? -ne 0 ]; then
    echo -e "${GREEN}\nInstall Impacket${NC}"
    git clone https://github.com/SecureAuthCorp/impacket.git ${rootDir}impacket 
    cd  ${rootDir}impacket && $PIP_INSTALL .
fi

#Install Redis
command_exists "redis-exploit.py"
if [ $? -ne 0 ]; then
    echo -e "${GREEN}\nInstall redis-exploit.py${NC}"
    git clone https://github.com/roughiz/Redis-Server-Exploit-Enum.git ${rootDir}Redis-Server-Exploit-Enum && \
    chmod +x ${rootDir}Redis-Server-Exploit-Enum/redis-exploit.py && cd ${rootDir}Redis-Server-Exploit-Enum && \
    $PIP_INSTALL -r requirements.txt 
    sudo ln -s  ${rootDir}Redis-Server-Exploit-Enum/redis-exploit.py /usr/local/bin/redis-exploit.py
fi

#Install wfuzz
command_exists "wfuzz"
if [ $? -ne 0 ]; then
    echo -e "${GREEN}\nInstall wfuzz${NC}"
    $PIP_INSTALL wfuzz
fi

#Install odat.py
command_exists "odat.py"
if [ $? -ne 0 ]; then
    echo -e "${GREEN}\nInstall odat.py${NC}"
    destination="/usr/share/odat"
    if [ -d "$destination" ];then sudo rm -rf $destination; fi
    $SUDO git clone https://github.com/quentinhardy/odat.git $destination && \
    cd $curd && sudo cp -r wordlist/oracle/accounts_multiple_lower.txt wordlist/oracle/heavy*txt ${destination}/accounts/ && \
    sudo cp wordlist/oracle/sids.txt ${destination}/ && \
    cd $destination && \
    $SUDO git submodule init && \
    $SUDO git submodule update && \
    mkdir /tmp/odat_rpm  
    if [ ! $(dpkg -l | grep -i oracle-instantclient | wc -l) -ge 3 ];then
      curl -SL https://download.oracle.com/otn_software/linux/instantclient/211000/oracle-instantclient-basic-21.1.0.0.0-1.x86_64.rpm -o /tmp/odat_rpm/oracle-instantclient-basic.rpm && \
      curl -SL https://download.oracle.com/otn_software/linux/instantclient/211000/oracle-instantclient-tools-21.1.0.0.0-1.x86_64.rpm -o /tmp/odat_rpm/oracle-instantclient-tools.rpm && \
      curl -SL https://download.oracle.com/otn_software/linux/instantclient/211000/oracle-instantclient-devel-21.1.0.0.0-1.x86_64.rpm -o /tmp/odat_rpm/oracle-instantclient-devel.rpm && \
      cd /tmp/odat_rpm/ && alien --to-deb *.rpm && \
      sudo dpkg -i *.deb 
    fi
   version=$(dir /usr/lib/oracle/) && \
   if [ -n "$(grep "ORACLE_HOME" /etc/profile)"  ]
     then 
       sudo sed -Ei "s|/usr/lib/oracle/.*/client64/|/usr/lib/oracle/${version}/client64/|g" /etc/profile 
     else 
       sudo echo "export ORACLE_HOME=/usr/lib/oracle/${version}/client64/" >> /etc/profile && \
       sudo echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$ORACLE_HOME/lib" >> /etc/profile  && \
       sudo echo "export PATH=\${ORACLE_HOME}bin:\$PATH" >> /etc/profile  
   fi
   echo "/usr/lib/oracle/${version}/client64/lib/"  | sudo tee /etc/ld.so.conf.d/oracle.conf && \
   sudo ldconfig && source /etc/profile && $PIP_INSTALL cx_Oracle && $PIP_INSTALL python-libnmap && \
   sudo ln -s ${destination}/odat.py /usr/local/bin/odat.py && \
   sudo sed -i "s|#!/usr/bin/python|#!/usr/bin/env python3|g" ${destination}/odat.py
   rm -rf /tmp/odat_rpm
fi

## Install scautofire 
echo -e "${GREEN}\nInstall scautofire ${NC}"
cd "$curd"
sudo rm -rf /usr/bin/scautofire
sudo cp ./scautofire /usr/bin/

sudo rm -rf /usr/share/KeepScan
sudo ln -s $curd /usr/share/KeepScan
