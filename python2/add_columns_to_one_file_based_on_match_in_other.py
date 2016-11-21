#!/usr/bin/env python
# run script like: python ~/src/python/match_screen_names_to_data.py assay*robust*csv
### This script reads in the 'gene_only_counted_bottom_10_perc_in_col_rank_norm_chan2.mean.rel_ring4.I' file which is outputted from ~/src/R_scripts/simple_find_top_and_bottom_perc.R.  It creates a dictionary using information from this file.

### Next the 'IMAGE_NAMES_cs_top_10_perc_in_col_rank_norm_chan2.mean.rel_ring4.I' file generated from the same R code above is read in.  I output this data file with information added to it.


import sys
fh = open(sys.argv[1], 'r') #....current argument is  ~/../ShareWithGenuser/Joel-combined/HP1a-H3K9me2/gene_only_counted_bottom_10_perc_in_col_rank_norm_chan2.mean.rel_ring4.I

header = fh.readline().strip().split("\t") ## skips the header line
print "CHECK IF THERE ARE ANY BLANK FIELDS IN THE FIRST COLUMN ---blank lines are currently added to dictionary, but not retrieved"

wellinfo={}  ### this will be a dictionary where the key is the gene name
             ### and the value is a list of the whole line
for line1 in fh:
    line = line1.strip().split('\t')
    #    if line[0]=='568':continue   ##There is a blank field in the first column which gets stripped
    print line[0]
    wellinfo[line[0]] = line  
fh.close()

fh2 = open(sys.argv[2], 'r') #....current argument is  ~/../ShareWithGenuser/Joel-combined/HP1a-H3K9me2/IMAGE_NAMES_cs_top_10_perc_in_col_rank_norm_chan2.mean.rel_ring4.I
header2 = fh2.readline().strip().split("\t"); ## skips the header line
header2.extend(header)
xx = sys.argv[2]
outp = open(xx+'_with_ALL_INFO.tab.txt','w')
outp.write('\t'.join(header))

for row in fh2:
    #plindex = header.index('plate_name')
    row1 = row.strip().split('\t')
    if row1[1]=='':continue
    row1.extend(wellinfo[row1[1]])
    #    print row1
    outp.write('\t'.join(row1))
fh2.close()
outp.close()

