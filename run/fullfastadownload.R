library(rentrez)

# to avoid errors from NCBI and rentrez the specacc is run in multiple parts
# length of speciesaccessions.csv file is 8717 species

specacc <- read.csv("/home/ssohail/speciesaccessions.csv",header=TRUE)

# entrez_fetch function
fastaseqretrieval <- function(search_term){
  return(sapply(search_term, function(s) entrez_fetch(db="nucleotide",id=s,rettype="fasta")))
}

i1 <- 1
ids <- specacc[i1:(i1+17),2]
mstore1 <- fastaseqretrieval(ids)
write.table(mstore1, file="/home/ssohail/finfasta3.fasta",append=TRUE, row.names = FALSE,col.names=FALSE)
 
# the number ranges in seq() is relevant for ICTV MSL version 37 and VMR version 36
# will need to be modified if using an older MSL version

seqs <- seq(19,6319,100)
for (i in seqs) {
  ids <- specacc[i:(i+99),2]
  mstore1 <- fastaseqretrieval(ids)
  write.table(mstore1, file="/home/ssohail/finfasta3.fasta",append=TRUE, row.names = FALSE,col.names=FALSE)
}

ids <- specacc[6419:(6419+70),2]
mstore1 <- fastaseqretrieval(ids)
write.table(mstore1, file="/home/ssohail/finfasta3.fasta",append=TRUE, row.names = FALSE,col.names=FALSE)

ids <- specacc[6490:(6490+28),2]
mstore1 <- fastaseqretrieval(ids)
write.table(mstore1, file="/home/ssohail/finfasta3.fasta",append=TRUE, row.names = FALSE,col.names=FALSE)

seqs <- seq(6519,8519,100)
for (i in seqs) {
  ids <- specacc[i:(i+99),2]
  mstore1 <- fastaseqretrieval(ids)
  write.table(mstore1, file="/home/ssohail/finfasta3.fasta",append=TRUE, row.names = FALSE,col.names=FALSE)
}

ids <- specacc[8619:(8619+98),2]
mstore1 <- fastaseqretrieval(ids)
write.table(mstore1, file="/home/ssohail/finfasta3.fasta",append=TRUE, row.names = FALSE,col.names=FALSE)

