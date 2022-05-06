library(rentrez)

specacc <- read.csv("/home/ssohail/speciesaccessions.csv",header=TRUE)

#start1 <- Sys.time()
fastaseqretrieval <- function(search_term){
  return(sapply(search_term, function(s) entrez_fetch(db="nucleotide",id=s,rettype="fasta")))
}
# seqs <- seq(1,19,1)
# sp <- vector()
i1 <- 1
ids <- specacc[i1:(i1+17),2]
mstore1 <- fastaseqretrieval(ids)
# sp <- c(sp, specacc[i1:(i1+17),1])
write.table(mstore1, file="/home/ssohail/finfasta3.fasta",append=TRUE, row.names = FALSE,col.names=FALSE)
 
seqs <- seq(19,6319,100)
# test: seqs <- seq(119,219,100)
for (i in seqs) {
  ids <- specacc[i:(i+99),2]
  mstore1 <- fastaseqretrieval(ids)
  # sp <- c(sp,specacc[i:(i+99),1])
  write.table(mstore1, file="/home/ssohail/finfasta3.fasta",append=TRUE, row.names = FALSE,col.names=FALSE)
}
