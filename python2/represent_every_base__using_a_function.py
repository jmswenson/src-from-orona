#!/usr/bin/env python
# run script like: nohup python /Volumes/jswenson/src/python/represent_every_base.py JS001A_alignment.SAM_alignment.sorted.bamsamtools.mpileup.truncated-for-depth-calc--cleaned-and-combined.txt--renamed-to-chromosomes-to-h.txt_sorted.txt
## script assumes that there is one file as input and the file is in the format: chrom_name <tab> base position <tab> depth at position

print("See unix code within this script to determine the maximum and minimum coordinate per region....probably want to check that it is the same for each experimental set");
############ Chromosome region start and stop coordinates were found with the following unix code:
## touch tmpout.delete;touch starting_and_ending_coords.txt;
## for i in $(cut -f1 JS001A_*sorted.txt |sort -u);
## do rm tmpout.delete; grep '^'$i'<control+v+tab>' JS001A_*sorted.txt>tmpout.delete;
## head -n1 tmpout.delete>>starting_and_ending_coords.txt;tail -n1 tmpout.delete>>starting_and_ending_coords.txt;done;rm tmpout.delete ;
##### Note that the above unix code would be quicker if instead of JS001A_*sorted.txt I instead just used one sorted file (I just have to make sure that all the files have the same starting and ending coordinates)
############ UNIX code is above.....note that you can't just copy the above you need to insert a tab where it says <control+v+tab>.  Also make sure starting_and_ending_coords.txt doesn't already exist as this will lead to duplicated output.
############ OUTPUT FROM UNIX IS BELOW for 11-17-14 HP1a ChIP-seq NO RNAi: NOTE THAT COLUMN 1 IS CHROMOSOME, COLUMN 2 IS THE COORDINATE, COLUMN 3 IS THE DEPTH AND ISN'T RELEVANT FOR THIS
# 2L	5088	0
# 2L	21090000	4
# 2Lh	21090001	4
# 2Lh	23010778	0
# 2LHet	8091	0
# 2LHet	368167	0
# 2R	2500000	5
# 2R	21146038	0
# 2Rh	3280	0
# 2Rh	2499999	5
# 2RHet	1	0
# 2RHet	3277273	0
# 3L	19918	0
# 3L	22250000	1
# 3Lh	22250001	1
# 3Lh	24537095	0
# 3LHet	4485	0
# 3LHet	2554388	0
# 3R	2	2
# 3R	27898777	0
# 3RHet	2	0
# 3RHet	2517507	0
# 4	26878	0
# 4	1321730	0
# dmel_mitochondrion_genome	622	0
# dmel_mitochondrion_genome	19517	0
# U	2010	0
# U	10048639	0
# Uextra	569	0
# Uextra	29003339	0
# X	6677	0
# X	21240000	7
# Xh	21240001	7
# Xh	22422366	0
# XHet	621	0
# XHet	197325	0
# YHet	2898	0
# YHet	346965	0
############ OUTPUT FROM UNIX IS ABOVE

### Open the file and the output file
import sys
fh = open(sys.argv[1], 'r') 
outp1 = open(str(sys.argv[1])+'--zerod.txt','w')
print("Done opening file1 and opening output file")


### Create a function to fill in missing coordinates with a zero
def fill_in_gaps(line_info,chrm_name,lowest_coor,highest_coor,prev_coor):
	line = line_info.strip().split('\t')
	if str(line[0]) == str(chrm_name):
		if int(line[1]) == lowest_coor or int(line[1]) == highest_coor:
			outp1.write(line_info)
		elif prev_coor == "NA":
			print("DUNG.  An NA CASE EXISTS I DIDN'T THINK OF...FIX YOUR THINKING AND THEN YOUR CODE")
		elif prev_coor == int(line[1]) - 1:
			outp1.write(line_info)
		elif int(line[1]) > prev_coor + 1:
			for i in range(prev_coor + 1, int(line[1]) +1, 1):
				outp1.write("\t".join([str(chrm_name),str(i),"0"]))
				outp1.write('\n')
		else:
			print("CRAP.  A CASE EXISTS I DIDN'T THINK OF...FIX YOUR THINKING AND THEN YOUR CODE")
	return line



