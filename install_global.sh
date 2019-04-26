#!/bin/sh

# Install the script in gloabl mode
if [ $(id -u)  -ne 0 ]; then
   echo "This script must be run as root, use sudo "$0" instead" 1>&2
   exit 1
fi
cp ./keepNoteScanNetReportCreator.sh /usr/bin/
cp ./create_SemiNoteFromIpWithMasscan.sh /usr/bin/

ln -s $PWD /usr/share/KeepScan
