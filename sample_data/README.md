results folder: Output from BLAST and distance calculation:
- results.csv: intergenomic similarity distances calculated
- heatmap.png: PNG image of heatmap visualizing distances between database and user input
- totidentA.csv: total nident when comparing the user input and database
- totidentB.csv: total nident when comparing the database and user input

SIRV3.fasta: sample user input multi-fasta file with two fasta sequences

fullfastadownload.R: R script for retrieving fasta sequences for the ICTV species names and output is a multi-fasta file

modify_fasta.py: modify headers to include ICTV species names and modify spaces and quotes characters

run2.py: Python wrapper for running BLAST, sorting BLAST output, and calculating distances

blastsort.py: sorting the BLAST output

distancecalc.py: calculating distances and outputs are a heatmap of the top 100 significant hits and a csv file with the distances
