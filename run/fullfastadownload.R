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

ids <- specacc[6419:(6419+70),2]
mstore1 <- fastaseqretrieval(ids)
write.table(mstore1, file="/home/ssohail/finfasta3.fasta",append=TRUE, row.names = FALSE,col.names=FALSE)

ids <- specacc[6490:(6490+28),2]
mstore1 <- fastaseqretrieval(ids)
write.table(mstore1, file="/home/ssohail/finfasta3.fasta",append=TRUE, row.names = FALSE,col.names=FALSE)

# seqs <- seq(6719,8519,100)
seqs <- seq(6519,8519,100)
for (i in seqs) {
  ids <- specacc[i:(i+99),2]
  mstore1 <- fastaseqretrieval(ids)
  # sp <- c(sp,specacc[i:(i+99),1])
  write.table(mstore1, file="/home/ssohail/finfasta3.fasta",append=TRUE, row.names = FALSE,col.names=FALSE)
}

ids <- specacc[8619:(8619+98),2]
mstore1 <- fastaseqretrieval(ids)
#sp <- c(sp, specacc[i1,1])
write.table(mstore1, file="/home/ssohail/finfasta3.fasta",append=TRUE, row.names = FALSE,col.names=FALSE)
#write.table(sp,file="/home/ssohail/listofspeciesfinfasta.txt",row.names=FALSE,col.names=FALSE)
#end1 <- Sys.time
#end-start

#library(rentrez)
#accessids <- function(search_term){
#  return(sapply(search_term, function(s) entrez_search(db="nucleotide", term=s, retmax=length(look[,1]))$ids))
#}
## accsns <- accessids(look$V1)
#entrlinkfasta <- function(search_term){
#return(sapply(search_term, function(s) entrez_link(dbfrom="nucleotide", id=s, rettype="fasta",db="nuccore")$links$nuccore_nuccore_gbrs))
#}
#fastaseqretrieval <- function(search_term){

# accsns_save <- accsns
#look <- read.table('/home/ssohail/speciestolookfor.txt',header=FALSE)
#accsns <- accessids(look$V1)
#print(length(accsns[[1]]))
#count <- 0
## entliids <- vector()
#sa_ve <- vector()
# run this until length changes from 73 to 50 - run 3 times

#idsacc <- function(accsns, sa_ve, count) {
#  for (i in 1:length(accsns)){
#    if (i <= length(accsns)) {
#      if (length(accsns[[i]]) > 80) {
#        sa_ve <- c(sa_ve, accsns[i])
#        accsns <- accsns[-i]
#        print(i)
#      } else {
#        count <- count + 1
#    }
#    }
#  }
#  return(accsns)
##}
#accsns <- list(accsns)
#for (i in 1:3) {
#  if (i <= 3) {
#    acc23 <- idsacc(accsns,sa_ve,count 
