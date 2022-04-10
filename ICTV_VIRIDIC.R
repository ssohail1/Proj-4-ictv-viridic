# There are several R libraries that need to be installed for this documentation.
# In order to install `rentrez`, there are two ways:
  # install.packages('rentrez') OR 
  # install_github("ropensci/rentrez")
    # This way will provide the latest version.
library(rentrez)

# In order to install devtools, run the following commands in command line -
  #sudo apt-get install libssl-dev
  #sudo apt-get install libxml2-dev
  #sudo apt-get install libcurl4-openssl-dev
  #sudo apt install r-cran-devtools
library(devtools)

# In order to install reutils, in R - install.packages("reutils")
library(reutils)


# csv file is from saving the third sheet as a csv file from Microsoft Excel
ictvxl <- read.csv('~/Documents/ICTV.csv')
View(ictvxl)
specieslist <- ictvxl$Species
length(specieslist)

# Moving Forward: need to address this issue when retrieving accession IDs and fasta sequences
# Note: entrez prints error message when loop through many species
# To-do: How to have entrez retrieve sequences for all species

# when running the following lines of code, R will give error message that the vector ids is empty
# and at that point accnsp/entrez_search returns 0 hits - stops at Icerudivirus SIRV3
# after specieslist[19] there are "0" values in tax_lineagsp
# if accnsp$count == 0 then that means there were no hits found for that specific species
# There are species in the ICTV master species list that result in no hits found when running entrez_search()

# this is the count function
# this is a loop to see how many of the 9110 species give out 0 hits from NCBI
# and how many species have hits from NCBI


# Rhea: Attempting to use esearch (from reutils package) for this for-loop. Having issues and consistently getting errors `Warning: HTTP error: Status 500;`
# accnsplist <- esearch(specieslist, db = "nuccore", rettype = "count", retmax=length(specieslist))
# esearch does have 'count' funcitonality which would make this process easier (hopefully)

# Taking the csv file created using `PandasSpeciesGetCSV.py`,
  # This file has the list of species names from the ICTV Master Species List
specieslist <- read.csv("/home/rprag/species.csv")
length(specieslist[[1]])
# This should return as 9110
# Rhea is working on using this for the analysis

# this is writing out the fasta sequences - modify this to write out the tax_recsp IDs to a text file where each species accession IDs is a new line
#Jacob: added above request, still getting stuck when species has 0 hits from NCBI. If we can get above for loop to run faster, then we can add in an if statement to
#second for loop to exclude species if it has 0 matches


# this stores species from specieslist[i] that have accnsplist$count == 0 - completed
# accnsplist$count is the number of IDs returned from searching a species
# this loops through the specieslist and if the count of ids is 0 then it appends the species to the specieszero12.txt file
# The specieszero12.txt file has 318 species and can use this to filter out/remove species from the specieslist so that we don't
# have to search for the species that yield 0 hits from NCBI
species <- read.table(file="~/Downloads/COMP_383-483_compbio/species.csv", header= TRUE, sep = "\n") # from Pandas python script

for (i in 1:length(species[,1])) {
  accnsplist <- entrez_search(db="nuccore", term=species[i,], retmax=length(species[,1]))
  if (accnsplist$count == 0) {
    write(species[i,], file='~/Downloads/COMP_383-483_compbio/specieszero.txt', append = TRUE) # change directory
  }
}

speciescsv <- read.csv("~/Downloads/COMP_383-483_compbio/species.csv")
# this file is from the above command that saves the species that yield 0 hits
spzero <- read.table(file="~/Downloads/COMP_383-483_compbio/specieszero.txt",header = FALSE,sep = "\n")
count <- vector()
for (i in 1:length(speciescsv$Species)) {
  for (j in 1:length(spzero$V1)) {
    if (speciescsv$Species[i] == spzero$V1[j]) {
      print(i)
      # count has the indices of the species that yields 0 hits from speciescsv
      count <- c(count,i)
    }
  }
}
# this will change the speciescsv type from list to character object
# so that do not have problem in the next command
# count[1] = 19th item in speciescsv 
speciescsv <- speciescsv[-count[1],]
# matching the species in both lists and removing them from speciescsv
for (i in 1:length(speciescsv)) {
  for (j in 1:length(spzero$V1)) {
    if (speciescsv[i] == spzero$V1[j]) {
      speciescsv <- speciescsv[-i]
    }
  }
}
write.table(speciescsv, file = "~/Downloads/COMP_383-483_compbio/speciesmodifnozeros.txt", row.names = FALSE, col.names = FALSE)


specieslist <- read.table(file="/home/ssohail/speciesmodifnozeros.txt")
print(length(specieslist[,1]))
print(specieslist[1,])
# retrieving all accession ids through entrez_search
accessids <- function(search_term){
  return(sapply(search_term, function(s) entrez_search(db="nucleotide", term=s)$ids))
}
mstore1 <- list()
mstore1 <- accessids(specieslist[1:length(specieslist[,1]),])
write.table(mstore1, file="/home/ssohail/accessionidsspno0.txt",row.names = FALSE,col.names = FALSE)

# retrieving accession ids for fasta seq retrieval using entrez_link with all accession ids as input
accsnids <- read.table("/home/ssohail/accessionidsspno0.txt")
fastaseqretrieval <- function(search_term){
  return(sapply(search_term, function(s) entrez_link(dbfrom="nucleotide", id=s, rettype="fasta",db="nuccore")$links$nuccore_nuccore_gbrs))
}
mstore <- list()
mstore1 <- list()
mstore <- fastaseqretrieval(accsnids[1:16,])
for (i in 1:length(mstore)) {
  if (as.character(mstore[i]) == "NULL") {
    print(i)
    # mstore <- mstore[-i]
    #mstore1 <- c(mstore1, mstore[i])
  } else if (as.character(mstore[i]) != "NULL") {
    mstore1 <- c(mstore1, mstore[i])
  }
}
write.table(mstore1, file="/home/ssohail/entrezlinkidsfull.txt",row.names = FALSE,col.names = FALSE)

# retrieving fasta sequences using entrezlink accession ids as input
entrlinkids <- read.table("/home/ssohail/entrezlinkidsfull.txt")
fastaseqretrieval1 <- function(search_term){
  return(sapply(search_term, function(s) entrez_fetch(db="nucleotide", id=s,rettype = "fasta")))
}
mstore12 <- list()
mstore12 <- fastaseqretrieval1(entrlinkids[1:length(entrlinkids)])
write.table(mstore12, file="/home/ssohail/fastaseqfull.fasta",row.names = FALSE,col.names = FALSE)



# Next Steps: modify the mstoremodify variable so to remove repeat sequences and remove sequences that do not have header ">NC_number " OR
                # can create a function similar to fastaseqretrieval that implements entrez_link instead of entrez_fetch to retrieve accession ids 
                # that will retrieve fasta sequences with ">NC_number" header
# Next Steps: use NCBI created accession number list from ICTV database as batch search NCBI to get equivalent fasta and add to database
# Next Next Steps: VIRIDIC with in-house database to run user input fasta sequence and determine similarities (Jacob working on figuring out VIRIDIC requirements)



