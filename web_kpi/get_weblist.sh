#!/bin/bash

HOSTNAME="192.168.1.253"
PORT="3306"
USERNAME="..."
PASSWORD="..."

echo "webid">/root/cron/cache_log/weblist
sql="select webid from stat_web_list"
/phpstudy/mysql/bin/mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} stat -e "${sql}" | while read webid
do
 echo $webid >> /root/cron/cache_log/weblist
done