# print("Using coordinates for 11-17-14 HP1a ChIP-seq NO RNAi....make sure this is valid for your experiment")
# prev="NA"
# for line1 in fh:
# 	splt_line = fill_in_gaps(line1,"2L",5088,21090000,prev)
# 	splt_line = fill_in_gaps(line1,"2Lh",21090001,23010778,prev)
# 	splt_line = fill_in_gaps(line1,"2LHet",8091,368167,prev)
# 	splt_line = fill_in_gaps(line1,"2R",2500000,21146038,prev)
# 	splt_line = fill_in_gaps(line1,"2Rh",3280,21146038,prev)
# 	splt_line = fill_in_gaps(line1,"2RHet",1,3277273,prev)
# 	splt_line = fill_in_gaps(line1,"3L",19918,22250000,prev)
# 	splt_line = fill_in_gaps(line1,"3Lh",22250001,24537095,prev)
# 	splt_line = fill_in_gaps(line1,"3LHet",4485,2554388,prev)
# 	splt_line = fill_in_gaps(line1,"3R",2,27898777,prev)
# 	splt_line = fill_in_gaps(line1,"3RHet",2,2517507,prev)
# 	splt_line = fill_in_gaps(line1,"4",26878,1321730,prev)
# 	splt_line = fill_in_gaps(line1,"dmel_mitochondrion_genome",622,19517,prev)
# 	splt_line = fill_in_gaps(line1,"U",2010,10048639,prev)
# 	splt_line = fill_in_gaps(line1,"Uextra",569,29003339,prev)
# 	splt_line = fill_in_gaps(line1,"X",6677,21240000,prev)
# 	splt_line = fill_in_gaps(line1,"Xh",22386737,22422366,prev)
# 	splt_line = fill_in_gaps(line1,"XHet",621,197325,prev)
# 	splt_line = fill_in_gaps(line1,"YHet",2898,346965,prev)
# 	prev = int(splt_line[1])
# outp1.close()
# fh.close()
# print("Done reading file1 and filling it in with 0s where appropriate")
####################################################################################

# print("Using coordinates for Serafin's KDM4A ChIP-seq....make sure this is valid for your experiment")
# prev="NA"
# for line1 in fh:
# 	splt_line = fill_in_gaps(line1,"2L",9814,22170000,prev)
# 	splt_line = fill_in_gaps(line1,"2Lh",22170001,23003823,prev)
# 	splt_line = fill_in_gaps(line1,"2LHet",12626,368156,prev)
# 	splt_line = fill_in_gaps(line1,"2R",1580000,21140522,prev)
# 	splt_line = fill_in_gaps(line1,"2Rh",3294,1579999,prev)
# 	splt_line = fill_in_gaps(line1,"2RHet",14,3280730,prev)
# 	splt_line = fill_in_gaps(line1,"3L",52285,23020000,prev)
# 	splt_line = fill_in_gaps(line1,"3Lh",23020001,24535757,prev)
# 	splt_line = fill_in_gaps(line1,"3LHet",4602,2549248,prev)
# 	splt_line = fill_in_gaps(line1,"3R",2,27898743,prev)
# 	splt_line = fill_in_gaps(line1,"3RHet",5,2517501,prev)
# 	splt_line = fill_in_gaps(line1,"4",26924,1285200,prev)
# 	splt_line = fill_in_gaps(line1,"dmel_mitochondrion_genome",661,19515,prev)
# 	splt_line = fill_in_gaps(line1,"U",3505,10048569,prev)
# 	splt_line = fill_in_gaps(line1,"Uextra",855,29002809,prev)
# 	splt_line = fill_in_gaps(line1,"X",8233,22360000,prev)
# 	splt_line = fill_in_gaps(line1,"Xh",22360001,22422320,prev)
# 	splt_line = fill_in_gaps(line1,"XHet",622,189936,prev)
# 	splt_line = fill_in_gaps(line1,"YHet",13605,318562,prev)
# 	prev = int(splt_line[1])
# outp1.close()
# fh.close()
# print("Done reading file1 and filling it in with 0s where appropriate")
####################################################################################


