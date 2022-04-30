#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Apr 29 20:03:15 2022

@author: sidra
"""

import os
import csv

def filetotxt(file):
    totxtcmmd = 'cp '+ file + '.fasta ' + file + '.txt'
    os.system(totxtcmmd)
filetotxt('finfasta3')

multifasta = open('finfasta3.txt','r').read().split('">')

'''
outfile = open('ictvheadermultifasta.txt','w')
for i in range(0,len(multifasta)):
  multifasta[i] = multifasta[i].replace(' ','_')
  outfile.write(multifasta[i])
outfile.close()
'''

# multifasta = open('ictvheadermultifasta.txt','r').read().split('">')

outfile = open('ictvheadermultifasta_fin.txt','w')
for i in range(0,len(multifasta)):
    with open('speciesaccessions.csv', 'r') as file:
        reader = csv.reader(file)
        for row in reader:
            if multifasta[i].startswith(str(row[1])):
                rolen = len(row[1])
                ind = multifasta[i].index(row[1])
                multifasta[i] = '>' + multifasta[i][ind:rolen+3] + row[0] + '_' + multifasta[i][rolen+3:]
                outfile.write(multifasta[i])
outfile.close()



# split at ">" so that each fasta sequence is separated
#multifasta = open('ictvheadermultifasta_fin.txt','r').read().split('">')

out2 = open('test_ictv2.csv','w')
with open('speciesaccessions.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        if len(row[1]) > 12:
            out2.write(row[0] + '\t' + row[1] + '\n')
    out2.close()
    
# take the test_ictv2.csv file and manually remove the text with the colons e.g. SegA: NC_...... or DNA-U2: NC_...., etc.. 
# and save it as a test_ictv_.txt file   
    
#multifasta = open('ictvheadermultifasta.txt','r').read().split('">')
outfile = open('accessionsandnameandseqs.txt','w')
ictvaccession = open("test_ictv_.txt","r").read().split('\n')
for i in range(0,len(ictvaccession)-1): # the end of the ictvaccession is a blank/extra space
    a1 = ictvaccession[i].split('\t')
    for i in range(1,len(a1)):
        for j in range(0,len(multifasta)):
            if ';' in a1[i]:
                indi = a1[i].index(';')
            elif ';' not in a1[i]:
                indi = len(a1[i])
            if multifasta[j].startswith(a1[i][:indi]):
                rolen = len(a1[i][:indi])
                ind = multifasta[j].index(a1[i][:indi])
                multifasta[j] = '>' + multifasta[j][ind:rolen+3] + a1[0] + '_' + multifasta[j][rolen+3:]
                outfile.write(multifasta[j])
outfile.close()
    
multifasta = open('ictvheadermultifasta_fin.txt','r').read().split('>')
outfile = open('sequences.txt','w')
for i in range(0,len(multifasta)):
  multifasta[i] = multifasta[i].replace(' ','_')
  outfile.write('>' + multifasta[i] + '\n')
outfile.close()

multifasta = open('accessionsandnameandseqs.txt','r').read().split('>')
outfile = open('sequences2.txt','w')
for i in range(0,len(multifasta)):
  multifasta[i] = multifasta[i].replace(' ','_')
  outfile.write('>' + multifasta[i] + '\n')
outfile.close()

# sequences.txt and sequences2.txt are the files with the fasta sequences

def filetofasta(file):
    totxtcmmd = 'cp '+ file + '.txt ' + file + '.fasta'
    os.system(totxtcmmd)
filetofasta('sequences')
filetofasta('sequences2') # lesser memory size than sequences

# add the sequences in sequences2.fasta to the end of sequences.fasta
concat = 'cat sequences2.fasta >> sequences.fasta'
os.system(concat)


