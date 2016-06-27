#!/bin/bash

#日志产生的地址
logs_path="/phpstudy/server/nginx/logs/stat/log/"
#日志移动的地址
logs_move_path="/phpstudy/server/nginx/logs/stat/move_log/"
#日志的名称和扩展名
log_name="access"
log_ext=".log*"
pid_path="/phpstudy/server/nginx/logs/nginx.pid"

#移动日志前先删除日志移动目录下的文件，避免要拷贝的时候重复拷贝
rm ${logs_move_path}${log_name}*
#将日志拷贝到缓存文件中用于redis的读取
cp ${logs_path}${log_name}${log_ext} /root/cron/cache_log/logdetail
#将日志移动到指定的地址
mv ${logs_path}${log_name}${log_ext} ${logs_move_path}${log_name}-$(date +"%Y-%m-%d-%H-%M").log

#重启日志
kill -USR1 `cat ${pid_path}`

#get kpi for cache
/root/cron/cache_log/get_kpi.sh

#copy access.log to hadoop003
/usr/bin/scp ${logs_move_path}access*.log root@taget_ip:/root/stat/log
