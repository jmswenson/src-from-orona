#!/usr/bin/env python
# run script like: python /Volumes/jswenson/src/python/print_if_in_other_file.py ../found-in-at-least-two.FBgn.txt only_interactions_from_all-DroID-PPIs.txt
## above example run in this directory: /Users/joel/Documents/1-2013-and-old-mass-spec-HP1a-purifications-after-damage/lots_mods_analysis/8-1-13_analysis_for_picking_FMOs---and-thesis-venn-cytoscape/named_files_for_venn_diagram--and-part-of-thesis-analysis-including-cytospace/DroID_data/PPI
# run script like: python /Volumes/jswenson/src/python/print_if_in_other_file__DroID-cytoscape-script.py found-in-at-least-two.FBnames-ribo-removed-FbGn-names.txt genetic_and_PPI-interactions-from_DroID.uniq.txt
import sys
fh = open(sys.argv[1], 'r') 

#header = fh.readline().strip().split("\t") ## skips the header line
inms={} # Make a dictionary for each IP-MS hit, the key and value are the hit
for line1 in fh:
    line = line1.strip().split('\t')
    inms[line[0]]  = line[0]
fh.close()

fh2 = open(sys.argv[2], 'r') 
header2 = fh2.readline().strip().split("\t"); ## skips the header line
xx = sys.argv[1]
#outp = open(xx+'_and_DroID-PPI.tab.txt','w')
#outp = open(xx+'_and_DroID-PPI-ALL-SPECIES.tab.txt','w')
outp = open(xx+'_and_DroID-PPI-and-genetic-interactions.tab.txt','w')
outp.write('\t'.join(header2))
outp.write('\n')

inmsandppi={}  #If both the bait and prety were in my MS add it to this new dictonary
for row in fh2:
    row1 = row.strip().split('\t')
    if row1[0] in inms and row1[1] in inms:
    	inmsandppi[row1[0]] = row1[0] # If both the bait and prety were in my MS make it to this new dictonary
    	inmsandppi[row1[1]] = row1[1]
    	outp.write('\t'.join(row1))   # If both the bait and prety were in my MS write it to the output file
    	outp.write('\n')
fh2.close()
outp.close()

#outp = open(xx+'_and_NOT-IN_DroID-PPI.tab.txt','w')
#outp = open(xx+'_and_NOT-IN_DroID-PPI-ALL-SPECIES.tab.txt','w')
outp = open(xx+'_and_NOT-IN_DroID-PPI-and-genetic-interactions.tab.txt','w')
outp.write('\t'.join(header2))
outp.write('\n')
#for key, value in inms.iteritems:
for key in inms:
    if key not in inmsandppi:	
    	outp.write("\t".join([key,inms[key]]))  # If MS hit was NOT found in both a bait and prey above print it to new output
    	outp.write('\n')
outp.close()
