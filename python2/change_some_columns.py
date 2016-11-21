#!/usr/bin/env python
# run script like: nohup python /Volumes/jswenson/src/python/change_some_columns.py myfile.txt
## script assumes that there is one file as input and the file is in the format: chrom_name <tab> gene start position <tab> gene end position <tab> FBgn <tab> gene name
## 			converts it to chrom_name:gene start position..gene end position <tab> FBgn <tab> gene name




print("script assumes that there is one file as input and the file is in the format: chrom_name <tab> gene start position <tab> gene end position <tab> FBgn <tab> gene name.");
print("file format gets changed to chrom_name:gene start position..gene end position <tab> FBgn <tab> gene name. A new file is created with this result with the suffix --renamed-for-conversion_contains-genenames.txt");


####### START HERE############

import sys

fh = open(sys.argv[1], 'r') 
outp1 = open(str(sys.argv[1])+'--renamed-for-conversion_contains-genenames.txt','w')
print("Done opening file1 and opening output file")
for line1 in fh:
	line = line1.strip().split('\t')
	#psuedocode: IF chromosome name AND in h region for that chromosome
	#THEN rename chromosome name to chromosome nameh, print line with new name
	#ELSE print line with old name
	outp1.write("".join([line[0],":",line[1],"..",line[2],"\t",line[3],"\t",line[4]]))
	outp1.write("\n")
outp1.close()
fh.close()
print("Done reading file1 and outputting new columns to outp1")

#		outp1.write("\t".join(["Xh",line[1],line[2]]))





