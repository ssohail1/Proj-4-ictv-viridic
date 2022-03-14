# can install rentrez two ways. 
# install.packages('rentrez')  OR 
# library(devtools)
# install_github("ropensci/rentrez") # this way will give you the latest version

# csv file is from saving the third sheet as a csv file from Microsoft Excel
ictvxl <- read.csv('~/Documents/ICTV.csv')
View(ictvxl)
specieslist <- ictvxl$Species
length(specieslist)

# Note: these for-loops will take a long time to run if looking at more than 1000 species in specieslist
# To-do: How to make this process efficient?

library(rentrez)

# when running the following lines of code, R will give error message that the vector ids is empty
# and at that point accnsp/entrez_search returns 0 hits - stops at Icerudivirus SIRV3
# after specieslist[19] there are "0" values in tax_lineagsp
# if accnsp$count == 0 then that means there were no hits found for that specific species - these also will be in tax_lineagsp
# and will not start with Viruses as they did not go through the entrez_fetch function
# There are species in the ICTV master species list that result in no hits found when running entrez_search()

# writing out the fasta files for specieslist[1] and specieslist[2]
# if accnsp$count == 0 then that means there were no hits found for that specific species

''' jacob code - not functional
accnsplist <- rep(0,length(specieslist))
for (i in 1:length(specieslist)) {
  accnsplist[i] <- entrez_search(db="nucleotide", term=specieslist[i], retmax=length(specieslist))}

ictvxl <- read.csv("/Users/jgrandinetti/Downloads/ICTV.csv")
View(ictvxl)
specieslist <- ictvxl$Species
length(specieslist)

accnsplist <- rep(0,length(specieslist))
count = 0

for (i in 1:length(specieslist)) {
  accnsplist[i] <- entrez_search(db="nuccore", term=specieslist[i], retmax=length(specieslist))
     
    efetch.batch(id, chunk_size = 200, rettype = NULL,
                   retmode = NULL, retmax = NULL, strand = NULL,
                   seq_start = NULL, seq_stop = NULL, complexity = NULL)

  if (accnsplist[i]$count != 0) {
    count + 1
    tax_recsplist <- rep(0,count)
    tax_recsp <- entrez_link(dbfrom="nucleotide", id=accnsp$ids, rettype="fasta",db="nuccore")
  }
}
'''

for (i in 1:2) {
  accnsp <- entrez_search(db="nucleotide", term=specieslist[i])
  if (accnsp$count != 0) {
    tax_recsp <- entrez_link(dbfrom="nucleotide", id=accnsp$ids, rettype="fasta",db="nuccore")
    all_recs <- entrez_fetch(db="nuccore", id=tax_recsp$links$nuccore_nuccore_gbrs, rettype="fasta")
    #cat(strwrap(substr(all_recs,1,2147483647)), sep="\n")
    #tax_seqssp[i] <- c(strwrap(all_recs))
    write(all_recs, file="~/Documents/myfile.fasta",append = TRUE)
  }
}
