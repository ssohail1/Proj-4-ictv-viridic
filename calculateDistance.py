#text file A and text file B




#r = open ("sampleblastoutB.txt", 'r')
#for line in r:

# dictionary w/ tuples as keys

# ex-     dictionary1 = {(g1,g2):id ; (g2,g1): id)}


    # k1 and k2 are seq ids

    # v = integer 

# make dictionary
#dictionary1 will be our main dictionary which will have tuples as keys
#note- dictionary1 holds the nident (number identities) as values paired with the 2 keys
#the two keys being query + subject
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

for key in dictionary1:
    seqID = key

#access the dictionary by key (A,B), then index the list/tuple you'd like to use next 
    recipIDone = seqID[0]
    recipIDtwo = seqID[1]

    #because value of the key is the nident :)


    idAB = dictionary1[key] #idAB should be set equal to the value of a certain tuple key
     
    
    for key2 in dictionary1:

        if key2[0] == recipIDtwo: #looking for  reciprocal so now the key[0] must be key2[1]
            if key2[1]== recipIDone:
                idBA=dictionary1[key2]#reciprocal seqID in same dictionary1
                #logic goes- key is A,B... search dictionary for its reciprocal key which is B,A
                break
            else:
                print ("No reciprocal found")

    targetTuple= recipIDtwo,recipIDone)

    idBA = dictionary1.get(targetTuple)
    print(idBA)
            

#idAB, idBA, lA, lB, simAB, distAB
#simAB = ((idAB +idBA) * 100)/ (lA/lB)
#distAB = 100 - simAB
#perfect, now we have our dictionary which we will work with in order
#to calculate our intergenomic distances 




