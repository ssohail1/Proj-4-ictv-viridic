# To install NCBI Datasets, use the following command in terminal:
    #curl -o datasets 'https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/LATEST/linux-amd64/datasets'
    #curl -o dataformat 'https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/LATEST/linux-amd64/dataformat'
    #chmod +x datasets dataformat

import os
import glob

def datasets():
    command = 'datasets download genome accession --inputfile /Users/rhea/accessions.txt --filename datasets --exclude-genomic-cds --exclude-gff3 --exclude-protein --exclude-rna'
    os.system(command)
    os.system('cat *.fasta > sequences.fasta')
    
def input():
    with open("accessions.txt", 'r') as f:
        sequence = f.read().strip()
    if sequence:
        datasets()
    elif not glob.glob('*.fasta'):
        print('Input Not Found')
       
#sometimes works?
