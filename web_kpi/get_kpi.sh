#!/bin/bash
M=`/bin/date +%M -d "1 minutes ago"`
DM=`/bin/date +%M -d "59 minutes ago"`

#获取网站列表
/root/cron/cache_log/get_weblist.sh

#读取日志
cat /root/cron/cache_log/logdetail | while read s
do
   #包含log.php的记录才是我们需要统计的
   if [[ $s =~ "log.php" ]] 
   then
       #获取网站id
       tmp=${s#*&webid=};
       id=${tmp%&bid=*};
            
        #把用户访问详情保存到列表中
        /usr/bin/redis-cli lpush "web_"$id"_"$M"_detail" "${s}";

        t1=${s#*&url=};
        t2=${t1%&title=*};
      
        if [[ $t2 != "0" ]]
        then
            #保存到集合中用于统计独立ip
            /usr/bin/redis-cli sadd "web_"$id"_"$M"_ip" ${s%%-*};
            #统计页面访问数pv（用string保存）
            /usr/bin/redis-cli incr "web_"$id"_"$M"_pv";
            #统计独立用户数
            tmp1=${s#*&bid=};
            uv=${tmp1%&pid=*};
            /usr/bin/redis-cli sadd "web_"$id"_"$M"_uv" ${uv};
        fi
   fi
done

#删除掉一个小时候的数据
cat /root/cron/cache_log/weblist | while read id
do   
   if [ "$id" != "webid" ]
   then
   /usr/bin/redis-cli del "web_"$id"_"$DM"_ip";
   /usr/bin/redis-cli del "web_"$id"_"$DM"_pv";
   /usr/bin/redis-cli del "web_"$id"_"$DM"_uv";
   /usr/bin/redis-cli del "web_"$id"_"$DM"_detail"
   fi
done
