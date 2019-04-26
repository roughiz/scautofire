# Scanner and discovery
the script make a discovery scan of a network, scan all ips and create a note about it.

# Create a keepnote report

Create a keepNote report scan of a network from cidr/ip giving in the parameters and create a note for each ip and also make a nmap scan and write all information. The idea is to simplify all steps of scanning and writing info, and also to have a great presentation and organisation of our report.

![report example](https://github.com/roughiz/EnumNeTKeepNoteReportCreator/blob/master/example.png)
#### Masscan 

The fastest Internet port scanner. It can scan the entire Internet in under 6 minutes, transmitting 10 million packets per second.
Combined with nmap, we can scan all (tcp/udp) port very quickly.

#### Nota:
masscan and keepnote must be installed.
You should open report with KeepNote tool.
To start the script from anywhere you should define the location of the script like :
```
sudo export KEEPSCAN="/path/to/EnumNeTKeepNoteReportCreator"
```
### Install it in global mode
To intsall the script in global mode, use the script like :
```
$ sudo ./install_global.sh
```


# Script argments: 

```
Help :
	 -h --help
	 --type=l (set by default) / --type=h	[ Type of scan huge scan all port , and light for commun ports ] 
	 --name=a_report_name	[ the name of the report without space ] <Required>
	 --masscan=on (set by default) / --masscan=no	(scan without using masscan) 
	 --interface=tun0	( the interface to use with masscan, required if we use masscan )
	 --rate=1000	(by default the rate is set to 150 which is slow but you can increase the speed , with a hight rate )
	 --path=/path/to/report/destination_directory	( a directory where the script will create the report) <required>
	 --cidr=ip/cidr	( ip or a cidr like 10.10.10.0/24) <required>
	 --router-ip=the gateway of an interface if masscan can't found it (failed to detect router for interface) 
	 --ips-list=/path/to/file ( this file contains a list of ips to scan)
Examples :

Default scan using Masscan with a rate of 500:  
sudo keepNoteScanNetReportCreator.sh --name=report-name --path=/path/to/report/destination_directory --rate=500 --interface=tun0  --cidr=ip/cidr

Default scan using Masscan and a list of ips, with the router ip gateway :  
sudo keepNoteScanNetReportCreator.sh --name=report-name --path=/path/to/report/destination_directory --ips-list=file --interface=tun0  --router-ip=192.168.55.1 

Create a report scan with a light scan without Masscan :
sudo keepNoteScanNetReportCreator.sh --masscan=no --name=report-name --path=/path/to/report/destination_directory --cidr=10.10.10.0/24

Create a report scan with a huge scan without Masscan :
sudo keepNoteScanNetReportCreator.sh --type=h  --masscan=no --name=report-name --path=/path/to/report/destination_directory --cidr=10.10.10.0/24

```

### Create a page for a keepNote report 
We can also create just a page for a keepNote report, an example here to create a page for the Hack the box Inception machine :

```
create_SemiNoteFromIpWithMasscan.sh 10.10.10.67  /path/to/a/keepnote/report Inception  tun0
```





