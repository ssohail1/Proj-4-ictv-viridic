library(rentrez)

specacc <- read.csv("speciesaccessions.csv",header=TRUE)

fastaseqretrieval <- function(search_term) {
  return(sapply(search_term, function(s) entrez_fetch(db="nucleotide",id=s,rettype="fasta")))
}

i1 <- 1
ids <- specacc[i1:(i1+99),2] # accession numbers for the first 100 species
mstore1 <- fastaseqretrieval(ids)
write.table(mstore1, file="finfasta3.fasta",append=TRUE, row.names = FALSE,col.names=FALSE)

i <- 101
ids <- specacc[i:(i+26),2] # accession numbers for the last 27 species
mstore1 <- fastaseqretrieval(ids)
write.table(mstore1, file="finfasta3.fasta",append=TRUE, row.names = FALSE,col.names=FALSE)
