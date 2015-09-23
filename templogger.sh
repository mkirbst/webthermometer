#!/bin/bash

## mysql settings ##
MYSQLUSER="munin";
MYSQLPASS="MYPASSWORD";
MYSQLHOST="localhost";
MYSQLPORT="3306";
MYSQLDB="basement";
DATATABLE="tempdata";
SENSORTABLE="tempsensors";
TS=`date "+%Y%m%d%H%M%S"`
## /mysql ##

IPFILE="./templog_sensors.txt";
TMPFILE="/tmp/templogmysql.tmp"
touch $TMPFILE && rm $TMPFILE 2>&1      ## supress error message if file not exist

# download the html pages from every hardware node
while read SENSORIP
do
        wget -qO- http://$SENSORIP >> $TMPFILE
done < <(mysql -u $MYSQLUSER -p$MYSQLPASS -h $MYSQLHOST -P $MYSQLPORT -NB -e "SELECT DISTINCT ipv4 FROM $MYSQLDB.$SENSORTABLE;")

while read LINE
do 
        ## only lines beginning with i2c id
        if [[ "$LINE" =~ ^[0-9A-F-]{23} ]]; then
                ID=`echo $LINE | awk '{print $1}'`;
                VAL=`echo $LINE | awk '{print $3}'`;
                echo "INSERT INTO $MYSQLDB.$DATATABLE (timestamp, id, value) VALUES ('$TS', '$ID', '$VAL')" | mysql -u $MYSQLUSER -p$MYSQLPASS -h $MYSQLHOST -P $MYSQLPORT;
        fi
done < $TMPFILE

rm $TMPFILE
exit 0
