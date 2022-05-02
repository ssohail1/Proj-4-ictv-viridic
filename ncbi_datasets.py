# To find more information regarding NCBI Datasets: https://github.com/ncbi/datasets/tree/master/client_docs/python

# To install NCBI Datasets, use the following command in terminal:
    #curl -o datasets 'https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/LATEST/linux-amd64/datasets'
    #curl -o dataformat 'https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/LATEST/linux-amd64/dataformat'
    #chmod +x datasets dataformat

import os

def datasets():
    # Command to run NCBI datasets
        # Only need RefSeqGenBankNumber_Species_PartialOrCompleteGenome
    command = 'datasets download genome accession --inputfile accessions.txt --filename datasets --exclude-genomic-cds --exclude-gff3 --exclude-protein --exclude-rna'
    os.system(command)
    # Create output file in fasta format
    os.system('cat *.fasta > sequences.fasta')
    
def input_cmmd():
    # Read input file and strip lines
        # 'accessions.txt' is a list of all the accession ids
    with open("accessions.txt", 'r') as f:
        sequence = f.read().strip()
    # Use the accession ids and run them through NCBI datasets
    if sequence:
        datasets()

# Execute command
input_cmmd()
