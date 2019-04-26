#!/bin/sh
# create the keepNote directory functions

hash_gen(){
  id=""
  for i in 8 4 4 4 12
   do
    hash=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $i | head -n 1)
    if [ $i -eq 12 ]
     then
       id=$id$hash
    else
       id="$id$hash-"
    fi
   done
 echo $id
}
# hashes used for templates
hash1=$(hash_gen)
hash2=$(hash_gen)
hash3=$(hash_gen)
hash4=$(hash_gen)
hash5=$(hash_gen)

create_keepNote(){
# create directory
dir=$2/$1
mkdir $dir
#creade node 
cat <<EOF > $dir/node.xml
<?xml version="1.0" encoding="UTF-8"?>
<node>
<version>6</version>
<dict>
  <key>attr_tables</key><array>
    <dict>
      <key>name</key><string>Default Table</string>
      <key>key</key><string>default</string>
      <key>attrs</key><array>
        <string>title</string>
        <string>created_time</string>
        <string>modified_time</string>
      </array>
    </dict>
  </array>
  <key>expanded</key><true/>
  <key>nodeid</key><string>$hash1</string>
  <key>modified_time</key><integer>$(date +%s)</integer>
  <key>content_type</key><string>application/x-notebook-dir</string>
  <key>created_time</key><integer>$(date +%s)</integer>
  <key>info_sort_dir</key><integer>1</integer>
  <key>title</key><string>$1</string>
  <key>column_widths</key><dict>
    <key>created_time</key><integer>150</integer>
    <key>modified_time</key><integer>1410</integer>
    <key>title</key><integer>150</integer>
  </dict>
  <key>attr_defs</key><array>
    <dict>
      <key>datatype</key><string>string</string>
      <key>default</key><string></string>
      <key>name</key><string>Duplicate of</string>
      <key>key</key><string>duplicate_of</string>
    </dict>
    <dict>
      <key>datatype</key><string>string</string>
      <key>default</key><string></string>
      <key>name</key><string>Title</string>
      <key>key</key><string>title</string>
    </dict>
    <dict>
      <key>datatype</key><string>string</string>
      <key>default</key><string></string>
      <key>name</key><string>Filename</string>
      <key>key</key><string>payload_filename</string>
    </dict>
    <dict>
      <key>datatype</key><string>bool</string>
      <key>default</key><true/>
      <key>name</key><string>Expaned</string>
      <key>key</key><string>expanded</string>
    </dict>
    <dict>
      <key>datatype</key><string>string</string>
      <key>default</key><string></string>
      <key>name</key><string>Node ID</string>
      <key>key</key><string>nodeid</string>
    </dict>
    <dict>
      <key>datatype</key><string>timestamp</string>
      <key>default</key><null/>
      <key>name</key><string>Modified time</string>
      <key>key</key><string>modified_time</string>
    </dict>
    <dict>
      <key>datatype</key><string>string</string>
      <key>default</key><string></string>
      <key>name</key><string>Icon open</string>
      <key>key</key><string>icon_open</string>
    </dict>
    <dict>
      <key>datatype</key><string>bool</string>
      <key>default</key><true/>
      <key>name</key><string>Expanded2</string>
      <key>key</key><string>expanded2</string>
    </dict>
    <dict>
      <key>datatype</key><string>string</string>
      <key>default</key><string></string>
      <key>name</key><string>Title Background Color</string>
      <key>key</key><string>title_bgcolor</string>
    </dict>
    <dict>
      <key>datatype</key><string>string</string>
      <key>default</key><string>application/x-notebook-dir</string>
      <key>name</key><string>Content type</string>
      <key>key</key><string>content_type</string>
    </dict>
    <dict>
      <key>datatype</key><string>timestamp</string>
      <key>default</key><null/>
      <key>name</key><string>Created time</string>
      <key>key</key><string>created_time</string>
    </dict>
    <dict>
      <key>datatype</key><string>integer</string>
      <key>default</key><integer>1</integer>
      <key>name</key><string>Folder sort direction</string>
      <key>key</key><string>info_sort_dir</string>
    </dict>
    <dict>
      <key>datatype</key><string>integer</string>
      <key>default</key><integer>9223372036854775807</integer>
      <key>name</key><string>Order</string>
      <key>key</key><string>order</string>
    </dict>
    <dict>
      <key>datatype</key><string>string</string>
      <key>default</key><string>order</string>
      <key>name</key><string>Folder sort</string>
      <key>key</key><string>info_sort</string>
    </dict>
    <dict>
      <key>datatype</key><string>string</string>
      <key>default</key><string></string>
      <key>name</key><string>Icon</string>
      <key>key</key><string>icon</string>
    </dict>
  </array>
  <key>version</key><integer>6</integer>
  <key>order</key><integer>0</integer>
  <key>info_sort</key><string>order</string>
</dict>
</node>
EOF

cat <<EOF > $dir/notebook.nbk
<?xml version="1.0" encoding="UTF-8"?>
<notebook>
<version>6</version>
<pref>
    <dict>
        <key>version</key><integer>6</integer>
        <key>quick_pick_icons</key><array>
            <string>folder.png</string>
            <string>folder-red.png</string>
            <string>folder-orange.png</string>
            <string>folder-yellow.png</string>
            <string>folder-green.png</string>
            <string>folder-blue.png</string>
            <string>folder-violet.png</string>
            <string>folder-grey.png</string>
            <string>note.png</string>
            <string>note-red.png</string>
            <string>note-orange.png</string>
            <string>note-yellow.png</string>
            <string>note-green.png</string>
            <string>note-blue.png</string>
            <string>note-violet.png</string>
            <string>note-grey.png</string>
            <string>star.png</string>
            <string>heart.png</string>
            <string>check.png</string>
            <string>x.png</string>
            <string>important.png</string>
            <string>question.png</string>
            <string>web.png</string>
            <string>note-unknown.png</string>
        </array>
        <key>index_dir</key><string></string>
        <key>colors</key><array>
            <string>#ff9999</string>
            <string>#ffcc99</string>
            <string>#ffff99</string>
            <string>#99ff99</string>
            <string>#99ffff</string>
            <string>#9999ff</string>
            <string>#ff99ff</string>
            <string>#ff0000</string>
            <string>#ffa300</string>
            <string>#ffff00</string>
            <string>#00ff00</string>
            <string>#00ffff</string>
            <string>#0000ff</string>
            <string>#ff00ff</string>
            <string>#7f0000</string>
            <string>#7f5100</string>
            <string>#7f7f00</string>
            <string>#007f00</string>
            <string>#007f7f</string>
            <string>#00007f</string>
            <string>#7f007f</string>
            <string>#ffffff</string>
            <string>#e5e5e5</string>
            <string>#bfbfbf</string>
            <string>#7f7f7f</string>
            <string>#3f3f3f</string>
            <string>#191919</string>
            <string>#000000</string>
        </array>
        <key>windows</key><dict>
            <key>ids</key><dict>
                <key>$hash2</key><dict>
                    <key>viewerid</key><string>$hash3</string>
                    <key>viewer_type</key><string>tabbed_viewer</string>
                </dict>
            </dict>
        </dict>
        <key>viewers</key><dict>
            <key>ids</key><dict>
                <key>$hash4</key><dict>
                    <key>selected_treeview_nodes</key><array>
                        <string>$hash5</string>
                    </array>
                    <key>selected_listview_nodes</key><array>
                        <string>$hash5</string>
                    </array>
                </dict>
                <key>$hash3</key><dict>
                    <key>tabs</key><array>
                        <dict>
                            <key>viewerid</key><string>$hash4</string>
                            <key>viewer_type</key><string>three_pane_viewer</string>
                            <key>name</key><string></string>
                        </dict>
                    </array>
                    <key>current_viewer</key><string>$hash4</string>
                </dict>
            </dict>
        </dict>
        <key>default_font</key><string>Sans 10</string>
    </dict>
</pref>
</notebook>
EOF
}

