#!/bin/bash
list="ls $1"
echo "CONSIDER USING fancy_fix_line_feeds.sh AS IT WILL ONLY MODIFY FILES IF THEY HAVE '\r' AND SHOULD THEREFORE BE QUICKER";
echo "Fixing line feeds/return carriage for the following files only:" $@
for j in `ls $@ 2>/dev/null`
	do `perl -p -i -e 's/(\r\r*\n*)/\n/g' $j`
done
