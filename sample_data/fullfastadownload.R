library(rentrez)

# length of speciesaccessions.csv is 127 species

specacc <- read.csv("speciesaccessions.csv",header=TRUE)

# entrez_fetch function
fastaseqretrieval <- function(search_term) {
  return(sapply(search_term, function(s) entrez_fetch(db="nucleotide",id=s,rettype="fasta")))
}

# the range will need to be changed if not using the speciesaccessions.csv file with length of 127 species
i1 <- 1
ids <- specacc[i1:(i1+99),2] # accession numbers for the first 100 species
mstore1 <- fastaseqretrieval(ids)
write.table(mstore1, file="finfasta3.fasta",append=TRUE, row.names = FALSE,col.names=FALSE)

i <- 101
ids <- specacc[i:(i+26),2] # accession numbers for the last 27 species
mstore1 <- fastaseqretrieval(ids)
write.table(mstore1, file="finfasta3.fasta",append=TRUE, row.names = FALSE,col.names=FALSE)