# create sub diretory for keepNote project
create_sub_kpn(){
# Random note hash
rhash=$(hash_gen)
# create directory
mydir=$2/$1
mkdir $mydir
#creade node 
cat <<EOF > $mydir/node.xml
<?xml version="1.0" encoding="UTF-8"?>
<node>
<version>6</version>
<dict>
  <key>expanded</key><false/>
  <key>title</key><string>$1</string>
  <key>nodeid</key><string>$rhash</string>
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
# masscan 
udp=0
if [ "$4" = "on" ]; then
  if [ "$7" = "" ];then 
     masscan -p1-65535,U:1-65535 $1 --rate=$6 -e $5  > $mydir/masscan.txt
  else
     masscan -p1-65535,U:1-65535 $1 --rate=$6 -e $5 --router-ip $7 > $mydir/masscan.txt
  fi
  # Initializing variables
  ports_tcp=""
  ports_udp=""
  for port in $(cat $mydir/masscan.txt | grep -i open  | grep -i tcp |cut  -d " " -f 4 | cut -d "/" -f 1) ; do ports_tcp="$port,$ports_tcp"  ; done
  ports_tcp=$(echo $ports_tcp | sed 's/.$//'  )

  for port in $(cat $mydir/masscan.txt | grep -i open  | grep -i udp |cut  -d " " -f 4 | cut -d "/" -f 1) ; do ports_udp="$port,$ports_udp"  ; done
  ports_udp=$(echo $ports_udp | sed 's/.$//'  )
  #echo "ports scan : $ports_tcp"
  if [ $(echo $ports_tcp | wc -w)   -ne 0 ]; then
     nmap  -sV -sS -p $ports_tcp -T4 -sC  -oN $mydir/nmap.txt  $1
  fi
  if [ $(echo $ports_udp | wc -w)   -ne 0 ]; then
     nmap  -sV -sS -sU -p $ports_udp -T4 -sC  -oN $mydir/nmap2.txt  $1
     udp=1
  fi
else
  if [ "$3" = "l" ]; then
    nmap  -sV -sS  -T4 -oN $mydir/nmap.txt  $1
  else
    nmap  -sV -sS -p- -T4 -sC  -oN $mydir/nmap.txt  $1
  fi
fi
content=$(sed  's/.*/&<br>/'   $mydir/nmap.txt)
if [ "$udp" -ne 0 ]; then 
content="$content <br>Udp section : <br>  $(sed  's/.*/&<br>/'   $mydir/nmap2.txt) "
fi
cat <<EOF > $mydir/page.html
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><body>

$content

</body></html>
EOF
}


