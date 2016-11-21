#nohup python ~/src/python/remove_duplicate_lines.py *pearson_summ* &
import sys
for x,file in enumerate(sys.argv):
    if x<1:continue
    xx = sys.argv[x]
    fh = open(xx, 'r') #is [1] because it skips the python script name....
    outp = open('del_dups_'+xx,'w')
    d={}
    for line in fh:
        if not line in d.keys():
            d[line] = 1
            outp.write(line)
    fh.close()
    outp.close()
    
