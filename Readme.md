# Scanner and discovery
the script make a discovery scan of a network, scan all ips and create a note about it.

# Create a keepnote report

Create a keepNote report scan of a network from cidr/ip giving in the parameters and create a note for each ip and also make a nmap scan and write all information. The idea is to simplify all steps of scanning and writing info, and also to have a great presentation and organisation of our report.

#### Masscan 

The fastest Internet port scanner. It can scan the entire Internet in under 6 minutes, transmitting 10 million packets per second.
Combined with nmap, we can scan all (tcp/udp) port very quickly.

#### Nota:
masscan and keepnote must be installed.
You should open report with KeepNote tool.

# Script argments: 

```
	 -h --help
	 --type=l (set by default) / --type=h	[ Type of scan huge scan all port , and light for commun ports ] 
	 --name=a_report_name	[ the name of the report without space ] <Required>
	 --masscan=on (set by default) / --masscan=no	(scan without usinf masscan) 
	 --interface=tun0	( the interface to use with masscan, required if we use masscan )
	 --path=/path/to/report/destination_directory	( a directory where the script will create the report) <required>
	 --cidr=ip/cidr	( ip or a cidr like 10.10.10.0/24) <required>
Examples :

Default scan using Masscan:  
./keepNoteScanNetReportCreator.sh --name=report-name --path=/path/to/report/destination_directory --cidr=ip/cidr

Create a report scan with a light scan without Masscan :
./keepNoteScanNetReportCreator.sh --masscan=no --name=report-name --path=/path/to/report/destination_directory --cidr=10.10.10.0/24

Create a report scan with a huge scan without Masscan :
./keepNoteScanNetReportCreator.sh --type=h  --masscan=no --name=report-name --path=/path/to/report/destination_directory --cidr=10.10.10.0/24

```




