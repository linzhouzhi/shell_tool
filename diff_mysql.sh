#!/bin/bash

HOSTNAME="192.168.1.204"
USERNAME="..."
PASSWORD="..."
ROOT="/data/tmp/"
MYSQL="/data/app/mysql/bin"

#获取数据库结构文件
${MYSQL}/mysqldump -u ${USERNAME} -p${PASSWORD} -h ${HOSTNAME} -d $1>${ROOT}dev.sql
${MYSQL}/mysqldump -u ${USERNAME} -p${PASSWORD} -h ${HOSTNAME} -d $2>${ROOT}test.sql
sed -i -e 's/AUTO_INCREMENT=[0-9]\{1,\}//' -i -e '3d' -i -e '$d' ${ROOT}dev.sql
sed -i -e 's/AUTO_INCREMENT=[0-9]\{1,\}//' -i -e '3d' -i -e '$d' ${ROOT}test.sql

#吧对比结果保存到diff.txt文件中
diff ${ROOT}dev.sql ${ROOT}test.sql > ${ROOT}diff.txt
