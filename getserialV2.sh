﻿#!/bin/bash
# Help prompt
 if [ $# -eq 0 ] || [ $1 == "-help" ]; then
  echo  "########### Command usage:###########"
  echo  "./getserialV2.sh [community] [list] [report_file.csv]";
  echo  "###########PARAMETERS###########
  [community]=community name snmpv2
  [Host_list]=host list ip
  [report_file.csv]=csv report file name"  
  exit 1
 fi

# Set VARs
 COMMUNITY="$1"
 LIST=$(cat $2)
 REPORT="$3"
 SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"


#Location of ENTITY-MIB
 ENTITY="$SCRIPTPATH/ENTITY-MIB.txt"
 

# Create CSV file and set header
 echo -e "Device_IP,Hostname,Device Description,Device Type,Serial Number,Model Number,Model Number 1" > $REPORT

# Loop through devices in list
 for DEVICE in $LIST ; do {

# Get hostname from device
 HOST=$(snmpget -v2c -c $COMMUNITY -Oqv $DEVICE SNMPv2-MIB::sysName.0)

# Add hostname and device name to csv
 #echo -e "$HOST,$DEVICE" >> $REPORT

#check the host response
 if [[ $HOST == "" ]]; then
	echo -e "$DEVICE,No Response" >> $REPORT
	echo >> $REPORT
 else

	# Echo status to stdout
	echo -e "Querying device: $DEVICE - Hostname: $HOST"

	# Querry ENTITY table on device cut only entPhysicalDescr, entPhysicalClass, entPhysicalSerialNum, entPhysicalModelName
 	# and entPhysicalAlias (entPhysicalAlias somtimes has serial number of chassis on router and model number on Nexus) colums
 	# and sed to remove top 3 lines of output. Input into a var TABLE
 	TABLE=$(snmptable -v2c -c $COMMUNITY -m +$ENTITY  -Cf , $DEVICE 1.3.6.1.2.1.47.1.1.1 )

	MTABLE=$( echo -e "$TABLE" |  awk  -F',' 'BEGIN{ OFS=","} { print $1";"$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13}' |  awk  -F'::' 'BEGIN{ OFS=","} {  print $1";"$2}' | cut -d ";" -f 1,3 | awk -F'[;,]' '{print $1 "," $4 "," $10 "," $13 "," $12}' )
 


	# Get line numbers that only have an entry in entPhysicalSerialNum column and input into var LINES
	LINES=$(echo -e "$MTABLE" | cut -sd "," -f 3 | grep -n . | cut -d : -f 1)


	# Loop through line numbers in var LINES. Echo TABLE into sed and grab lines from var LINES.
 	# Append to csv file
 	for i in $LINES; do {
	  TMP="$DEVICE"",""$HOST""," 
	  TMP2=$(echo -e "$MTABLE" | sed -n "$i"p)
	  echo -e $TMP$TMP2>>$REPORT  

	  #echo -e "$MTABLE" | sed -n "$i"p  >> $REPORT 2 > /dev/null 
	 }
	 done

	# Add line between devices in csv
	 echo >> $REPORT
 fi
 }
 done

echo -e "nSNMP Queries Completed"
