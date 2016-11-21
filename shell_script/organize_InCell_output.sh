#!/bin/bash
mkdir misc_hists_and_barcharts
mkdir pearson_hists
mkdir statistics
mkdir scatterplots
#echo $0 #name of script
#echo $1 #first thing after name of script...can pass in and now it is in $1
#echo $2

OLD_IFS=$IFS
IFS=$'\n'

for i in `ls Pearson*hist.pdf 2>/dev/null`  
	do mv $i ./pearson_hists
done
for i in `ls *-hist.pdf 2>/dev/null`  
	do mv $i ./misc_hists_and_barcharts
done
for i in `ls *-scatter.pdf 2>/dev/null`  
	do mv $i ./scatterplots
done
mv HeatMap*pdf ./scatterplots
mv *labels_in-order.txt ./scatterplots
cat *-statistics*tab.txt>all_statistics.txt
for i in `ls *statistics*txt 2>/dev/null`  
	do mv $i ./statistics
done

IFS=$OLD_IFS  # I think default should be IFS=$' \t\n'
###   http://www.unixcl.com/2009/12/bash-cat-command-space-issue-explained.html
