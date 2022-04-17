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

#organize the data into a table
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
#RETURNS ERROR
  #Error in curl::curl_fetch_memory(url, handle = handle) : Out of memory
