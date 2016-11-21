import sys
fh = open(sys.argv[1], 'r') #is [1] because it skips the python script name....
for i,line in enumerate(fh):
    line1 = line.strip().split('\t')
    if i==0:
        typeindex = line1.index('Type1')
        print '\t'.join(line1[:typeindex+1])
        line2=line1[(typeindex+1):]
        line2.insert(0,'1')
        print '\t'.join(line2)
        continue
    if line1[0] == 'site_name':
        typeindex = line1.index('Type1')
        line2 = line1[(typeindex+1):]
        line2.insert(0,'1')
        print '\t'.join(line2)
        continue
    print '\t'.join(line1)
fh.close()

    
