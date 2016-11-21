#!/usr/bin/env python
# run script like: python ~/src/python/match_screen_names_to_data.py assay*robust*csv

print "CHECK IF THERE ARE ANY BLANK FIELDS IN THE FIRST COLUMN ---blank lines are currently added to dictionary, but not retrieved"
print "MAKE sure control is first file and experiment is second"
print "Check that subtracting log2 values is what you want to do AND that you want to handle missing values by subtracting 0"

import sys
fh = open(sys.argv[1], 'r') #....current argument is  ~/../ShareWithGenuser/Joel-combined/HP1a-H3K9me2/gene_only_counted_bottom_10_perc_in_col_rank_norm_chan2.mean.rel_ring4.I

header = fh.readline().strip().split("\t") ## skips the header line

G1dict={}  ### this will be a dictionary where the key is the chromosome name, start coord, end coord, and log2 enrichment is the value.  For GFP ChIP.
for line1 in fh:
    line = line1.strip().split('\t')
    G1dict[line[0],line[1],line[2]] = line[3]  
fh.close()

fh2 = open(sys.argv[2], 'r') #....current argument is  ~/../ShareWithGenuser/Joel-combined/HP1a-H3K9me2/IMAGE_NAMES_cs_top_10_perc_in_col_rank_norm_chan2.mean.rel_ring4.I
header2 = fh2.readline().strip().split("\t"); ## skips the header line
xx = sys.argv[2]
outp = open(xx+'_with_control_subtracted.wig','w')
outp.write('\t'.join(header2))
outp.write('\n')

for lineC1 in fh2:
    lineC = lineC1.strip().split('\t')
    if (lineC[0],lineC[1],lineC[2]) in G1dict.keys():
    	newval = float(lineC[3]) - float(G1dict[lineC[0],lineC[1],lineC[2]])
    else:
    	newval = float(lineC[3]) - float(0) # This '-0' isn't necessary but is included in case I need to subtract something other than 0 (e.g. 1)
    outp.write('\t'.join([lineC[0],lineC[1],lineC[2],str(newval)]))
    outp.write('\n')
fh2.close()
outp.close()

