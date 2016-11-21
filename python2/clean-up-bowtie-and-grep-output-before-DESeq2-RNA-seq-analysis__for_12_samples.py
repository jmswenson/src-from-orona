#!/usr/bin/env python
# run script like: python ~/src/python/clean-up-bowtie-and-grep-output-before-DESeq2-RNA-seq-analysis.py *repeats-and-htseq-genes.txt ## script assumes that there are four files
### See /jswenson/Aug-2014-RNA-seq-data/



import sys
fh = open(sys.argv[1], 'r') 

print "CHECK IF THERE ARE ANY BLANK FIELDS IN THE FIRST COLUMN ---blank lines are currently added to dictionary, but not retrieved"
print "Script assumes there is a header, if there isn't a header comment lines starting with header = fh.readline, etc"
print "See near end of script to easily change the order these are outputted in, but make sure header reflects the changes"

allgenes={}  ### this will be a dictionary where the key is the gene name
             ### and the value is 0
file1={}	### this will be a dictionary where the key is the gene name
             ### and the value is the raw number of reads
header = fh.readline().strip().split("\t") ## skips the header line
for line1 in fh:
	line = line1.strip().split('\t')
	allgenes[line[0]] = 0
	file1[line[0]] = line[1]
fh.close()

fh = open(sys.argv[2], 'r') 
file2={}
header = fh.readline().strip().split("\t") ## skips the header line
for line1 in fh:
	line = line1.strip().split('\t')
	allgenes[line[0]] = 0
	file2[line[0]] = line[1]
fh.close()

fh = open(sys.argv[3], 'r') 
file3={}
header = fh.readline().strip().split("\t") ## skips the header line
for line1 in fh:
	line = line1.strip().split('\t')
	allgenes[line[0]] = 0
	file3[line[0]] = line[1]
fh.close()

fh = open(sys.argv[4], 'r') 
file4={}
header = fh.readline().strip().split("\t") ## skips the header line
for line1 in fh:
	line = line1.strip().split('\t')
	allgenes[line[0]] = 0
	file4[line[0]] = line[1]
fh.close()


fh = open(sys.argv[5], 'r') 
file5={}
header = fh.readline().strip().split("\t") ## skips the header line
for line1 in fh:
	line = line1.strip().split('\t')
	allgenes[line[0]] = 0
	file5[line[0]] = line[1]
fh.close()

fh = open(sys.argv[6], 'r') 
file6={}
header = fh.readline().strip().split("\t") ## skips the header line
for line1 in fh:
	line = line1.strip().split('\t')
	allgenes[line[0]] = 0
	file6[line[0]] = line[1]
fh.close()


fh = open(sys.argv[7], 'r') 
file7={}
header = fh.readline().strip().split("\t") ## skips the header line
for line1 in fh:
	line = line1.strip().split('\t')
	allgenes[line[0]] = 0
	file7[line[0]] = line[1]
fh.close()

fh = open(sys.argv[8], 'r') 
file8={}
header = fh.readline().strip().split("\t") ## skips the header line
for line1 in fh:
	line = line1.strip().split('\t')
	allgenes[line[0]] = 0
	file8[line[0]] = line[1]
fh.close()

fh = open(sys.argv[9], 'r') 
file9={}
header = fh.readline().strip().split("\t") ## skips the header line
for line1 in fh:
	line = line1.strip().split('\t')
	allgenes[line[0]] = 0
	file9[line[0]] = line[1]
fh.close()


fh = open(sys.argv[10], 'r') 
file10={}
header = fh.readline().strip().split("\t") ## skips the header line
for line1 in fh:
	line = line1.strip().split('\t')
	allgenes[line[0]] = 0
	file10[line[0]] = line[1]
fh.close()

fh = open(sys.argv[11], 'r') 
file11={}
header = fh.readline().strip().split("\t") ## skips the header line
for line1 in fh:
	line = line1.strip().split('\t')
	allgenes[line[0]] = 0
	file11[line[0]] = line[1]
fh.close()

fh = open(sys.argv[12], 'r') 
file12={}
header = fh.readline().strip().split("\t") ## skips the header line
for line1 in fh:
	line = line1.strip().split('\t')
	allgenes[line[0]] = 0
	file12[line[0]] = line[1]
fh.close()

#############################################
header = [sys.argv[2]]
header.append(sys.argv[4])
header.append(sys.argv[1])
header.append(sys.argv[3])
header.append(sys.argv[5])
header.append(sys.argv[6])
header.append(sys.argv[7])
header.append(sys.argv[8])
header.append(sys.argv[9])
header.append(sys.argv[10])
header.append(sys.argv[11])
header.append(sys.argv[12])
outp = open('cleaned-and-combined.txt','w')
outp.write('\t'.join(header))
outp.write('\n')

sorted_all_genes=sorted(allgenes.keys())

for gene in sorted_all_genes:
	outp.write(str(gene))
	outp.write("\t")
	if gene in file2:
		outp.write(str(file2[gene]))
		outp.write("\t")
	else:
		outp.write(str(allgenes[gene])) ## This could also be written outp.write("0","\t")
		outp.write("\t")
	if gene in file4:
		outp.write(str(file4[gene]))
		outp.write("\t")
	else:
		outp.write(str(allgenes[gene])) ## This could also be written outp.write("0","\t")
		outp.write("\t")
	if gene in file1:
		outp.write(str(file1[gene]))
		outp.write("\t")
	else:
		outp.write(str(allgenes[gene])) ## This could also be written outp.write("0","\t")
		outp.write("\t")
	if gene in file3:
		outp.write(str(file3[gene]))
		outp.write("\t")
	else:
		outp.write(str(allgenes[gene])) ## This could also be written outp.write("0","\t")
		outp.write("\t")
	if gene in file5:
		outp.write(str(file5[gene]))
		outp.write("\t")
	else:
		outp.write(str(allgenes[gene])) ## This could also be written outp.write("0","\t")
		outp.write("\t")
	if gene in file6:
		outp.write(str(file6[gene]))
		outp.write("\t")
	else:
		outp.write(str(allgenes[gene])) ## This could also be written outp.write("0","\t")
		outp.write("\t")
	if gene in file7:
		outp.write(str(file7[gene]))
		outp.write("\t")
	else:
		outp.write(str(allgenes[gene])) ## This could also be written outp.write("0","\t")
		outp.write("\t")
	if gene in file8:
		outp.write(str(file8[gene]))
		outp.write("\t")
	else:
		outp.write(str(allgenes[gene])) ## This could also be written outp.write("0","\t")
		outp.write("\t")
	if gene in file9:
		outp.write(str(file9[gene]))
		outp.write("\t")
	else:
		outp.write(str(allgenes[gene])) ## This could also be written outp.write("0","\t")
		outp.write("\t")
	if gene in file10:
		outp.write(str(file10[gene]))
		outp.write("\t")
	else:
		outp.write(str(allgenes[gene])) ## This could also be written outp.write("0","\t")
		outp.write("\t")
	if gene in file11:
		outp.write(str(file11[gene]))
		outp.write("\t")
	else:
		outp.write(str(allgenes[gene])) ## This could also be written outp.write("0","\t")
		outp.write("\t")
	if gene in file12:
		outp.write(str(file12[gene]))
		outp.write("\n")
	else:
		outp.write(str(allgenes[gene])) ## This could also be written outp.write("0","\t")
		outp.write("\n")
outp.close()

