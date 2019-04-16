#!/bin/sh
id=""
for i in 8 4 4 4 12
 do
  hash=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $i | head -n 1)
  if [ $i -eq 12 ]
   then
    id=$id$hash
  else
    id=$id$hash-
  fi
 done
#echo $id
# create directory
if [ "$#" -ne 4 ]; then
  name=$1
  dir=$2/$1
  tunnel=$3
else
  name=$3
  dir=$2/$3
  tunnel=$4
fi

mkdir $dir
#creade node 
cat <<EOF > $dir/node.xml
<?xml version="1.0" encoding="UTF-8"?>
<node>
<version>6</version>
<dict>
  <key>expanded</key><false/>
  <key>title</key><string>$name</string>
  <key>nodeid</key><string>$id</string>
  <key>modified_time</key><integer>$(date +%s)</integer>
  <key>version</key><integer>6</integer>
  <key>content_type</key><string>text/xhtml+xml</string>
  <key>created_time</key><integer>$(date +%s)</integer>
  <key>info_sort_dir</key><integer>1</integer>
  <key>order</key><integer>2</integer>
  <key>info_sort</key><string>order</string>
  <key>icon</key><string>$(ls /usr/lib/python2.7/dist-packages/keepnote/images/node_icons/note-* | shuf  -n 1 | cut -d"/" -f 9)</string>
</dict>
</node>
EOF
sudo masscan -p1-65535,U:1-65535 $1 --rate=300 -e $tunnel > $dir/masscan.txt

for port in $(cat $dir/masscan.txt | grep -i open  | grep -i tcp |cut  -d " " -f 4 | cut -d "/" -f 1) ; do ports_tcp="$port,$ports_tcp"  ; done
ports_tcp=$(echo $ports_tcp | sed 's/.$//'  )

for port in $(cat $dir/masscan.txt | grep -i open  | grep -i udp |cut  -d " " -f 4 | cut -d "/" -f 1) ; do ports_udp="$port,$ports_udp"  ; done
ports_udp=$(echo $ports_udp | sed 's/.$//'  )

echo "ports scan : $ports_tcp"
if [ $(echo $ports_tcp | wc -w)   -ne 0 ]; then
   sudo  nmap  -sV -sS -p $ports_tcp -T4 -sC  -oN $dir/nmap.txt  $1
fi

udp=0
if [ $(echo $ports_udp | wc -w)   -ne 0 ]; then
   sudo  nmap  -sV -sS -sU -p $ports_udp -T4 -sC  -oN $dir/nmap2.txt  $1
   udp=1
fi

content=$(sed  's/.*/&<br>/'   $dir/nmap.txt)
if [ "$udp" -ne 0 ]; then 
content="$content <br>Udp section : <br> $(sed  's/.*/&<br>/'   $dir/nmap2.txt) "
fi
cat <<EOF > $dir/page.html
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><body>

$content

</body></html>
EOF


