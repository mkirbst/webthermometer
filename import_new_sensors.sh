#!/bin/bash

# CREATE USER 'munin'@'localhost' IDENTIFIED BY 'MYPASSWORD';
# GRANT ALL PRIVILEGES ON basement.* TO 'munin'@'localhost';

SENSORFILE="new_sensors.txt"

## mysql settings ##
MYSQLUSER="munin";
MYSQLPASS="MYPASSWORD";
MYSQLHOST="localhost";
MYSQLPORT="3306";
MYSQLDB="basement";
MYSQLTABLE="tempsensors";
TS=`date "+%Y%m%d%H%M%S"`
## /mysql ##


#### create approriate table, if not already exists:
echo "CREATE DATABASE IF NOT EXISTS $MYSQLDB;" | mysql -u $MYSQLUSER -p$MYSQLPASS -h $MYSQLHOST -P $MYSQLPORT;
echo "CREATE TABLE IF NOT EXISTS $MYSQLDB.$MYSQLTABLE ( timestamp BIGINT, id VARCHAR(64) NOT NULL PRIMARY KEY, location VARCHAR(64) CHARACTER SET utf8, place VARCHAR(64) CHARACTER SET utf8, type VARCHAR(64) CHARACTER SET utf8, ipv4 VARCHAR(16) CHARACTER SET utf8, ipv6 VARCHAR(512) CHARACTER SET utf8, platform VARCHAR(64) CHARACTER SET utf8, label VARCHAR(64) CHARACTER SET utf8 );" | mysql -u $MYSQLUSER -p$MYSQLPASS -h $MYSQLHOST -P $MYSQLPORT;

while read LINE
do
         echo $LINE | awk '{print "INSERT INTO '"$MYSQLDB"'.'"$MYSQLTABLE"' (timestamp, id, location, place, type, platform, ipv4, ipv6, label) VALUES ('"$TS"', \x27"$1"\x27, \x27"$2"\x27, \x27"$3"\x27, \x27"$4"\x27, \x27"$5"\x27, \x27"$6"\x27, \x27"$7"\x27, \x27"$8"\x27);" }' | mysql -u $MYSQLUSER -p$MYSQLPASS -h $MYSQLHOST -P $MYSQLPORT;
done < <(cat $SENSORFILE | egrep -v ^# | uniq | grep .)
