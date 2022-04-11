#This is adapted from NCBI's Dataset's documentation.
#https://github.com/ncbi/datasets

# Install the datasets
curl -o datasets 'https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/LATEST/linux-amd64/datasets'
chmod +x datasets 
curl -o dataformat 'https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/LATEST/linux-amd64/dataformat'
chmod +x dataformat

#More information can be found here: https://www.ncbi.nlm.nih.gov/datasets/docs/v1/how-tos/genomes/get-genome-metadata/
#In order to get data via command line
  # You only need quotes when the taxon name includes spaces
./datasets summary genome taxon "acidianus filamentous virus 1"