verify_ip(){
if expr "$1" : '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$' >/dev/null; then
  for i in 1 2 3 4; do
    if [ $(echo "$1" | cut -d. -f$i) -gt 255 ]; then
     return 0
    fi
  done
  return 1
else
    return 0
fi
}

usage()
{
    echo "\nHelp :"
    echo "\t -h --help"
    echo "\t --type=l (set by default) / --type=h\t[ Type of scan huge scan all port , and light for commun ports ] "
    echo "\t --name=a_report_name\t[ the name of the report without space ] <Required>"
    echo "\t --masscan=on (set by default) / --masscan=no\t(scan without using masscan) "
    echo "\t --interface=tun0\t( the interface to use with masscan, required if we use masscan )"
    echo "\t --rate=1000\t(by default the rate is set to 150 which is slow but you can increase the speed , with a hight rate )"
    echo "\t --path=/path/to/report/destination_directory\t( a directory where the script will create the report) <required>"
    echo "\t --cidr=ip/cidr\t( ip or a cidr like 10.10.10.0/24) <required>"
    echo "\t --router-ip=the gateway of an interface if masscan can't found it (failed to detect router for interface) "
    echo "\t --ips-list=/path/to/file ( this file contains a list of ips to scan)" 
    echo "Examples :\n"
    echo "Default scan using Masscan with a rate of 500:  \n$0 --name=report-name --path=/path/to/report/destination_directory --rate=500 --interface=tun0  --cidr=ip/cidr\n"
    echo "Default scan using Masscan and a list of ips, with the router ip gateway :  \n$0 --name=report-name --path=/path/to/report/destination_directory --ips-list=file --interface=tun0  --router-ip=192.168.55.1 \n"
    echo "Create a report scan with a light scan without Masscan :\n$0 --masscan=no --name=report-name --path=/path/to/report/destination_directory --cidr=10.10.10.0/24\n"
    echo "Create a report scan with a huge scan without Masscan :\n$0 --type=h  --masscan=no --name=report-name --path=/path/to/report/destination_directory --cidr=10.10.10.0/24\n"


}

