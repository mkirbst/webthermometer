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

# give the temp logger script some time to fill the database with actual temp values
sleep 8;

. $MUNIN_LIBDIR/plugins/plugin.sh

if [ "$1" = "autoconf" ]; then
        echo yes 
        exit 0
fi

if [ "$1" = "config" ]; then

        echo 'graph_title munin web thermo ver.20150922'
        echo 'graph_args --base 1000'
        echo 'graph_scale yes'
        echo 'graph_vlabel Grad Celsius'
        echo 'graph_category basement'
        mysql -u $MYSQLUSER -p$MYSQLPASS -h $MYSQLHOST -P $MYSQLPORT -NB -e "SELECT id,label FROM $MYSQLDB.$SENSORTABLE ORDER BY id ASC;" | awk '{print $1".label "$2}'
        exit 0
fi

mysql -u $MYSQLUSER -p$MYSQLPASS -h $MYSQLHOST -P $MYSQLPORT $MYSQLDB -NB -e "SELECT DISTINCT t1.* FROM $DATATABLE t1 INNER JOIN ( SELECT MAX(timestamp) AS max FROM $DATATABLE GROUP BY id ) t2 ON t1.timestamp = t2.max;" | awk '{print $2".value " $3}'
