import pandas as pd
import csv

species_csv = open("species.csv")
species = csv.reader(species_csv)
header = next(species)
print(header)
rows = []
for row in species:
    rows.append(row)
print(rows)
species_csv.close()

#import ncbi datasets
try:
    import ncbi.datasets
except ImportError:
    print('ncbi.datasets module not found. To install, run `pip install ncbi-datasets-pylib`.')
    
api_instance = ncbi.datasets.GenomeApi(ncbi.datasets.ApiClient())


#since documentation takes string, convert list to str?
string = ' '.join([str(item) for item in rows])
#print(rows)

genome_summary = api_instance.assembly_descriptors_by_taxon(
    taxon=rows,
    page_size=1000)
#RETURNS WITH ERROR

print(f"Number of assemblies in the group '{tax_name}': {genome_summary.total_count}")



#Attempt 2
#in terminal: pip install --upgrade ncbi-datasets-pylib

#To add quotes to every line
#sed 's/\(.*\)/"\1"/g' species.txt > species1.txt


