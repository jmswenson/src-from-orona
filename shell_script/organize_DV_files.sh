#!/bin/bash
mkdir projections
mkdir convolved
mkdir deconvolved
mkdir logs_etc
#echo $0 #name of script
#echo $1 #first thing after name of script...can pass in and now it is in $1
#echo $2

for i in `ls *log.txt 2>/dev/null`  
	do mv $i ./logs_etc
done
for i in `ls *status.txt 2>/dev/null`  
	do mv $i ./logs_etc
done
for i in `ls *log 2>/dev/null`  
	do mv $i ./logs_etc
done
for i in `ls *sh 2>/dev/null`  
	do mv $i ./logs_etc
done
for i in `ls *PRJ.dv 2>/dev/null`  
	do mv $i ./projections
done
for i in `ls *R3D.dv 2>/dev/null`  
	do mv $i ./convolved
done
for i in `ls *D3D.dv 2>/dev/null`  
	do mv $i ./deconvolved
done




#for i in `find . -name "*log.txt" 2>/dev/null`  
#	mv $i ./logs_etc
#done
#for i in `find . -name "*status.txt" 2>/dev/null`  
#	mv $i ./logs_etc
#done
#for i in `find . -name "*log" 2>/dev/null`  
#	mv $i ./logs_etc
#done
#for i in `find . -name "*task.sh" 2>/dev/null`  
#	mv $i ./logs_etc
#done
#for i in `find . -name "*PRJ.dv" 2>/dev/null`  
#	mv $i ./projections
#done
#for i in `find . -name "*R3D.dv" 2>/dev/null`  
#	mv $i ./convolved
#done
#for i in `find . -name "*D3D.dv" 2>/dev/null`  
#	mv $i ./deconvolved
#done


