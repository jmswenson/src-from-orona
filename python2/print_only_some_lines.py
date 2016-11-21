import os
directory = '.'
aa = os.listdir(directory) # list of files in the directory
for x,i in enumerate(aa):  ## x is the counter, i is the item being iterated thru (name of a file)
    fh = open(i,'r')
    outfh = open(i+".no_zeros",'w')
    for line in fh:
        ln = line.strip().split()
        #        if (ln[1]!=[0-9]):next
        print i
        if (int(ln[1])==0):
            print ln[1]
            next
        else:
            outfh.write(line)
    outfh.close()
    
