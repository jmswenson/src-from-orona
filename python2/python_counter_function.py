import sys
fh = open(sys.argv[1], 'r')
### Only looking at the top 10% of the list of 894 things
dct = {}
spc=0
for jj,line in enumerate(fh): ##dictionary is returned containing the element as the key and the value is the number of keys that item appeared in the list
    line1 = line.strip().split()
    geneline = line1[0].split('--')
    gene = geneline[0]
    if gene in dct:
        dct[gene]+=1 # Adds a one to the value in dct...same as dct[i]=dct[i]+1
    else:
        dct[gene]=1
    if gene == 'HP1a' or gene == 'SuVar3-9':spc+=1
        # ABOVE IS SO HP1A AND SUVAR3-9 AREN'T COUNTED TOWARDS THE 10%
    if jj==(90+spc):break
print "Gene_name" + '\t' + "Times_counted_in_top_ten_perc"
for i in dct:
    print i + '\t' + str(dct[i])
print 'Lookedatthismanygenesoutofaround900' + '\t' + str(90 + spc) 


def itemcounter(listc): #list where each element is counted a dictionary is returned containing the element as the key and the value is the number of keys that item appeared in the list
    dct={}
    for i in listc:
        if i in dct:
            dct[i]=dct[i]+1
        else:
            dct[i]=1
    return dct
