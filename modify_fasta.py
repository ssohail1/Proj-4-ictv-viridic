# To install Biopython, enter following command in command line
  #pip install biopython
  
# Import necessary libraries
from Bio import SeqIO
import pandas as pd

df = pd.read_csv("/home/rprag/speciesaccessions.csv")

#need to match id in fasta file with to accessionIDs and correlate it with ICTVnames and then print fasta header with ICTV name

# Open fasta input file and create fasta output file
with open("/home/rprag/finfasta3.fasta", 'r') as inputs, open("/home/rprag/finfasta3_mod.fasta", 'w') as outputs:
  # Create fasta dictionary to store values
  my_dict = SeqIO.to_dict(SeqIO.parse(inputs, 'fasta'))
  # Rename fasta headers
  for k in my_dict.values():
    k.id = k.description.replace(" ", "_")
    k.description = k.id
  # Write result to file  
  SeqIO.write(my_dict.values(), outputs, 'fasta')


##################################


# Sidra:

import os
import csv

  # copy fasta file to a text file
def filetotxt(file):
    totxtcmmd = 'cp '+ file + '.fasta ' + file + '.txt'
    os.system(totxtcmmd)
filetotxt('finfasta3')

# split at ">" so that each fasta sequence is separated
multifasta = open('finfasta3.txt','r').read().split('">')

# file with the modified headers will be the ictvheadermultifasta.txt file
outfile = open('ictvheadermultifasta.txt','w')

# looping through the multifasta file
for i in range(0,len(multifasta)):
	# parsing through the speciesaccessions csv file
    with open('speciesaccessions.csv', 'r') as file:
    	# reader is the row in the speciesaccessions csv file
        reader = csv.reader(file)
        # row contains the ICTV species names (row[0]) and the accession ID (row[1])
        for row in reader:
            # if a sequence in the multifasta starts with a row[1] accession ID
            if multifasta[i].startswith(str(row[1])):
                rolen = len(row[1]) # taking the length of the accession ID in row[1]
                ind = multifasta[i].index(row[1]) # getting the index of where row[1] is in 
                # the multifasta sequence - this index does not include the '>' so add it here
                # row[0] is the ICTV species name
                multifasta[i] = '>' + multifasta[i][ind:rolen+3] + row[0] + '_' + multifasta[i][rolen+3:]
                # write the multifasta[i] to outfile
                outfile.write(multifasta[i])
# close outfile
outfile.close()

multifasta = open('ictvheadermultifasta.txt','r').read().split('">')

outfile = = open('ictvheadermultifasta_fin.txt','w')

for i in range(0,len(multifasta)):
  multifasta[i] = multifasta[i].replace(' ','_')
  outfile.write(multifasta[i])
oufile.close()

def filetofasta(file):
    totxtcmmd = 'cp '+ file + '.txt ' + file + '.fasta'
    os.system(totxtcmmd)
filetofasta('ictvheadermultifasta_fin')
