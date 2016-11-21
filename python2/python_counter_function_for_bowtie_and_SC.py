## run as ~/src/python/python_counter_function_for_bowtie_and_SC.py Name-of-bowtie-output>grepped-bowtie-out
## Note that after this script you might want to run /Volumes/jswenson/src/python/clean-up-bowtie-and-grep-output-before-DESeq2-RNA-seq-analysis.py
import sys
fh = open(sys.argv[1], 'r')
### Only looking at the top 10% of the list of 894 things
dct = {}
for jj,line in enumerate(fh): ##dictionary is returned containing the element as the key and the value is the number of keys that item appeared in the list
    line1 = line.strip().split()
    if (line1[0] == "Reported") or (line1[0] == "Time") or (line1[0] == "Overall") or (line1[0] == '#') or (line1[0] == "Seeded"):
    	continue
    gene = line1[3]
    if gene in dct:
        dct[gene]+=1 # Adds a one to the value in dct...same as dct[i]=dct[i]+1
    else:
        dct[gene]=1
print "Gene_name" + '\t' + "Times_counted"
for i in dct:
    print i + '\t' + str(dct[i])