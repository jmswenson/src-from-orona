rpt_names = 'shortNEWrepeats.txt'
rpt50 = 'shortNEWrepeats50.txt'

fhnames = open(rpt_names, 'r')
fh50 = open(rpt50, 'r')

outfh = open('repeats7-12mer_49bases_for_bowtie', 'w')

for line in fhnames:
    ln = line.strip()
    l50 = fh50.readline().strip()
    #    l49 = l50[1:]
    outfh.write('>'+ln+'\n')
    outfh.write(l50[1:]+'\n')

outfh.close()


'''
for line in op_table_fh:
    line1 = line.split('\t')
    if (line1[6])=='TRUE':
        all_trues.append([line1[4],line1[5]])
'''





'''
   try:
      fh = open(filename, 'r')
   except IOError:
      print "Warning,", filename, "doesn't exist"
      return
   for line in fh:
      line = line.strip()
      line1 = line.upper()
      if ((line1.count('A')+line1.count('T')+line1.count('G')+line1.count('C')+line1.count('N'))==len(line1)) or line.startswith('>'):
         if line.startswith('>'):
            current_gene = line[1:]
            genes[current_gene] = []
         else:
            join(genes, current_gene, line1)
      else:
         print "Sequences can only be A, T, G, C, or N and gene names have to start with '>'"
         return
'''