# print("Using coordinates for CG8108 reads filtered ChIP-seq....make sure this is valid for your experiment")
# prev="NA"
# for line1 in fh:
# 	splt_line = fill_in_gaps(line1,"2L",5110,21090000,prev)
# 	splt_line = fill_in_gaps(line1,"2Lh",21090001,23003877,prev)
# 	splt_line = fill_in_gaps(line1,"2LHet",12621,368167,prev)
# 	splt_line = fill_in_gaps(line1,"2R",2500000,21145569,prev)
# 	splt_line = fill_in_gaps(line1,"2Rh",3294,2499999,prev)
# 	splt_line = fill_in_gaps(line1,"2RHet",9,3277273,prev)
# 	splt_line = fill_in_gaps(line1,"3L",41823,22250000,prev)
# 	splt_line = fill_in_gaps(line1,"3Lh",22250001,24537070,prev)
# 	splt_line = fill_in_gaps(line1,"3LHet",4476,2549248,prev)
# 	splt_line = fill_in_gaps(line1,"3R",6,27898777,prev)
# 	splt_line = fill_in_gaps(line1,"3RHet",13,2517506,prev)
# 	splt_line = fill_in_gaps(line1,"4",26926,1321755,prev)
# 	splt_line = fill_in_gaps(line1,"dmel_mitochondrion_genome",635,19513,prev)
# 	splt_line = fill_in_gaps(line1,"U",3505,10046460,prev)
# 	splt_line = fill_in_gaps(line1,"Uextra",857,29002803,prev)
# 	splt_line = fill_in_gaps(line1,"X",7410,21240000,prev)
# 	splt_line = fill_in_gaps(line1,"Xh",21240001,22422321,prev)
# 	splt_line = fill_in_gaps(line1,"XHet",623,191350,prev)
# 	splt_line = fill_in_gaps(line1,"YHet",13612,318561,prev)
# 	prev = int(splt_line[1])
# outp1.close()
# fh.close()
# print("Done reading file1 and filling it in with 0s where appropriate")
####################################################################################


print("Using coordinates for Serafin's S2 FLAG ChIP-seq reads....make sure this is valid for your experiment")
prev="NA"
for line1 in fh:
	splt_line = fill_in_gaps(line1,"2L",5088,21090000,prev)
	splt_line = fill_in_gaps(line1,"2Lh",21090001,23002745,prev)
	splt_line = fill_in_gaps(line1,"2LHet",12620,368148,prev)
	splt_line = fill_in_gaps(line1,"2R",2500000,21145568,prev)
	splt_line = fill_in_gaps(line1,"2Rh",10110,2499999,prev)
	splt_line = fill_in_gaps(line1,"2RHet",12,3277262,prev)
	splt_line = fill_in_gaps(line1,"3L",41820,22250000,prev)
	splt_line = fill_in_gaps(line1,"3Lh",22250001,24537077,prev)
	splt_line = fill_in_gaps(line1,"3LHet",4599,2549728,prev)
	splt_line = fill_in_gaps(line1,"3R",5,27898776,prev)
	splt_line = fill_in_gaps(line1,"3RHet",2,2517506,prev)
	splt_line = fill_in_gaps(line1,"4",26971,1320333,prev)
	splt_line = fill_in_gaps(line1,"dmel_mitochondrion_genome",661,195050,prev)
	splt_line = fill_in_gaps(line1,"U",3507,10046449,prev)
	splt_line = fill_in_gaps(line1,"Uextra",749,28997999,prev)
	splt_line = fill_in_gaps(line1,"X",8702,21240000,prev)
	splt_line = fill_in_gaps(line1,"Xh",21240001,22422344,prev)
	splt_line = fill_in_gaps(line1,"XHet",624,189912,prev)
	splt_line = fill_in_gaps(line1,"YHet",44014,318561,prev)
	prev = int(splt_line[1])
outp1.close()
fh.close()
print("Done reading file1 and filling it in with 0s where appropriate")
####################################################################################

