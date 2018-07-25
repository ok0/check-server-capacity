#!/bin/bash

server=`hostname -I`
str=`df -k | awk {'print $5$6'} | sed 's/Use%Mounted//g'`
max=85

for temp in `echo $str`
do

	num=`expr index $temp %`
	value=`expr substr $temp 1 $num |sed 's/%//g'`
	result_bool=""
	
	if [ "$value" -gt "$max" ]
	then
		#echo "$value"
		length=`expr ${#temp}`
		let "start = $num+1"
		let "count =$length-$num+1"
		dir=`expr substr $temp $start $count`
		used=$value
		#result="$result [\"$dir\" used=$used]"
		result_bool="true"
	fi
	
	if [ "$result_bool" = "true" ]
	then
		curl -X POST -d "server=$server&part=$dir&used=$used" ___PUT_YOUR_SERVER_ADDRESS___
	fi
done
