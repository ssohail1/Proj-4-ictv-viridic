
# note: this calculation formula is taken from VIRIDC
#intergenomic distance calculation
# idAB = identical bases when genome A is aligned to genome B
# idBA = identical bases when genome B is aligned to genome A 
# lA = length genome A 
# lB = length genome B
# simAB = intergenomic similarity between genomes A and B
# distAB =  intergenomic distance between genomes A and B


#simAB = ((idAB + idBA) * 100)/(lA + lB)
# distAB = 100 - simAB
# in order to calcualte intergenomic distance we need the following from our blast output:
# output need: 

#CODE:
#text file A and text file B




#r = open ("sampleblastoutB.txt", 'r')
#for line in r:

# dictionary w/ tuples as keys

# ex-     dictionary1 = {(g1,g2):id ; (g2,g1): id)}


    # k1 and k2 are seq ids

    # v = integer 

# make dictionary
#dictionary1 will be our main dictionary which will have tuples as keys
#dictionary 2 will simply be to store the length of each seqID because seq length
#will be necessary to calculate the intergenomic distance. 
dictionary1 = {}
dictionary2= {}

with open ("sampleblastoutB.txt") as f:
    for line in f: 
        k1,k2,i,i2,v,m = line.split()
        dictionary1[(k1,k2)] = int(v)
        dictionary2[k1]=int(m)

    #print (dictionary1)

    f.close()

with open ("sampleblastoutA.txt") as r:
    for line in r:
        k1,k2,i,i2,v,m= line.split()
        dictionary1[(k1,k2)]= int(v)
        dictionary2[k1]=int(m)

    print(dictionary1)
    print(dictionary2)

    r.close()
#perfect, now we have our dictionary which we will work with in order
#to calculate our intergenomic distances 

