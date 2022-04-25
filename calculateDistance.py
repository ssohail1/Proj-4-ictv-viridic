#text file A, text file B (has reciprocal of A)

#we want dictionary w/ tuples as keys

#example: dictionary1= {(g1,g2): nident ; (g2,g1): nident)}

    #g1 and g2 are sequence ids

    #nident = integer

#now, make dictionary

#dictionary1 will be our main dictionary which will have tuples as keys

#note: dictionary1 holds the nident (number of identities) as values paired with
# the 2 keys which the keys are query and subject.

#note: dictionary2 will simply be to store the length of each seqID because seq
# length is necessary to calculate intergenomic distance


#step1: make dictionary1 and dictionary2
dictionary1 = {}
dictionary2= {}

#step2: add to dictionary1 the keys as tuples and values the nident
  #also, add to dictionary2 the key as seqid, the the value as length
with open ("sampleblastoutB.txt") as f:
    for line in f: 
        k1,k2,i,i2,v,m = line.split()
        dictionary1[(k1,k2)] = int(v)
        dictionary2[k1]=int(m)
    f.close()

#repeat step2 for second text file
with open ("sampleblastoutA.txt") as r:
    for line in r:
        k1,k2,i,i2,v,m= line.split()
        dictionary1[(k1,k2)]= int(v)
        dictionary2[k1]=int(m)
    r.close()

#step3 now we are going to try and get each reciprocal pair in order to
     # do our intergenomic distance calculation! 
for key in dictionary1:
    seqID = key

    #access the dictionary by key (A,B), then index the list/tuple you'd like to use next 
    recipIDone = seqID[0]
    recipIDtwo = seqID[1]

    #because value of the key is the nident

    
        
    #first value we'll need for calculations
    idAB = dictionary1[key] #idAB should be set equal to the value of a certain tuple key
     
    
    for key2 in dictionary1:

        if key2[0] == recipIDtwo and key2[1]==recipIDone: #looking for  reciprocal so now the key[0] must be key2[1]
                idBA=dictionary1[key2]#reciprocal seqID in same dictionary1
                #logic goes- key is A,B... search dictionary for its reciprocal key which is B,A
                #print(idBA)

                #now you need to get the length of each sequence  because we need them for lA and lB for simAB calculation

                lA= dictionary2.get(seqID)

                lB=dictionary2.get(key2)

                simAB= ((idAB+idBA) * 100)/(lA/lB)
                distAB = 100- simAB
                
                break
        else:
            pass

   # targetTuple= (recipIDtwo,recipIDone)

   # idBA = dictionary1.get(targetTuple)
   # print(idBA)
            

#idAB, idBA, lA, lB, simAB, distAB
#simAB = ((idAB +idBA) * 100)/ (lA/lB)
#distAB = 100 - simAB
#perfect, now we have our dictionary which we will work with in order
#to calculate our intergenomic distances 


