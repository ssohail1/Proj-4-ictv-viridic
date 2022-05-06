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

# split at ">" so that each fasta sequence is separated
multifasta = open('finfasta3.txt','r').read().split('">')

# adding the ICTV species names to the fasta headers
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

# some species have many accession IDs so those species names and accession ids from speciesaccessions.csv are saved to test_ictv2.csv
out2 = open('test_ictv2.csv','w')
with open('speciesaccessions.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        if len(row[1]) > 12:
            out2.write(row[0] + '\t' + row[1] + '\n')
    out2.close()
    
# take the test_ictv2.csv file and manually remove the text with the colons e.g. SegA: NC_...... or DNA-U2: NC_...., etc.. through a text editor
# and save it as a test_ictv_.txt file
# the test_ictv.txt is provided for the ICTV MSL version 37 and VMR version 36 and will be updated on a yearly basis

# adding the ICTV species names to the fasta headers
outfile = open('accessionsandnameandseqs.txt','w')
ictvaccession = open("test_ictv_.txt","r").read().split('\n')
for i in range(0,len(ictvaccession)-1):
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

# replace spaces with underscores for the ictvheadermultifasta_fin and accessionsandnameandseqs.txt
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

# the fasta file with sequences for the 73 species
def filetotxt(file):
    totxtcmmd = 'cp '+ file + '.fasta ' + file + '.txt'
    os.system(totxtcmmd)
filetotxt('fasta50_finalfin')

# adding ICTV species names to the fasta headers
multifasta = open('fasta50_finalfin.txt','r').read().split('">')
namesspec = open('accessandname_finalfin.txt','r').read().split('\n')
outfile = open('fasta50_fin.txt','w')
for i in range(1,len(multifasta)):
    ind = multifasta[i].index(' ')
    multifasta[i] = '>' + multifasta[i][:ind] + namesspec[i] + '_' + multifasta[i][ind:]
    outfile.write(multifasta[i])
outfile.close()

# replace spaces with underscores for fasta50_fin.txt
multifasta = open('fasta50_fin.txt','r').read().split('>')
outfile = open('sequences3.txt','w')
for i in range(1,len(multifasta)):
  multifasta[i] = multifasta[i].replace(' ','_')
  outfile.write('>' + multifasta[i] + '\n')
outfile.close()

# copy the sequences text file to a fasta file
# sequences.txt, sequences2.txt, and sequences3.txt are the files with the fasta sequences
def filetofasta(file):
    totxtcmmd = 'cp '+ file + '.txt ' + file + '.fasta'
    os.system(totxtcmmd)
filetofasta('sequences3')

def filetofasta(file):
    totxtcmmd = 'cp '+ file + '.txt ' + file + '.fasta'
    os.system(totxtcmmd)
filetofasta('sequences')
filetofasta('sequences2')
# first concatenate sequences2.fasta to sequences.fasta
# and then concatenate sequences3.fasta to sequences.fasta
concat = 'cat sequences2.fasta >> sequences.fasta'
os.system(concat)
concat = 'cat sequences3.fasta >> sequences.fasta'
os.system(concat)

with open('sequences.fasta', 'r') as f, open('sequencesr.fasta', 'w') as fo: #removes quotations from sequences.fasta so it can be read by blast
    for line in f:
        if '1"' in line:
            line.replace('1"','1_')
        if '"' in line:
            line.replace('"','')
        elif "'" in line:
            line.replace("'", "")
        fo.write(line)
