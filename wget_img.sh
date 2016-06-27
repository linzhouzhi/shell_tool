#!/bin/bash
#处理思路
#循环从数据库读取resouce_id 还有paper_logo,还有page_pic
#通过wget将图片下载保存到制定的目录
#更新数据库中的图片地址

HOSTNAME="192.168.1.253"
PORT="3306"
USERNAME="..."
PASSWORD="..."
DBNAME="..."
#图片存放路径
IMG="/home/lzz/res/star/star_img/"

sql="select id,star_img from zmt_media WHERE plate<>2"
/phpstudy/mysql/bin/mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${sql}" | while read id img
do
    if [ "$id" != "id" ];then
        if [ "$img"x != 'x' ];then
            file_type=${img:0-4}
            img_file=$IMG$id$file_type
            #下载图片可以重试两次超时是10秒
            `/usr/bin/wget -t 2 -T 10 -c --no-check-certificate "http://www.myunmei.com"$img -O $img_file`
	    #判断文件的大小，如果等于0要重新抓一次
            if [ $(/usr/bin/stat -c %s $img_file) -eq 0 ];then
            `/usr/bin/wget -t 2 -T 10 -c --no-check-certificate "http://www.myunmei.com"$img -O $img_file`
            fi
	    #更新数据库 	
            sql="update zmt_media set star_img='"http://.../res/star/star_img/"$id$file_type' where id=$id"
            /phpstudy/mysql/bin/mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${sql}"
        fi
    fi

done
