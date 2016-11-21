#!/usr/bin/env python
# run script like: python ~/src/python/clean-up-mpileup-output-so-each-base-is-represented.py *mpileup.truncated* ## script assumes that there are four files
### See /jswenson/Aug-2014-ChIP-seq-data/



import sys
fh = open(sys.argv[1], 'r') 

print "CHECK IF THERE ARE ANY BLANK FIELDS IN THE FIRST COLUMN ---blank lines are currently added to dictionary, but not retrieved"
print "Script assumes there are two header lines, if there aren't headers uncomment lines starting with header = fh.readline, etc"
print "See near end of script to easily change the order these are outputted in, but make sure header reflects the changes"

allgenes={}  ### this will be a dictionary where the key is the gene name
             ### and the value is 0
file1={}	### this will be a dictionary where the key is the gene name
             ### and the value is the raw number of reads
header = fh.readline().strip().split("\t") ## skips the header line
header = fh.readline().strip().split("\t") ## skips the header line
for line1 in fh:
	line = line1.strip().split('\t')
	allgenes[(line[0],line[1])] = 0
	file1[(line[0],line[1])] = line[2]
fh.close()

fh = open(sys.argv[2], 'r') 
file2={}
header = fh.readline().strip().split("\t") ## skips the header line
header = fh.readline().strip().split("\t") ## skips the header line
for line1 in fh:
	line = line1.strip().split('\t')
	allgenes[(line[0],line[1])] = 0
	file2[(line[0],line[1])] = line[2]
fh.close()

fh = open(sys.argv[3], 'r') 
file3={}
header = fh.readline().strip().split("\t") ## skips the header line
header = fh.readline().strip().split("\t") ## skips the header line
for line1 in fh:
	line = line1.strip().split('\t')
	allgenes[(line[0],line[1])] = 0
	file3[(line[0],line[1])] = line[2]
fh.close()

fh = open(sys.argv[4], 'r') 
file4={}
header = fh.readline().strip().split("\t") ## skips the header line
header = fh.readline().strip().split("\t") ## skips the header line
for line1 in fh:
	line = line1.strip().split('\t')
	allgenes[(line[0],line[1])] = 0
	file4[(line[0],line[1])] = line[2]
fh.close()

outp1 = open(str(sys.argv[1])+'cleaned-and-combined.txt','w')
outp2 = open(str(sys.argv[2])+'cleaned-and-combined.txt','w')
outp3 = open(str(sys.argv[3])+'cleaned-and-combined.txt','w')
outp4 = open(str(sys.argv[4])+'cleaned-and-combined.txt','w')

sorted_all_genes=sorted(allgenes.keys())

for gene in sorted_all_genes:
	outp1.write(str(gene))
	outp1.write("\t")
	outp2.write(str(gene))
	outp2.write("\t")
	outp3.write(str(gene))
	outp3.write("\t")
	outp4.write(str(gene))
	outp4.write("\t")
	if gene in file2:
		outp2.write(str(file2[gene]))
		outp2.write("\n")
	else:
		outp2.write(str(allgenes[gene])) ## This could also be written outp.write("0","\t")
		outp2.write("\n")
	if gene in file4:
		outp4.write(str(file4[gene]))
		outp4.write("\n")
	else:
		outp4.write(str(allgenes[gene])) ## This could also be written outp.write("0","\t")
		outp4.write("\n")
	if gene in file1:
		outp1.write(str(file1[gene]))
		outp1.write("\n")
	else:
		outp1.write(str(allgenes[gene])) ## This could also be written outp.write("0","\t")
		outp1.write("\n")
	if gene in file3:
		outp3.write(str(file3[gene]))
		outp3.write("\n")
	else:
		outp3.write(str(allgenes[gene])) ## This could also be written outp.write("0","\t")
		outp3.write("\n")
outp1.close()
outp2.close()
outp3.close()
outp4.close()

