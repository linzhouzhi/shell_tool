#!/bin/bash
#����˼·
#ѭ�������ݿ��ȡresouce_id ����paper_logo,����page_pic
#ͨ��wget��ͼƬ���ر��浽�ƶ���Ŀ¼
#�������ݿ��е�ͼƬ��ַ

HOSTNAME="192.168.1.253"
PORT="3306"
USERNAME="..."
PASSWORD="..."
DBNAME="..."
#ͼƬ���·��
IMG="/home/lzz/res/star/star_img/"

sql="select id,star_img from zmt_media WHERE plate<>2"
/phpstudy/mysql/bin/mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${sql}" | while read id img
do
    if [ "$id" != "id" ];then
        if [ "$img"x != 'x' ];then
            file_type=${img:0-4}
            img_file=$IMG$id$file_type
            #����ͼƬ�����������γ�ʱ��10��
            `/usr/bin/wget -t 2 -T 10 -c --no-check-certificate "http://www.myunmei.com"$img -O $img_file`
	    #�ж��ļ��Ĵ�С���������0Ҫ����ץһ��
            if [ $(/usr/bin/stat -c %s $img_file) -eq 0 ];then
            `/usr/bin/wget -t 2 -T 10 -c --no-check-certificate "http://www.myunmei.com"$img -O $img_file`
            fi
	    #�������ݿ� 	
            sql="update zmt_media set star_img='"http://.../res/star/star_img/"$id$file_type' where id=$id"
            /phpstudy/mysql/bin/mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${sql}"
        fi
    fi

done