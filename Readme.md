# Scanner and discovery
the script make a discovery scan of a network, scan all ips and create a note about it.

# Create a keepnote report

Create a keepNote report scan of a network from cidr/ip giving in the parameters and create a note for each ip and also make a nmap scan and write all information. The idea is to simplify all steps of scanning and writing info, and also to have a great presentation and organisation of our report.

### Create a page for a keepNote report 

We can also create just a page for a keepNote report

### Functions:

- A very fast port scanner, can scan all udp and tcp port in about 6 min
- Scan for any Cves about apps or any used services
- Directory and file enumeration about  any http/https server
- Enumerate for smb authentication 
- Scan for kerberos authentication and enumerate any exploit aboutit
- Enumerate users etc
- Enumerate Redis/SNMP/SSL/CMS  

## Report example:

![report example](https://github.com/roughiz/EnumNeTKeepNoteReportCreator/blob/master/scauto.gif)

#### Masscan 

The fastest Internet port scanner. It can scan the entire Internet in under 6 minutes, transmitting 10 million packets per second.
Combined with nmap, we can scan all (tcp/udp) port very quickly.

#### Nota:
masscan and keepnote and many other tools must be installed. See requirements file

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

# Script argments Usage: 

```
$ scautofire    

Usage:
	 scautofire  [command] [Flags]
Available Commands:
	 new                     Create a new report scan
	 addto                   Add a scan into a report already exists

Flags:
	 -h, --help                   help for ./scautofire
	     --type=string            l|h  ['h' for huge scan(all ports) and 'l' for light scan(for commun ports)]           (light by default)
	     --masscan=string         on|no ['on' to enable masscan and 'no' to disable masscan]                             (enable by default)
	     --interface=string       The network interface to use with masscan, required if masscan is enabled
	     --rate=int               The speed of masscan, 150<value<1000                                                   (set to 150 by default)

Use 'scautofire [command] --help' for more information about a command.
```

# Create a new report usage:

```
$ scautofire new -h
Create a new report scan mode

Usage:
	 scautofire  new [flags]

Flags:
	 -h, --help                   help for new
	     --type=string            l|h  ['h' for huge scan(all ports) and 'l' for light scan(for commun ports)]           (light by default)
	     --recon=string           l|h  ['h' for huge recon(Use big dictionary) and 'l' for light scan(Use common dictionary wordlist)] 
	     --masscan=string         on|no ['on' to enable masscan and 'no' to disable masscan]                             (enable by default)
	     --interface=string       The network interface to use with masscan, required if masscan is enabled
	     --rate=int               The speed of masscan, 150<value<1000                                                   (set to 150 by default)
	     --path=string            Path to a directory where the scautofire will create the new report                    <required>
	     --name=string            The name of the report without space                                                   <Required>
	     --cidr=ip[:name]|cidr    ip or a cidr like 10.10.10.0/24, if name used it will be shown instead of the ip
	     --router-ip=ip           The gateway of the network interface if masscan can't found 
	                                      it(failed to detect router for interface)
	     --ips-list=string        Path to a file which contains a list of ips to scan, you can define the name to show
	                                      in the report instead of the ip. Using space for the separation

Examples :

Default scan using Masscan with a rate of 500:  
	scautofire new --name=report-name --path=/path/to/report/destination_directory --rate=500 --interface=tun0  --cidr=10.10.10.0/16

Default scan using Masscan with a light reconnaissance:  
	scautofire new --name=report-name --path=/path/to/exists/report/directory --interface=tun0  --cidr=10.10.10.0/16 --scan=l

Default scan using Masscan with a rate of 500, scan one ip and define the name to show instead of ip:  
	scautofire new --name=report-name --path=/path/to/report/destination_directory --rate=500 --interface=tun0  --cidr=10.10.10.12:Box12

Default scan using Masscan and a list of ips, with the router ip gateway :  
scautofire new --name=report-name --path=/path/to/report/destination_directory --ips-list=file --interface=tun0  --router-ip=192.168.55.1 

Create a report scan with a light scan without Masscan :
scautofire new --masscan=no --name=report-name --path=/path/to/report/destination_directory --cidr=10.10.10.14

Create a report scan with a huge scan without Masscan :
scautofire new --type=h  --masscan=no --name=report-name --path=/path/to/report/destination_directory --cidr=10.10.10.0/24

```
# Add a scan into an existing report;

```
$ scautofire addto -h
Add a scan into a report already exists mode

Usage:
	 scautofire  addto [flags]

Flags:
	 -h, --help                   help for addto
	     --type=string            l|h  ['h' for huge scan(all ports) and 'l' for light scan(for commun ports)]           (light by default)
	     --recon=string           l|h  ['h' for huge recon(Use big dictionary) and 'l' for light scan(Use common dictionary wordlist)] 
	     --masscan=string         on|no ['on' to enable masscan and 'no' to disable masscan]                             (enable by default)
	     --interface=string       The network interface to use with masscan, required if masscan is enabled
	     --rate=int               The speed of masscan, 150<value<1000                                                   (set to 150 by default)
	     --path=string            Path to a scautofire report where the scan will be added                               <required>
	     --cidr=ip[:name]|cidr    ip or a cidr like 10.10.10.0/24, if name used it will be shown instead of the ip
	     --router-ip=ip           The gateway of the network interface if masscan can't found 
	                                      it(failed to detect router for interface)
	     --ips-list=string        Path to a file which contains a list of ips to scan, you can define the name to show
	                                      in the report instead of the ip. Using space for the separation

Examples :

Default scan using Masscan with a rate of 500:  
	scautofire addto --path=/path/to/exists/report/directory --rate=500 --interface=tun0  --cidr=10.10.10.0/16

Default scan using Masscan with a light reconnaissance:  
	scautofire addto --path=/path/to/exists/report/directory --interface=tun0  --cidr=10.10.10.0/16 --scan=l

Default scan using Masscan with a rate of 500, scan one ip and define the name to show instead of ip:  
	scautofire addto  --path=/path/to/exists/report/directory --rate=500 --interface=tun0  --cidr=10.10.10.12:Box12

Default scan using Masscan and a list of ips, with the router ip gateway :  
scautofire addto  --path=/path/to/exists/report/directory --ips-list=file --interface=tun0  --router-ip=192.168.55.1 

Create a report scan with a light scan without Masscan :
scautofire addto --masscan=no  --path=/path/to/exists/report/directory --cidr=10.10.10.14

Create a report scan with a huge scan without Masscan :
scautofire addto --type=h  --masscan=no  --path=/path/to/exists/report/directory --cidr=10.10.10.0/24
``` 






