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

# Taking the csv file created using `PandasSpeciesGetCSV.py`,
  # This file has the list of species names from the ICTV Master Species List
specieslist <- read.csv("/home/rprag/species.csv")
length(specieslist[[1]])
# This should return as 9110
# Rhea is working on using this for the analysis

# this is writing out the fasta sequences - modify this to write out the tax_recsp IDs to a text file where each species accession IDs is a new line
#Jacob: added above request, still getting stuck when species has 0 hits from NCBI. If we can get above for loop to run faster, then we can add in an if statement to
#second for loop to exclude species if it has 0 matches


# Test this chunk of code - change the directories to your local directory
################################
# Sidra
library(rentrez)

# Need to write a python script that will parse through the above excel file (using pandas) and extract the columns with the ICTV names, NCBI names, GenBank and RefSeq accession ids, and EorA labels

speciesexcel <- read.csv(file= "~/Downloads/VMR 18-191021 MSL36.xlsx", sep= '\t') # VMR 18-191021 MSL36.xlsx is the excel file - Virus Metadata Repository from October 19 2021
speciesinfo <- read.table(file="~/Downloads/COMP_383-483_compbio/ICTVspeciesinfo.txt",header = TRUE,sep = '\n') # ICTVspeciesinfo.txt has the ICTV names from excel file
speciesinfo <- data.frame(speciesinfo)
speciesNCBI <- read.csv(file = "~/Downloads/COMP_383-483_compbio/ncbinames.txt",sep = '\n') # ncbinames.txt has ncbi names from excel file
speciesinfoaccessions <- read.csv(file = "~/Downloads/COMP_383-483_compbio/accessionidslist.txt",sep = '\t') # accessionidslist.txt has GenBank and RefSeq ids from excel file

# additionally need to parse through the RefSeq id accessions to replace the blank column entries with "zero"

speciesexemplaroraddnl <- read.table(file = "~/Downloads/eora.txt",header = FALSE, sep = '\n') # eora.txt has exemplar or additional labels for each species from the excel file

# combine the previous datasets into one dataframe
speciesinfocomplete <- cbind(speciesinfo,speciesNCBI,speciesinfoaccessions,speciesexemplaroraddnl)
colnames(speciesinfocomplete) <- c("ICTVnames", "NCBInames", "GenBankIDs", "RefSeqIDs","ExemplarOrAdditional")

zerospecies <- list()
for (i in 1:length(speciesinfocomplete$RefSeqIDs)) {
  if (speciesinfocomplete$RefSeqIDs[i] == "zero") {
    zerospecies <- c(zerospecies, speciesinfocomplete[i,])
  }
}
length(zerospecies) # 18515 total -> 5 columns so 18515/5 = 3703 species do not have the associated RefSeq accession id

speciesinforemovezero <- cbind(speciesinfo,speciesNCBI,speciesinfoaccessions,speciesexemplaroraddnl)
colnames(speciesinforemovezero) <- c("ICTVnames", "NCBInames", "GenBankIDs", "RefSeqIDs","ExemplarOrAdditional")

# run this until length of speciesinforemovezero$RefSeqIDs is 3703 and the error message stops
for (i in 1:length(speciesinforemovezero$RefSeqIDs)) {
  if (speciesinforemovezero$RefSeqIDs[i] != "zero") {
    speciesinforemovezero <- speciesinforemovezero[-i,]
  }
}
length(speciesinforemovezero$RefSeqIDs)

# Removing "A" or additional species because they are repeats and not present in the ICTV Master Species List excel file

# run this until count1 is 1246 and the error message stops
count1 <- 0
for (i in 1:length(speciesinforemovezero$ExemplarOrAdditional)) {
  if (speciesinforemovezero$ExemplarOrAdditional[i] == "A") {
    count1 <- count1 + 1
    speciesinforemovezero <- speciesinforemovezero[-i,]
  }
}
count1 # there are 1246 "A" in virus metadata

# modifying the pandas python species output to exclude species that give zero hits
species <- read.table(file="~/Downloads/COMP_383-483_compbio/species.csv", header= TRUE, sep = "\n") # from Pandas python script

# run once
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

# Run once
for (i in 1:length(speciescsv$Species)) {
  for (j in 1:length(spzero$V1)) {
    if (speciescsv$Species[i] == spzero$V1[j]) {
      #  print(i)
      # count has the indices of the species that yields 0 hits from speciescsv
      count <- c(count,i)
    }
  }
}
length(speciescsv[,1]) # 9110
# this will change the speciescsv type from list to character object
# so that do not have problem in the next command
# count[1] = 19th item in speciescsv 
speciescsv <- speciescsv[-count[1],]
# matching the species in both lists and removing them from speciescsv

# run this until length of speciescsv is 8792 and the error message stops
for (i in 1:length(speciescsv)) {
  for (j in 1:length(spzero$V1)) {
    if (speciescsv[i] == spzero$V1[j]) {
      speciescsv <- speciescsv[-i]
    }
  }
}
length(speciescsv)
write.table(speciescsv, file = "~/Downloads/COMP_383-483_compbio/speciesmodifnozeros.txt", row.names = FALSE, col.names = FALSE)

species <- read.csv(file = "~/Downloads/COMP_383-483_compbio/speciesmodifnozeros.txt",header = FALSE) # where the species with zero hits are removed
species <- data.frame(species)
speciesaccession <- list()
inds <- list()
# notmatch <- list()

# Run once
for (i in 1:length(species$V1)) {
  for (j in 1:length(speciesinforemovezero$ICTVnames)) {
    if (species$V1[i] == speciesinforemovezero$ICTVnames[j]) {
      inds <- c(inds,i)
      speciesaccession <- c(speciesaccession, species$V1[i])
    } #else {
      #notmatch <- c(notmatch, speciesinforemovezero$ICTVnames[j])
    #}
  }
}

length(speciesinforemovezero$ICTVnames) # 2457
length(inds) # 2216
length(speciesinforemovezero$ICTVnames) == length(inds) # FALSE
length(speciesaccession) == length(inds) # TRUE

write.table(speciesaccession, file = "~/Downloads/COMP_383-483_compbio/speciestolookfor.txt",row.names = FALSE, col.names = FALSE)

################################



# Next Steps: modify the mstoremodify variable so to remove repeat sequences and remove sequences that do not have header ">NC_number " OR
                # can create a function similar to fastaseqretrieval that implements entrez_link instead of entrez_fetch to retrieve accession ids 
                # that will retrieve fasta sequences with ">NC_number" header
# Next Steps: use NCBI created accession number list from ICTV database as batch search NCBI to get equivalent fasta and add to database
# Next Next Steps: VIRIDIC with in-house database to run user input fasta sequence and determine similarities (Jacob working on figuring out VIRIDIC requirements)

            
#next steps as of 4/11/2022: we are no longer using VIRIDIC. We will utilize the VICTOR web service from https://ggdc.dsmz.de/victor.php# 
                
                
            
