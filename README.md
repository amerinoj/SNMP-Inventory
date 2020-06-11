Bash Script to extract network inventory via SNMPv2 or SNMPv3
-------

# Description
Bash Script to extract network inventory and save it as csv file . It was tested with Cisco and Alcatel devices but it might work with other network devices. 

To run the script is mandatory had in your distro installed net-snmp package:http://www.net-snmp.org/.


Output example
```
Device_IP		Hostname	Device Description			Device Type		Serial Number	Model Number	Othern
10.1.1.1		Device_name	Transceiver(slot:3-port:11)	module			XXXXS-NXXXXX 	SFP-10G-SR-S	
10.1.1.1		Device_name	Transceiver(slot:3-port:41)	module			XXXXS-NXXXXX 	SFP-10G-SR-S	
10.1.1.1		Device_name	Transceiver(slot:3-port:44)	module			XXXXS-NXXXXX 	SFP-10G-SR-S	
10.1.1.1		Device_name	Transceiver(slot:3-port:3)	module			XXXXS-NXXXXX 	SFP-10G-SR	
10.1.1.1		Device_name	Transceiver(slot:3-port:40)	module			XXXXS-NXXXXX 	SFP-10G-SR	
```

  
# Installation

Install net-snmp

Debian example:
```
sudo apt-get update
sudo apt-get install snmp
```

Clone the repository
```
sudo git clone https://github.com/amerinoj/SNMP-Inventory.git
```

Add privileges
```
cd SNMP-Inventory
sudo chmod +x getserialV2.sh
sudo chmod +x getserialV3.sh
```

---------------------------------------------------------------------
# Usage

* Put your devices ip address to Device List.txt
Example:DeviceList.txt
```
10.1.1.2
10.1.1.3
```
---------------------------------------------------------------------
**getserialV2**

Run getserialV2 and see help
```
./getserialV2.sh 
```
```
########### Command usage:###########
./getserialV2.sh [community] [list] [report_file.csv]
###########PARAMETERS###########
  [community]=community name snmpv2
  [Host_list]=host list ip
  [report_file.csv]=csv report file name
```
Example parameters
```
./getserialV2.sh public2 DeviceList.txt report_file.csv
```

---------------------------------------------------------------------
**getserialV3**

Run getserialV2 and see help
```
./getserialV3.sh 
```
```
########### Command usage: ###########
./getserialV3.sh [user] [password] [auth_proto] [privacy_proto] [Host_list] [report_file.csv]
 ###########PARAMETERS###########
  [user]=username snmpv3
  [password]=password
  [auth_proto]=authentication protocol ej:SHA
  [privacy_proto]=privacy protocol ej:DES
  [Host_list]=host list ip
  [report_file.csv]=csv report file name
```
Example parameters
```
./getserialV3.sh username password1 MD5 AES DeviceList.txt Report1.csv 
