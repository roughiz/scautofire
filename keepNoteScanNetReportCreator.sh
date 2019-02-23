#!/bin/sh
# create the keepNote directory functins

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
# type of scan
if [ "$3" = "l" ]; then
  sudo nmap  -sV -sS  -T4 -oN $mydir/nmap.txt  $1
else
  sudo  nmap  -sV -sS -p- -T4 -sC  -oN $mydir/nmap.txt  $1
fi
content=$(sed  's/.*/&<br>/'   $mydir/nmap.txt)
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

if [ "$#" -ne 4 ]; then
    echo "Illegal number of parameters, 4 arguments required"
    echo "Example $0 <l(light scan)/h(huge scan)> <report-name> <path_to> <ip/cidr>"
    echo "Example : $0 l myreport /path/to/report/destination_directory 10.10.10.0/24" 
else
    rootDir=$3
    name=$2
    cidrip=$4
    dir=$3/$2
    scanfile=$dir/scan.txt
    ipfile=$dir/boxes_ips.txt
    scantype=$1

   if [ "$scantype" = "l" ]  || [ "$scantype" = "h" ] ; then
    if [ -d "$rootDir" ]; then
           create_keepNote $name $rootDir && \
           cp -r template/__NOTEBOOK__ $dir/ &&\
           sudo nmap --top-ports 100 -oN $scanfile $cidrip 
           cat $scanfile |  grep -i "Nmap scan" | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' > $ipfile 
	   for ip in $(cat $ipfile );do
                 verify_ip $ip
                 if [ $? -ne 0 ]; then
                    echo "$ip good"
                    create_sub_kpn $ip $dir $scantype
                 else
                    echo "$ip is not a valid ip"
                 fi 
               done      
          sudo chown -R $(whoami):$(whoami) $dir
    else
           echo "Error : directory  $rootDir not exist" 
	   exit 1
    fi
   else
        echo "Usage : "
	echo "Example $0 <l(light scan)/h(huge scan)> <report-name> <path_to> <ip/cidr>"
        echo "Example : $0 l myreport /path/to/report/destination_directory 10.10.10.0/24" 
        return 1
   fi
fi

