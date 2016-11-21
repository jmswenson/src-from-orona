#!/bin/bash
#list="ls $1"
echo "Fixing line feeds/return carriage for the following files only:" `grep -l '\r' $@ 2>/dev/null`;
#echo `ls $*`
for j in `grep -l '\r' $@ 2>/dev/null`
	#do echo $j;
	do `perl -p -i -e 's/(\r\r*\n*)/\n/g' $j`
done
