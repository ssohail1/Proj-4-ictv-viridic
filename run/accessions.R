library(rentrez)

# 73 species in look
look <- read.table('/home/ssohail/speciestolookfor.txt',header=FALSE)

# entrez_search function
accessids <- function(search_term){
  return(sapply(search_term, function(s) entrez_search(db="nucleotide", term=s, retmax=length(look$V1))$ids)) # the retmax limits the output to 73 accession IDs
}

# entrez_link function
entrlinkfasta <- function(search_term){
  return(sapply(search_term, function(s) entrez_link(dbfrom="nucleotide", id=s, rettype="fasta",db="nuccore")$links$nuccore_nuccore_gbrs))
}

# entrez_fetch function
fastaseqretrieval <- function(search_term){
  return(sapply(search_term, function(s) entrez_fetch(db="nucleotide",id=s,rettype="fasta")))
}

# Retrieving accession IDs for the 73 species
accsns <- accessids(look$V1)

# this block of code should be run if the number of accession IDs for a species are more than 80
# if have less than 80 accession IDs then skip to the bottom where you would need to change acc50 to accsns because this block of code was skipped
########################################################################
# print(length(accsns[[1]]))
count <- 0
sa_ve <- vector()
# function to remove species with more than 80 accession IDs as rentrez cannot run when more than 80 accession IDs are input     
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
# Running this to remove species with more than 80 accession IDs
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
# print(length(acc23))
for (i in 1:3) {
  if (i <= 3) {
    acc50 <- idsacc(acc23,sa_ve,count)
  }
}
########################################################################

# looping through acc50 where each species has a varied number of accession IDs
# print(length(acc50))
for (i in 1:length(acc50)) {
  idlinken <- entrlinkfasta(acc50[[i]])
  for (j in 1:length(idlinken)) {
    nullvals <- is.null(idlinken[[j]]) # the entrez_link function can yield NULL values so those are filtered out
    if (nullvals == FALSE) {
      seqfas <- fastaseqretrieval(idlinken[[j]]) # retrieving fasta sequences if null values are not present
      sa <- c(names(acc50[i])) # keeping track of which ICTV species fasta sequence is being retrieved
      print(length(idlinken)) # check whether code is running
      write.table(seqfas, file="/home/ssohail/fasta50_finalfin.fasta",append=TRUE, row.names = FALSE,col.names=FALSE)
      write.table(sa, file="/home/ssohail/accessandname_finalfin.txt",append=TRUE, row.names = FALSE,col.names=FALSE) # will be used to modify headers of fasta50_finalfin.fasta in the modify_fasta.py script
    }
  }
}

