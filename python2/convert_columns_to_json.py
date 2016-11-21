print "See bug list at top of script"
#### Current bugs or problems.  In function mapid, I currently I assign group membership based on which interaction is lowest in the list

### Make three functions,one which makes a dictionary which each element is a key and its value is a 
# unique number one for two column datasets (bait	prey), another for (bait	prey	weight)

def mapid(afilename): #makes a dictionary which each element is a key and its value is a list with
# the first item a unique number and the second is the group number (the number assigned to the item in the first column (ie the bait in an MS experiment)
# also returns another dictionary (dct1) where the key is the unique number and the value is a list,
# the first item is the name of the gene, the second iterm is the group number (the number assigned to the item in the first column (ie the bait in an MS experiment)
# also returns an integer saying what the largest id was that got mapped
	dct = {}
	cntr = 0
	for line in afilename:
		line1 = line.strip().split('\t')
		kys = dct.keys()
		### First I need to convert every item into a number and give it a group
		if (line1[0] in kys and line1[1] in kys): # if the bait and prey are already keys, next
			dct[line1[0]][2] += 1 # Adds one to increase this gene's interaction count
			dct[line1[1]][2] += 1 
			continue
		elif (line1[0] not in kys and line1[1] in kys): # if the prey is already a key, but bait isn't then add bait
			dct[line1[0]] = [cntr,cntr,1]
			dct[line1[1]][2] += 1 
			cntr += 1
			kys = dct.keys()
		elif (line1[0] not in kys and line1[1] not in kys): # if the prey is already a key, but bait isn't then add bait
			dct[line1[0]] = [cntr,cntr,1]
			cntr += 1
			dct[line1[1]] = [cntr,dct[line1[0]][1],1]
			cntr += 1
			kys = dct.keys()
		elif (line1[1] not in kys): # if the prey is already a key, but bait isn't then add bait
			dct[line1[1]] = [cntr,dct[line1[0]][1],1]
			dct[line1[0]][2] += 1 
			cntr += 1
			kys = dct.keys()
		else: print "work on logic....see mapid function"
	dct1 = {}
	tempdct = {}
	templist = []
	for key, items in dct.iteritems():
		remove_losers = 1   # Binary, do I want to remove nodes with few connections
		if remove_losers ==0:
			dct1[items[0]] = [key, items[1], items[2]]
		if remove_losers ==1 :
			if items[2]>3: ##### HOW MANY CONNECTIONS SHOULD THEY HAVE TO BE KEPT
				templist.append(key)
	if remove_losers ==1:
		print "I am removing any nodes with less than 3 connections, note that column connections refers to the original number of connections" 
		### see for loop before this to change number of connections to keep
		for idex, a in enumerate(templist): # Rebuild smaller dictionary, but need to fix group ID
			tempdct[a] = [idex, 0, dct[a][2]]
		print "below are items to graph"
		print templist
		for b in tempdct: # Fix group ID
			old_gp_id = dct[b][1]
			for k, val in dct.iteritems():
				if val[0]==old_gp_id:
					tempdct[b][1] = templist.index(k)
		cntr = idex+1  # I need to shrink the counter and add a 1 (see comment below for reasoning)
		for key, items in tempdct.iteritems():
			dct1[items[0]] = [key, items[1], items[2]]
		dct = tempdct			
	return [dct, dct1,cntr] #dct is composed of a key (gene name) with a list of values (unique integer, 
	#group ID (ie, key ID), number of connections (genes it interacts with)) (example dct[gene]=[uniqueID,baitID,#ofbindingpartners])
	#dct1 is: key(unique integer),[gene name, group ID, number of connections]
	#cntr is the highest unique ID + 1
	
def jsonize(afilename,mappednametoid, mappedidtoname, largestnameid): # Takes a filename and dct from function mapid as input
	nodes = '{"nodes":['
	links = '"links":['
#	for key, value in mappednametoid.iteritems():
#		print "THIS IS GOING TO BE IN SOME RANDOM ASS ORDER ----- AND THEN IT SCREWS UP THE LINKS --- AND THEN THE LABELS"
		####   The easiest would be if I can sort the dictionary by value and then print it in that order
	for i in range(0,largestnameid): # Note that I don't need to add 1 here to include the final id due to how counting works in function mapid
		nodes += '{"name":"' + mappedidtoname[i][0] + '","group":' + str(mappedidtoname[i][1]) + '},'
	nodes = nodes[:-1] + '],' # To get rid of extra comma and finish formatting
	fh1 = open(filename, 'r')
	for line in fh1:
		line1 = line.strip().split('\t')
		if (line1[0] not in mappednametoid.keys()) or (line1[1] not in mappednametoid.keys()):
			continue
		if len(line1)<2 or len(line1)>3: print "File formatt doesn't match, check line breaks, tab delimited, etc"
		if len(line1)==2:
			links += '{"source":' + str(mappednametoid[line1[0]][0]) + ',"target":' + str(mappednametoid[line1[1]][0]) + ',"value":' + '10' + '},'
#			print "Making UNweighted json file"
		if len(line1)==3:
			links += '{"source":' + mappednametoid[line1[0]][0] + ',"target":' + mappednametoid[line1[1]][0] + ',"value":' + line1[2] + '},'
#			print "Making WEIGHTED json file"
		if len(line1)>3 or len(line1)<2: print "A line somewhere is neither 2 nor 3 columns"
	links = links[:-1] + ']}'
	output = nodes + links
	return output	
		
		



filename = 'all-exceptSMCcomplex-symbols-pairwisea.txt'
#filename = 'shortversion.txt'
fh = open(filename,'r')
mapped = mapid(fh) # Returns a list of two dictionaries and a counter
# function that takes a filehandle, splits it on tabs and makes a dictionary
#which each element is a key and its value is a list with the first item a unique number and the
#second is the group number (the number assigned to the key or bait)
# also returns another dictionary (dct1) where the key is the unique number and the value is a list,
# the first item is the name of the gene, the second iterm is the group number (the number assigned to the item in the first column (ie the bait in an MS experiment)
# also returns an integer saying what the largest id was that got mapped

outp = jsonize(filename,mapped[0],mapped[1],mapped[2]) # Creates a json file with nodes and links
print "Making json file"
print "If a bait didn't pull itself down, it will not have a node"
outfh = open('all-exceptSMCcomplex-symbols-pairwiseaCOOLKIDS.json', 'w')
#outfh = open('shortversion.json', 'w')
outfh.write(outp)
outfh.close()
print "NOTE: You may want to run the code through http://jsonformatter.curiousconcept.com/ to check for json syntax errors"
