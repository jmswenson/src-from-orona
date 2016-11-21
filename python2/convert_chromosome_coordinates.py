#!/usr/bin/env python
# run script like: nohup python /Volumes/jswenson/src/python/convert_chromosome_coordinates.py JS001A_alignment.SAM_alignment.sorted.bamsamtools.mpileup.truncated-for-depth-calc--cleaned-and-combined.txt
## script assumes that there is one file as input and the file is in the format: chrom_name <tab> base position <tab> depth at position
print("script assumes that there is one file as input and the file is in the format: chrom_name <tab> base position <tab> depth at position.  Depth field is not important for this script");
print("This could easily be adopted for the format chrom_name <tab> base position start <tab> base position end");

import sys

fh = open(sys.argv[1], 'r') 
outp1 = open(str(sys.argv[1])+'--renamed-to-chromosomes-to-h.txt','w')
print("Done opening file1 and opening output file")
print("Make sure you used the correct coordinates as they differ between S2 and Kc, etc");
# Xh is greater than 21,240,000; 2Lh is greater than 21,090,000; 2Rh is less than 2,500,000; 3Lh is greater than 22,250,000  (for genome Release 5 in S2 cells in Riddle, Minoda paper)
# Xh is greater than 22,360,000; 2Lh is greater than 22,170,000; 2Rh is less than 1,580,000; 3Lh is greater than 23,020,000  (for genome Release 5 in Kc cells in Riddle, Minoda paper)

################### BELOW IS FOR S2 CELLS ############################
####header = fh.readline().strip().split("\t") ## skips the header line
####header = fh.readline().strip().split("\t") ## skips the header line
print("Using S2 borders from release 5 for heterochromatin!!!")
for line1 in fh:
	line = line1.strip().split('\t')
	#psuedocode: IF chromosome name AND in h region for that chromosome
	#THEN rename chromosome name to chromosome nameh, print line with new name
	#ELSE print line with old name
	if str(line[0]) == str("X") and int(line[1]) > 21240000:
		outp1.write("\t".join(["Xh",line[1],line[2]]))
		outp1.write("\n")
	elif str(line[0]) == str("2L") and int(line[1]) > 21090000:
		outp1.write("\t".join(["2Lh",line[1],line[2]]))
		outp1.write("\n")
	elif str(line[0]) == str("2R") and int(line[1]) < 2500000:
		outp1.write("\t".join(["2Rh",line[1],line[2]]))
		outp1.write("\n")
	elif str(line[0]) == str("3L") and int(line[1]) > 22250000:
		outp1.write("\t".join(["3Lh",line[1],line[2]]))
		outp1.write("\n")
	else:
		outp1.write(line1)
outp1.close()
fh.close()
print("Done reading file1 and renaming it where appropriate")
################### ABOVE IS FOR S2 CELLS ############################


################### BELOW IS FOR Kc CELLS ############################
####header = fh.readline().strip().split("\t") ## skips the header line
####header = fh.readline().strip().split("\t") ## skips the header line
# print("Using Kc borders from release 5 for heterochromatin!!!")
# for line1 in fh:
# 	line = line1.strip().split('\t')
# 	#psuedocode: IF chromosome name AND in h region for that chromosome
# 	#THEN rename chromosome name to chromosome nameh, print line with new name
# 	#ELSE print line with old name
# 	if str(line[0]) == str("X") and int(line[1]) > 22360000:
# 		outp1.write("\t".join(["Xh",line[1],line[2]]))
# 		outp1.write("\n")
# 	elif str(line[0]) == str("2L") and int(line[1]) > 22170000:
# 		outp1.write("\t".join(["2Lh",line[1],line[2]]))
# 		outp1.write("\n")
# 	elif str(line[0]) == str("2R") and int(line[1]) < 1580000:
# 		outp1.write("\t".join(["2Rh",line[1],line[2]]))
# 		outp1.write("\n")
# 	elif str(line[0]) == str("3L") and int(line[1]) > 23020000:
# 		outp1.write("\t".join(["3Lh",line[1],line[2]]))
# 		outp1.write("\n")
# 	else:
# 		outp1.write(line1)
# outp1.close()
# fh.close()
# print("Done reading file1 and renaming it where appropriate")
################### ABOVE IS FOR Kc CELLS ############################





