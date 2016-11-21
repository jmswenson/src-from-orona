#!/usr/bin/env python
# run script like: nohup python ../../src/python/clean-up-mpileup-output-so-each-base-is-represented__hopefully-faster.py EE00*mpileup.truncated*& ## script assumes that there are four files
### See /jswenson/Aug-2014-ChIP-seq-data/

#### used unix to combine all the files and then eliminate duplicate coordinates, finally ordered it first based on the first column and then based on the second column
# cat *mpileup.trun*|cut -f1,2|sort -u|sort -s -n -k 1,1 -k 2,2>uniq-chrom-and-coords__from-mpileup.truncated__.txt

import sys

print "CHECK IF THERE ARE ANY BLANK FIELDS IN THE FIRST COLUMN ---blank lines are currently added to dictionary, but not retrieved"
print "Script assumes there are no header lines in each mpileup file, if there are headers uncomment lines starting with header = fh.readline, etc"
print "See near end of script to easily change the order these are outputted in, but make sure header reflects the changes"

##########Plan (that I didn't follow): build two dictionaries, one with "everything" and the "other" with each file.  
##########Then make keys into tuples and output to a variable things in "everything" not in "other".
##########Now add the missing keys to the "other" with a value of 0....I decided against the tuple idea because I just recode this faster as a first check

allcoords={}  ### this will be a dictionary where the key is the gene name
######### Open file containing all coordinates that each file needs to have and make it into a dictionary
#fhall = open("uniq-chrom-and-coords__from-mpileup.truncated__test.txt", 'r') 
fhall = open("uniq-chrom-and-coords__from-mpileup.truncated__.txt", 'r') 
for line1 in fhall:
	line = line1.strip().split('\t')
	allcoords[(line[0],line[1])] = 0
fhall.close()
print("Done reading everything file and done turning it into a dictionary.......probably don't need to make this into a dictionary actually, just a tuple")
#allcotup = tuple(allcoords.keys()) ### This is a tuple of tuples

###### To get to here with uniq-chrom-and-coords__from-mpileup.truncated__.txt being 1.3G took  47 minutes


file1={}	### this will be a dictionary where the key is tuple of chromosome name and coordinate
             ### and the value is the depth at that postion
fh = open(sys.argv[1], 'r') 
#header = fh.readline().strip().split("\t") ## skips the header line
#header = fh.readline().strip().split("\t") ## skips the header line
for line1 in fh:
	line = line1.strip().split('\t')
	file1[(line[0],line[1])] = line[2]
fh.close()
print("Done reading file1 and turning it into a dictionary")

outp1 = open(str(sys.argv[1])+'--cleaned-and-combined.txt','w')
for gene in allcoords:
	outp1.write("\t".join([str(i) for i in gene]))
	outp1.write("\t")
	if gene in file1:
		outp1.write(str(file1[gene]))
		outp1.write("\n")
	else:
		outp1.write(str(allcoords[gene])) ## This could also be written outp.write("0","\t")
		outp1.write("\n")
outp1.close()
file1={}
print("Done filling in file1 and purging its dictionary")


file2={}	### this will be a dictionary where the key is tuple of chromosome name and coordinate
             ### and the value is the depth at that postion
fh = open(sys.argv[2], 'r') 
#header = fh.readline().strip().split("\t") ## skips the header line
#header = fh.readline().strip().split("\t") ## skips the header line
for line1 in fh:
	line = line1.strip().split('\t')
	file2[(line[0],line[1])] = line[2]
fh.close()
print("Done reading file2 and turning it into a dictionary")

outp2 = open(str(sys.argv[2])+'--cleaned-and-combined.txt','w')
for gene in allcoords:
	outp2.write("\t".join([str(i) for i in gene]))
	outp2.write("\t")
	if gene in file2:
		outp2.write(str(file2[gene]))
		outp2.write("\n")
	else:
		outp2.write(str(allcoords[gene])) ## This could also be written outp.write("0","\t")
		outp2.write("\n")
outp2.close()
file2={}
print("Done filling in file2 and purging its dictionaries")


file3={}	### this will be a dictionary where the key is tuple of chromosome name and coordinate
             ### and the value is the depth at that postion
fh = open(sys.argv[3], 'r') 
#header = fh.readline().strip().split("\t") ## skips the header line
#header = fh.readline().strip().split("\t") ## skips the header line
for line1 in fh:
	line = line1.strip().split('\t')
	file3[(line[0],line[1])] = line[2]
fh.close()
print("Done reading file3 and turning it into a dictionary")

outp3 = open(str(sys.argv[3])+'--cleaned-and-combined.txt','w')
for gene in allcoords:
	outp3.write("\t".join([str(i) for i in gene]))
	outp3.write("\t")
	if gene in file3:
		outp3.write(str(file3[gene]))
		outp3.write("\n")
	else:
		outp3.write(str(allcoords[gene])) ## This could also be written outp.write("0","\t")
		outp3.write("\n")
outp3.close()
file3={}
print("Done filling in file3 and purging its dictionaries")


file4={}	### this will be a dictionary where the key is tuple of chromosome name and coordinate
             ### and the value is the depth at that postion
fh = open(sys.argv[4], 'r') 
#header = fh.readline().strip().split("\t") ## skips the header line
#header = fh.readline().strip().split("\t") ## skips the header line
for line1 in fh:
	line = line1.strip().split('\t')
	file4[(line[0],line[1])] = line[2]
fh.close()
print("Done reading file4 and turning it into a dictionary")

outp4 = open(str(sys.argv[4])+'--cleaned-and-combined.txt','w')
for gene in allcoords:
	outp4.write("\t".join([str(i) for i in gene]))
	outp4.write("\t")
	if gene in file4:
		outp4.write(str(file4[gene]))
		outp4.write("\n")
	else:
		outp4.write(str(allcoords[gene])) ## This could also be written outp.write("0","\t")
		outp4.write("\n")
outp4.close()
file4={}
print("Done filling in file4 and purging its dictionaries")


print("Remember all these output files are unsorted...might want to sort them like sort -s -n -k 1,1 -k 2,2")

