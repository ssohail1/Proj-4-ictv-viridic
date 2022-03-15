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
# Note: these for-loops will take a long time to run if looking at more than 1000 species in specieslist
# To-do: How to make this process efficient?

library(rentrez)

# when running the following lines of code, R will give error message that the vector ids is empty
# and at that point accnsp/entrez_search returns 0 hits - stops at Icerudivirus SIRV3
# after specieslist[19] there are "0" values in tax_lineagsp
# if accnsp$count == 0 then that means there were no hits found for that specific species
# There are species in the ICTV master species list that result in no hits found when running entrez_search()

# this is the count function
# this is a loop to see how many of the 9110 species give out 0 hits from NCBI
# and how many species have hits from NCBI
count <- 0
countze <- 0
for (i in 1:length(specieslist)) {
  accnsplist <- entrez_search(db="nuccore", term=specieslist[i], retmax=length(specieslist))
  if (accnsplist$count != 0) {
    count <- count + 1
  } else {
    if (accnsplist$count == 0) {
      countze <- countze + 1
    }
  }
}
# Sidra: Ran above for-loop to count zero species - it ran 30 mins before I exited and 1951 were hits and 14 were no hits

# this is writing out the fasta sequences - modify this to write out the tax_recsp IDs to a text file where each species accession IDs is a new line

# this is test code to see if able to retrieve fasta sequences from NCBI
# this looks at the first two species in the specieslist
for (i in 1:2) {
  accnsp <- entrez_search(db="nucleotide", term=specieslist[i])
  if (accnsp$count != 0) {
    tax_recsp <- entrez_link(dbfrom="nucleotide", id=accnsp$ids, rettype="fasta",db="nuccore")
    all_recs <- entrez_fetch(db="nuccore", id=tax_recsp$links$nuccore_nuccore_gbrs, rettype="fasta")
    #cat(strwrap(substr(all_recs,1,2147483647)), sep="\n")
    #tax_seqssp[i] <- c(strwrap(all_recs))
    # writing out the fasta files for specieslist[1] and specieslist[2]
    write(all_recs, file="~/Documents/myfile.fasta",append = TRUE)
  }
}
