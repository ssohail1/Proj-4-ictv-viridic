``` {r}
#This is the attempt to use NCBI Datasets with R

#This code details how to implement the ncbi datasets with this project.
#The code is adaped from here: https://github.com/ncbi/datasets

#First the ncbi.datasets needs to be installed
local({r <- getOption("repos")
r["CRAN"] <- "http://cran.r-project.org"
options(repos=r)
})
if (!require(httr)) {
  install.packages("httr")
  library(httr)
}
if (!require(caTools)) {
  install.packages("caTools")
  library(caTools)
}
if (!require(knitr)) {
  install.packages("knitr")
  library(knitr)
}
if (!require(ncbi.datasets)) {
  install.packages("https://ftp.ncbi.nlm.nih.gov/pub/datasets/r_client_lib/ncbi.datasets_LATEST.tar.gz", repos = NULL)
  library(ncbi.datasets)
}
if (!require(DT)) {
  install.packages("DT")
  library(DT)
}

#Then create an instance for GeneApi to manage the http1 service calls to NCBI
api.gene_instance <- GeneApi$new()

#Retrieve metadata list using taxonomic name
species <- read.csv("species.csv")
result <- api.gene_instance$GeneMetadataByTaxAndSymbol(
  paste(species, collapse = ','), 
  species[1:10,]
)

#RETURNS ERROR
  #Error in curl::curl_fetch_memory(url, handle = handle) : Out of memory

# In order to organize the data into a table
metadata_tbl <- t(sapply(result$genes ,
                         function(g) { c(
                           g$gene$symbol,
                           g$gene$description,
                           g$gene$gene_id,
                           ifelse(g$gene$nomenclature_authority$authority == "FLYBASE",
                                  g$gene$nomenclature_authority$identifier,'-'),
                           gsub("\"", "", result$genes[[1]]$gene$type$toJSON()),
                           paste(g$gene$chromosome, ":",
                                 g$gene$genomic_ranges[[1]]$range[[1]]$begin, "..",
                                 g$gene$genomic_ranges[[1]]$range[[1]]$end,
                                 sep = '')
                         )}))
colnames(metadata_tbl) <- c('Gene Symbol',
                            'Gene Name',
                            'Gene ID',
                            'Fly Base id',
                            'Gene Type',
                            'Chromosome location')
if (require(DT)) {
  datatable(metadata_tbl)
} else {
  print(metadata_tbl)
}
```
```{python}
import pandas as pd
import csv

#read in species csv file
species = pd.read_csv("species.csv")

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

```
