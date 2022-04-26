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
database_seqs=set()
with open ("B.txt") as f:
    for line in f: 
        fake,k1,k2,i,i2,v,m,y = line.split(',')
        if fake!='':
            database_seqs.add(k1)
            dictionary1[(k1,k2)] = int(y)
            dictionary2[k1]=int(m)
    f.close()
db_names=list(database_seqs)

#repeat step2 for second text file
user_seqs=set()
with open ("A.txt") as r:
    for line in r:
        fake,k1,k2,i,i2,v,m,y= line.split(',')
        if fake!='':
            user_seqs.add(k1)
            dictionary1[(k1,k2)]= int(y)
            dictionary2[k1]=int(m)
    r.close()
us_seqs=list(user_seqs)

#step3 now we are going to try and get each reciprocal pair in order to
     # do our intergenomic distance calculation!

# dimensionss -> # rows= len(db_names); # cols= len(us_seqs)
matrix=[[0 for x in us_seqs] for l in db_names]



for key in dictionary1:
    seqID = key # (A,B)

    #access the dictionary by key (A,B), then index the list/tuple you'd like to use next 
    recipIDone = seqID[0]
    recipIDtwo = seqID[1]

    #because value of the key is the nident

    
        
    #first value we'll need for calculations
    idAB = dictionary1[key] #idAB should be set equal to the value of a certain tuple key
     

    finalDictionary ={} #this will store our seqID pairs and their associated calculated intergenomic distances
    
    for key2 in dictionary1:

        if key2[0] == recipIDtwo and key2[1]==recipIDone: #looking for  reciprocal so now the key[0] must be key2[1]
                idBA=dictionary1[key2]#reciprocal seqID in same dictionary1
                
                #logic goes- key is A,B... search dictionary for its reciprocal key which is B,A
                #print(idBA)

                #now you need to get the length of each sequence  because we need them for lA and lB for simAB calculation

                lA= dictionary2.get(key[0])

                lB=dictionary2.get(key2[0])

               

               

                simAB= ((idAB+idBA) * 100)/(lA+lB)
                print(simAB)
                distAB = 100- simAB # we want the lower number

                
               # finalDictionary[recipIDtwo,recipIDone] = distAB
               # print(distAB)

                #filling in the matrix

                if recipIDtwo in db_names: # recipIDtwo is a row label
                    row_index=db_names.index(recipIDtwo) # find what row in the matrix that the number will go in
                    col_index=us_seqs.index(recipIDone) # find what column in the matrix that the number will go in.
                    matrix[row_index][col_index]=distAB  ## we are filling in the matrix with this
                else: #recipIDtwo is a column label
                    row_index=db_names.index(recipIDone) # find what row in the matrix that the number will go in
                    col_index=us_seqs.index(recipIDtwo) # find what column in the matrix that the number will go in.
                    matrix[row_index][col_index]=distAB  ## we are filling in the matrix with this                
                

                
                break
        #else:
            #pass

   # targetTuple= (recipIDtwo,recipIDone)

   # idBA = dictionary1.get(targetTuple)
   # print(idBA)
   

with open('/Users/sabrinalutfiyeva/Desktop/VIRUS.csv','w') as f: #add path 
    for i in us_seqs:
        f.write(','+i)
    f.write('\n')
    #write out row name and fill in the "holes"
    for i in range(len(db_names)): # i is the index in db_seq (row index in the matrix)
        f.write(db_names[i])
        for j in range(len(us_seqs)): # j is the index in us_seq (column index in the matrix)
            f.write(','+str(matrix[i][j]))
        f.write('\n')


            

#idAB, idBA, lA, lB, simAB, distAB
#simAB = ((idAB +idBA) * 100)/ (lA/lB)
#distAB = 100 - simAB
#perfect, now we have our dictionary which we will work with in order
#to calculate our intergenomic distances 


