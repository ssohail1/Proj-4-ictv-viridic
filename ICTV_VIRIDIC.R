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

# UPDATE this code to store species from specieslist[i] that have accnsplist$count == 0

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
# Rhea: Attempting to use esearch (from reutils package) for this for-loop. Having issues and consistently getting errors `Warning: HTTP error: Status 500;`
# accnsplist <- esearch(specieslist, db = "nuccore", rettype = "count", retmax=length(specieslist))
# esearch does have 'count' funcitonality which would make this process easier (hopefully)

# UPDATE:
# Sidra: this accounts for the name mismatch in NCBI - for-loop seems to get stuck at random points
# if it gets stuck after [15] (if the last thing printed is 15) then look at specieslist[16] and change for (i in 1:25) to for (i in 16) and see if it works then

# this is writing out the fasta sequences - modify this to write out the tax_recsp IDs to a text file where each species accession IDs is a new line
#Jacob: added above request, still getting stuck when species has 0 hits from NCBI. If we can get above for loop to run faster, then we can add in an if statement to
#second for loop to exclude species if it has 0 matches

# this is test code to see if able to retrieve fasta sequences from NCBI
# this looks at the first two species in the specieslist


for (i in 1:25) {
  accnsp <- entrez_search(db="nucleotide", term=specieslist[i])
  
  if (accnsp$count != 0) {
    print(i)
    tax_recsp <- entrez_link(dbfrom="nucleotide", id=accnsp$ids, rettype="fasta",db="nuccore")
    
    if (length(tax_recsp$links) > 0) {
      all_recs <- entrez_fetch(db="nuccore", id=tax_recsp$links$nuccore_nuccore_gbrs, rettype="fasta")
      write(tax_recsp$links$nuccore_nuccore_gbrs, file='~/Documents/tax_recspID.txt', append = TRUE)
      
    } else{
      all_recs <- entrez_fetch(db="nucleotide", id=accnsp$ids,rettype = "fasta")
      write(accnsp$ids, file='~/Documents/tax_recspID.txt', append = TRUE)
      #all_recs <- entrez_fetch(db="nuccore", id=tax_recsp$links$nuccore_nuccore_gbrs, rettype="fasta")
      #write(tax_recsp$links$nuccore_nuccore_gbrs, file='~/Documents/tax_recspID.txt', append = TRUE)
    }
    
    write(all_recs, file="~/Documents/myfile.fasta",append = TRUE)
  }
}

# Next Steps: use NCBI created accession number list from ICTV database as batch search NCBI to get equivalent fasta and add to database
# Next Next Steps: VIRIDIC with in-house database to run user input fasta sequence and determine similarities