# Main 
#Verify if script run as root
if [ $(id -u)  -ne 0 ]; then 
   echo "This script must be run as root, use sudo "$0" instead" 1>&2
   exit 1
fi
# Default values
GREEN='\033[0;32m'
RED='\033[0;31m'
scantype=l
masscan=on
interface=""
required=0
rate=150
file_ips=""
router_ip=""
gks=$(env | grep KEEPSCAN)
if [ "$gks" = "" ];then
  if [ -d  "/usr/share/KeepScan/template" ]; then
       KEEPSCAN="/usr/share/KeepScan"
  else
    if [ -d "./template" ]; then 
      KEEPSCAN="."
    else
      print "You should be in the KeepScan directory, or install it globally !!"
      exit 1 
    fi
  fi   
fi

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        --type)
             if [ "$VALUE" = "h" ] || [ "$VALUE" = "l" ] ; then
                scantype=$VALUE
             else 
                echo "ERROR: value \"$VALUE\" for parameter \"$PARAM\" is wrong "
                usage
                exit 1	
             fi
             ;;
        --name)
            name=$VALUE
            required=$((required+1))
            ;;
        --masscan)
             if [ "$VALUE" = "no" ] || [ "$VALUE" = "on" ]; then
                masscan=$VALUE
             else 
                echo "ERROR: value \"$VALUE\" for parameter \"$PARAM\" is wrong "
                usage
                exit 1
             fi
             ;;
        --interface)
            interface=$VALUE
            ;;
        --rate)
            re='^[0-9]+$'
            if [ "$VALUE" -gt 0 ] ; then
               rate=$VALUE
            else
               echo "ERROR: the value  \"$VALUE\" should be a positive integer only"
               usage
               exit 1
            fi
            ;;    
        --path)
            if [ -d "$VALUE" ]; then
              rootDir=$VALUE
              required=$((required+1))
            else
              echo "ERROR: the path \"$VALUE\" is not a directory !! "
              usage
              exit 1
            fi
            ;;
        --ips-list)
            if [ -f "$VALUE" ]; then
              file_ips=$VALUE
              required=$((required+1))	
            else
              echo "ERROR: the path \"$VALUE\" is not a file !! "
              usage
              exit 1
            fi
            ;;
        --cidr)
            cidrip=$VALUE
            required=$((required+1))
            ;;
        --router-ip)
            verify_ip $VALUE
            if [ $? -ne 0 ]; then
               router_ip="$VALUE"
            else
              echo "ERROR: the value  \"$VALUE\" is not a valid ip !!"
              usage
              exit 1
            fi
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

# Verify required params
if [ "$required" -ne 3 ]; then
   echo "ERROR: parameters '--name' and '--path' and ('--cidr' or '--ips-list') are required"
   usage
   exit 1
else
    if [ "$masscan" = "on" ] && [ "$interface" = "" ]; then
       echo "ERROR: the parameter '--interface' must be set when '--masscan' is enabled "
       usage 
       exit 1
    fi
    dir=$rootDir/$name
    scanfile=$dir/scan.txt
    ipfile=$dir/boxes_ips.txt
    create_keepNote $name $rootDir && \
    cp -r $KEEPSCAN/template/__NOTEBOOK__ $dir/ &&\
    if [ "$file_ips" != "" ]; then
        cat $file_ips > $ipfile
    else
        nmap --top-ports 100 -oN $scanfile $cidrip 
        cat $scanfile |  grep -i "Nmap scan" | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' > $ipfile 
    fi
    for ip in $(cat $ipfile );do
        verify_ip $ip
        if [ $? -ne 0 ]; then
           create_sub_kpn $ip $dir $scantype $masscan $interface $rate $router_ip
        else
           echo "\"$ip\" is not a valid ip"
        fi 
    done 
   # If user want to let created report writable by a local user 
   echo  "${RED}If you want to let the created report writable by local user, tape :"
   echo  "${GREEN}sudo chown -R \$(whoami):\$(whoami) $dir"
fi

