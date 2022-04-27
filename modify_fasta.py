# To install Biopython, enter following command in command line
  #pip install biopython
  
# Import necessary libraries
from Bio import SeqIO

# Create fasta output file


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
