import sys
fh = open(sys.argv[1], 'r') #is [1] because it skips the python script name....
                            #ofint = [7,8,9,10,15,16,17,18,19,20,25,30]
for i,line in enumerate(fh):
    line1 = line.strip().split('\t')
    line2 = line1[:5] # always want first four element
    line2.insert(0,line1[-1])
    line2.insert(0,line1[-2])
    line2.insert(0,line1[-3])
    if i ==0:
        mm = [line1.index('rank_norm_Pearson.chan1...chan2'),line1.index('rank_norm_chan1.mean.intensity'),line1.index('rank_norm_chan2.mean.intensity'),line1.index('rank_norm_chan2.Skew.intensity'),line1.index('rank_norm_rel_chan2.max.I'),line1.index('rank_norm_rel_chan2.min.I'),line1.index('rank_norm_chan2.mean.rel_ring1.I'),line1.index('rank_norm_chan2.mean.rel_ring4.I')]
        #mm = [(line1[line1.index('rank_norm_Pearson.chan1...chan2')]),(line1[line1.index('rank_norm_chan1.mean.intensity')]),(line1[line1.index('rank_norm_chan2.mean.intensity')]),(line1[line1.index('rank_norm_chan2.Skew.intensity')]),(line1[line1.index('rank_norm_rel_chan2.max.I')]),(line1[line1.index('rank_norm_rel_chan2.min.I')]),(line1[line1.index('rank_norm_chan2.mean.rel_ring1.I')]),(line1[line1.index('rank_norm_chan2.mean.rel_ring4.I')])]
    for ele in mm:
        line2.append(line1[ele])
    print '\t'.join(line2)
fh.close()

    
