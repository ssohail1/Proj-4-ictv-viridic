# To install NCBI Datasets, use the following command in terminal:
    #curl -o datasets 'https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/LATEST/linux-amd64/datasets'
    #curl -o dataformat 'https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/LATEST/linux-amd64/dataformat'
    #chmod +x datasets dataformat

import os

def datasets():
    command = 'datasets download genome accession --inputfile accessions.txt --filename datasets --exclude-genomic-cds --exclude-gff3 --exclude-protein --exclude-rna'
    os.system(command)
    os.system('cat *.fasta > sequences.fasta')
    
def input_commd():
    with open("accessions.txt", 'r') as f:
        sequence = f.read().strip()
    if sequence:
        datasets()
       
input_cmmd()
#sometimes works?
