#!/usr/bin/env python
# run script like: python ~/src/python/add_colmn_to_file_if_construct_is_in_other_file.py Expression_Clone_Resources.txt WORKING-LIST__list-of-enriched-hits-with-counts-----with-question-marks.txt 

import sys
fh = open(sys.argv[1], 'r') #....current argument is  ~/../ShareWithGenuser/Joel-combined/HP1a-H3K9me2/gene_only_counted_bottom_10_perc_in_col_rank_norm_chan2.mean.rel_ring4.I

fh.readline().strip().split("\t") ## skips the header line
fh.readline().strip().split("\t") ## skips the header line
fh.readline().strip().split("\t") ## skips the header line
fh.readline().strip().split("\t") ## skips the header line
fh.readline().strip().split("\t") ## skips the header line

cloneinfo={}  ### this will be a dictionary where the key is the gene name
             ### and the value is a list of the whole line
for line1 in fh:
    line = line1.strip().split('\t')
#    print line
#    print len(line)
    if len(line)<6:continue
    gene = line[5].split('-')
    if gene[0] in cloneinfo:
    	cloneinfo[gene[0]].append(line[2])
    else:
    	cloneinfo[gene[0]] = [line[2]]
fh.close()

fh2 = open(sys.argv[2], 'r') #....current argument is  ~/../ShareWithGenuser/Joel-combined/HP1a-H3K9me2/IMAGE_NAMES_cs_top_10_perc_in_col_rank_norm_chan2.mean.rel_ring4.I
header2 = fh2.readline().strip().split("\t"); ## skips the header line
header = ["clone-name__empty-wells-should-be-manually-curated"]
header2.extend(header)
xx = sys.argv[2]
outp = open(xx+'_with_clone_INFO.tab.txt','w')
outp.write('\t'.join(header2))
outp.write('\n')

for row in fh2:
    row1 = row.strip().split('\t')
    print row1[0]
    if row1[0] in cloneinfo:
    	row1.extend(cloneinfo[row1[0]])
    outp.write('\t'.join(row1))
    outp.write('\n')
fh2.close()
outp.close()

