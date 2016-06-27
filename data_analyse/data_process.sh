#!/bin/bash

source_dir='/home/lzz/soft/mongo_work/source/'
tmp_datas='/home/lzz/soft/mongo_work/tmp_datas/'
log_list=`ls $source_dir`
for f in $log_list
do
	#***********************json and type***********************
	cat $source_dir$f | while read line
	do
	#根据分隔符‘|’ 分割成数组
	OLD_IFS="$IFS" 
	IFS="|" 
	arr=($line) 
	IFS="$OLD_IFS" 
	#第一个元素是类型（比如是购物类型的数据，mongodb集合表示）
	type=${arr[0]}
	unset arr[0]
	
	i=0
	tag=""
	doc=""
	for s in ${arr[@]} 
	do 
		#文档
    		doc=$doc"$tag"'field'"$i:$s"
		((i++))
		tag=","
	done
	line=$doc
	echo "{$line}," >> $tmp_datas"type"$type
	done
	#********************insert mongodb**********************
	filelist=`ls $tmp_datas`
	for file in $filelist
	do
        	log=`sed ':a;N;s/\n/ /g;ta' $tmp_datas$file`
		#批量写入$file 是对应上面的$type
	        sql="db."$file".insert([$log]);"
	     	echo "$sql" | /home/lzz/soft/mongodb-linux-i686-2.4.3/bin/mongo 127.0.0.1:27017/any$f --shell
        	rm $tmp_datas$file
	done

	
done

