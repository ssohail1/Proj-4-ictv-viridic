# can install rentrez two ways. 
# install.packages('rentrez')  OR 
# library(devtools)
# install_github("ropensci/rentrez") # this way will give you the latest version

# csv file is from saving the third sheet as a csv file from Microsoft Excel
ictvxl <- read.csv('~/Documents/ICTV.csv')
View(ictvxl)
specieslist <- ictvxl$Species
length(specieslist)

# Moving Forward: need to address this issue when retrieving accession IDs and fasta sequences
# Note: entrez prints error message when loop through many species
# To-do: How to have entrez retrieve sequences for all species

#in order to install devtools
#in command line, run the following commands -
  #sudo apt-get install libssl-dev
  #sudo apt-get install libxml2-dev
  #sudo apt-get install libcurl4-openssl-dev
  #sudo apt install r-cran-devtools
#to install reutils - install.packages("reutils")

library(reutils)
library(devtools)
library(rentrez)

# when running the following lines of code, R will give error message that the vector ids is empty
# and at that point accnsp/entrez_search returns 0 hits - stops at Icerudivirus SIRV3
# after specieslist[19] there are "0" values in tax_lineagsp
# if accnsp$count == 0 then that means there were no hits found for that specific species
# There are species in the ICTV master species list that result in no hits found when running entrez_search()

# this is the count function
# this is a loop to see how many of the 9110 species give out 0 hits from NCBI
# and how many species have hits from NCBI

# this stores species from specieslist[i] that have accnsplist$count == 0 - completed
ictvxl <- read.csv('/home/ssohail/MasterSpeciesList2020.csv') 
specieslist <- ictvxl$Species

# accnsplist$count is the number of IDs returned from searching a species
# Sidra: this loops through the specieslist and if the count of ids is 0 then it appends the species to the specieszero12.txt file
# The specieszero12.txt file has 318 species and can use this to filter out/remove species from the specieslist so that we don't
# have to search for the species that yield 0 hits from NCBI
for (i in 1:length(specieslist)) {
  accnsplist <- entrez_search(db="nuccore", term=specieslist[i], retmax=length(specieslist))
  if (accnsplist$count == 0) {
      write(specieslist[i], file='/home/ssohail/specieszero12.txt', append = TRUE)
  }
}

# Rhea: Attempting to use esearch (from reutils package) for this for-loop. Having issues and consistently getting errors `Warning: HTTP error: Status 500;`
# accnsplist <- esearch(specieslist, db = "nuccore", rettype = "count", retmax=length(specieslist))
# esearch does have 'count' funcitonality which would make this process easier (hopefully)

# UPDATE:
# Sidra: this accounts for the name mismatch in NCBI - for-loop seems to get stuck at random points
# if it gets stuck after [15] (if the last thing printed is 15) then look at specieslist[16] and change for (i in 1:25) to for (i in 16) and see if it works then

# this is writing out the fasta sequences - modify this to write out the tax_recsp IDs to a text file where each species accession IDs is a new line
#Jacob: added above request, still getting stuck when species has 0 hits from NCBI. If we can get above for loop to run faster, then we can add in an if statement to
#second for loop to exclude species if it has 0 matches

# Sidra: this for loop will take the filtered out specieslist file that does not have species that yield 0 hits
# as a trial run I have set the range to be the first 4 entries of specieslist
for (i in 1:4) {
  #  for (j in accnsp[,i]) {
  accnsp <- entrez_search(db="nucleotide", term=specieslist[i])$ids
  write.table(accnsp,file="~/Downloads/COMP_383-483_compbio/accessionidsfirst4.txt",append=TRUE,row.names = FALSE,col.names = FALSE)
}
accsnids <- read.table("~/Downloads/COMP_383-483_compbio/accessionidsfirst4.txt")

# the function fastaseqretrieval will retrieve fasta sequences for each accession id (s) that is passed through the id= parameter
# for some species there are multiple accession ids that are returned so there will be repeats and other sequences that are retrieved 
# this function was adapted from here: https://github.com/ropensci/rentrez/
fastaseqretrieval <- function(search_term){
  return(sapply(search_term, function(s) entrez_fetch(db="nucleotide",id=s,rettype="fasta")))
}
                
# mstore will have all the fasta sequences stored including repeats and other sequences
mstore <- list()
mstore <- fastaseqretrieval(accsnids[1:16,]) # change 16 to the number that is the length of accsnids
# accsnids[1:16,]

# write out the mstore variable as a fasta file before any filtering/removing/modifying
write.table(mstore,file="~/Downloads/COMP_383-483_compbio/first4species16fasta.fasta",row.names = FALSE,col.names = FALSE)

# this mstoremodify variable will need to be filtered to remove repeats of sequences and remove sequences that do not have the header ">NC_number "
mstoremodify <- read.table(file="~/Downloads/COMP_383-483_compbio/first4species16fasta.fasta")

# Next Steps: modify the mstoremodify variable so to remove repeat sequences and remove sequences that do not have header ">NC_number " OR
                # can create a function similar to fastaseqretrieval that implements entrez_link instead of entrez_fetch to retrieve accession ids 
                # that will retrieve fasta sequences with ">NC_number" header
# Next Steps: use NCBI created accession number list from ICTV database as batch search NCBI to get equivalent fasta and add to database
# Next Next Steps: VIRIDIC with in-house database to run user input fasta sequence and determine similarities



