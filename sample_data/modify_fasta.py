import os
import csv

# copy the fasta file to text file
def filetotxt(file):
    totxtcmmd = 'cp '+ file + '.fasta ' + file + '.txt'
    os.system(totxtcmmd)
filetotxt('finfasta3')

multifasta = open('finfasta3.txt','r').read().split('">')

# this matches the accession ID in the multifasta file to the accession ID in the
# speciesaccesions.csv file and adds the ICTV species name after the accession number to the multifasta file
outfile = open('ictvheadermultifasta_fin.txt','w')
for i in range(0,len(multifasta)):
    with open('speciesaccessions.csv', 'r') as file:
        reader = csv.reader(file)
        for row in reader:
            if multifasta[i].startswith(str(row[1])):
                rolen = len(row[1])
                ind = multifasta[i].index(row[1])
                # add three to account for the '.1 ' characters
                multifasta[i] = '>' + multifasta[i][ind:rolen+3] + row[0] + '_' + multifasta[i][rolen+3:]
                outfile.write(multifasta[i])
outfile.close()

# replacing the spaces with underscores
multifasta = open('ictvheadermultifasta_fin.txt','r').read().split('>')
outfile = open('sequences.txt','w')
for i in range(1,len(multifasta)):
  multifasta[i] = multifasta[i].replace(' ','_')
  outfile.write('>' + multifasta[i] + '\n')
outfile.close()

with open('sequences.txt', 'r') as f, open('sequencesr.fasta', 'w') as fo: #removes quotations from sequences.fasta so it can be read by blast
    for line in f:
        if '"' in line:
            line.replace('"','')
        elif "'" in line:
            line.replace("'", "")
        fo.write(line)
