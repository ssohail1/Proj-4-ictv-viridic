"""
Created on Fri Apr 29 21:51:48 2022

@author: jgrandinetti
"""

your_fasta = 'SIRV3.fasta' #change the name of this to the fasta you are using as input

import os

os.system('cd ' + your_path)


#### BLAST CODE #### MAKE SURE THAT YOU HAVE BLAST INSTALLED ON YOUR SYSTEM OR THIS WILL NOT WORK

os.system('makeblastdb -in sequencesr.fasta -dbtype nucl -out results/customdb')

os.system('makeblastdb -in ' + your_fasta + ' -dbtype nucl -out results/inputdb')

os.system('blastn -db results/customdb -query ' + your_fasta + ' -out results/blastoutA.csv -evalue 1 -num_threads 12 -word_size 7 -reward 2 -penalty -3 -gapopen 5 -gapextend 2 -outfmt "6 qseqid sseqid qstart qend nident qlen"')

os.system('blastn -db results/inputdb -query sequencesr.fasta -out results/blastoutB.csv -evalue 1 -num_threads 12 -word_size 7 -reward 2 -penalty -3 -gapopen 5 -gapextend 2 -outfmt "6 qseqid sseqid qstart qend nident qlen" ')

#### ##### #####

os.system('python3 blastsort.py')

os.system('python3 distancecalc.py')


os.system()
