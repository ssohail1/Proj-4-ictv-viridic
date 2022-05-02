library(rentrez)
look <- read.table('/home/ssohail/speciestolookfor.txt',header=FALSE)
accessids <- function(search_term){
  return(sapply(search_term, function(s) entrez_search(db="nucleotide", term=s, retmax=length(look$V1))$ids))
}
# accsns <- accessids(look$V1)
entrlinkfasta <- function(search_term){
  return(sapply(search_term, function(s) entrez_link(dbfrom="nucleotide", id=s, rettype="fasta",db="nuccore")$links$nuccore_nuccore_gbrs))
}
fastaseqretrieval <- function(search_term){
  return(sapply(search_term, function(s) entrez_fetch(db="nucleotide",id=s,rettype="fasta")))
}

# accsns_save <- accsns

accsns <- accessids(look$V1)
print(length(accsns[[1]]))
count <- 0
# entliids <- vector()
sa_ve <- vector()
# run this until length changes from 73 to 50 - run 3 times

idsacc <- function(accsns, sa_ve, count) {
  for (i in 1:length(accsns)){
    if (i <= length(accsns)) {
      if (length(accsns[[i]]) > 80) {
        sa_ve <- c(sa_ve, accsns[i])
        accsns <- accsns[-i]
        print(i)
      } else {
        count <- count + 1
    }
    }
  }
  return(accsns)
}
#accsns <- list(accsns)
for (i in 1:3) {
  if (i <= 3) {
    acc23 <- idsacc(accsns,sa_ve,count)
  }
}
idsacc <- function(accsns, sa_ve, count) {
  for (i in 1:length(accsns)){
    if (i <= length(accsns)) {
      if (length(accsns[[i]]) > 80) {
        sa_ve <- c(sa_ve, accsns[i])
        accsns <- accsns[-i]
        print(i)
      } else {
        count <- count + 1
      }
    }
  }
  return(accsns)
}
print(length(acc23))
for (i in 1:3) {
  if (i <= 3) {
    acc50 <- idsacc(acc23,sa_ve,count)
  }
}
print(length(acc50))
for (i in 1:length(acc50)) {
  idlinken <- entrlinkfasta(acc50[[i]])
  for (j in 1:length(idlinken)) {
    nullvals <- is.null(idlinken[[j]])
    if (nullvals == FALSE) {
      seqfas <- fastaseqretrieval(idlinken[[j]])
      sa <- c(names(acc50[i]))
      print(length(idlinken))
      write.table(seqfas, file="/home/ssohail/fasta50_finalfin.fasta",append=TRUE, row.names = FALSE,col.names=FALSE)
      write.table(sa, file="/home/ssohail/accessandname_finalfin.txt",append=TRUE, row.names = FALSE,col.names=FALSE)
    }
  }
}

