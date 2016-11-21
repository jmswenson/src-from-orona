import sys
fh = open(sys.argv[1], 'r') #is [1] because it skips the python script name....
                            #ofint = [7,8,9,10,15,16,17,18,19,20,25,30]
for i,line in enumerate(fh):
    line1 = line.strip().split('\t')
    #    geneinfo = '"'+line1[-3] + '--' + line1[-6] + '--'+line1[-5] + '--'+line1[-4]+'"'
    geneinfo = line1[-3] + '--' + line1[-6] + '--'+line1[-5] + '--'+line1[-4]
    for x in range(0,7):  ### eliminates last 7 columns
        line1.pop()
    elim = [0,8,14,21,43,47,54,61,68,78,82,86] # Used R to find column names aa<-read.table('norm_only_by_WELL_with_names.tab.txt_for_clustergram',sep='\t',header=TRUE,quote="") for rings which had NAs
    for x in reversed(elim):
        line1.pop(x)
    if i==0:
## Generic how to find if an item is in a list -- returns a list with the index of where the item occurs
#I should probably make all of this into a function
        to_del = [o for o,item in enumerate(line1) if 'ring' in item]
        for x in reversed(to_del):
            line1.pop(x)
        to_del1 = [o for o,item in enumerate(line1) if 'rel' in item]
        for x in reversed(to_del1):
            line1.pop(x)
        to_del2 = [o for o,item in enumerate(line1) if 'chan1' in item]
        for x in reversed(to_del2):
            line1.pop(x)
        line1.append('rname')
        print '\t'.join(line1)
    else:
        for x in reversed(to_del):
            line1.pop(x)
        for x in reversed(to_del1):
            line1.pop(x)
        for x in reversed(to_del2):
            line1.pop(x)
        line1.append(geneinfo)
        print '\t'.join(line1)
        #    if i==3:
        #break
fh.close()

    
