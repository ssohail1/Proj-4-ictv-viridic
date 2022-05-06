'''
This code assembles the speciesaccessions.csv file and speciestolookfor.txt file. The speciesaccessions.csv file will be input to fullfastadownload.R.
The speciestolookfor.txt file will be input to accessions.R.
The input files and generating_species_list.R file need to be in same folder.
'''

# Installation
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


# Note: entrez prints error message when loop through many species
# There are species in the ICTV master species list that result in no hits found when running entrez_search()



# Taking the csv file created using `PandasSpeciesGetCSV.py`,
# This file has the list of species names from the ICTV Master Species List
specieslist <- read.csv("species.csv")
length(specieslist[[1]])
# This should return as 9110

library(rentrez)

# modifying the pandas python species output to exclude species that give zero hits
species <- read.table(file="~/Downloads/COMP_383-483_compbio/species.csv", header= TRUE, sep = "\n") # from Pandas python script


# run once -  will take about two days to run ; do not run if have specieszero.txt file
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

species <- read.csv("~/Downloads/COMP_383-483_compbio/speciesmodifnozeros.txt",header = FALSE)
# vmr.csv is file from parsing through the VMR excel file in python
speciesinfo <- read.csv("~/Downloads/vmr.csv")
colnames(speciesinfo) <- c("ICTVnames", "NCBInames", "ExemplarOrAdditional", "GenBankIDs", "RefSeqIDs")

# do not run if already have vmrupd.csv
cou122 <- 0
for (i in 1:length(speciesinfo$RefSeqIDs)) {
  # if there are empty/blanks in the RefSeq id then put zero 
  if (speciesinfo$RefSeqIDs[i] == "") {
    cou122 <- cou122 + 1 # there are 3704 blanks in the RefSeqIDs column
    speciesinfo$RefSeqIDs[i] <- "zero"
  }
}
count1 <- 0
for (i in 1:length(speciesinfo$ExemplarOrAdditional)) {
  # remove the rows where the E or A column is "A"
  if (speciesinfo$ExemplarOrAdditional[i] == "A") {
    count1 <- count1 + 1 # there are 1453 rows that have A 
    speciesinfo<- speciesinfo[-i,]
  }
}
write.csv(speciesinfo,file= "~/Downloads/COMP_383-483_compbio/vmrupd.csv",row.names = FALSE)



speciesinfo <- read.csv("~/Downloads/COMP_383-483_compbio/vmrupd.csv",header = TRUE)
speciesinfo1 <- data.frame(matrix(ncol = length(colnames(speciesinfo)), nrow = length(rownames(species))))
count <- 0
for (i in 1:length(speciesinfo[,2])) {
  for (j in 1:length(species[,1])) {
    # if the ICTV name from the vmrupd.csv file (speciesinfo) matches
    # the ICTV name in speciesmodifnozeros txt file (species) then 
    # add that row from speciesinfo to speciesinfo1
    if (speciesinfo$ICTVnames[i] == species$V1[j]) {
      speciesinfo1[j,] <- speciesinfo[i,]
    } else {
      count <- count + 1
    }
  }
}
co <- 0
colnames(speciesinfo1) <- colnames(speciesinfo)
for (i in 1:length(speciesinfo1$GenBankIDs)) {
  if (speciesinfo1$GenBankIDs[i] == "") {
    co <- co + 1  # 73
    # there are 73 ICTV species that do not have GenBank IDs
    speciesinfo1$GenBankIDs[i] <- "zero"
  }
}
write.csv(speciesinfo1,file = "~/Downloads/COMP_383-483_compbio/speciesupd.csv",row.names = FALSE)
speciesinfo1 <- read.csv("~/Downloads/COMP_383-483_compbio/speciesupd.csv",header=TRUE)
species1 <- data.frame(matrix(ncol = length(colnames(speciesinfo1)), nrow = co))
coun <- 0
for (i in 1:length(speciesinfo1[,1])) {
  if (speciesinfo1$GenBankIDs[i] == "zero") {
    coun <- coun + 1   # 73
  }
}

colnames(species1) <- colnames(speciesinfo1)
speciesacc <- data.frame(matrix(ncol = 2, nrow = 8792))

# making a list of available accession IDs for ICTV species
speciesacc$X1 <- speciesinfo1$ICTVnames
for (i in 1:length(speciesinfo1[,1])) {
  # when RefSeqIDs is not equal to zero add that ID to 
  # speciesacc and when GenBankIDs is not equal to zero than
  # add that ID to speciesacc otherwise add zero
  if (speciesinfo1$RefSeqIDs[i] != "zero") {
    speciesacc$X2[i] <- speciesinfo1$RefSeqIDs[i]
  } else if (speciesinfo1$GenBankIDs[i] != "zero") {
    speciesacc$X2[i] <- speciesinfo1$GenBankIDs[i]
  } else {
    speciesacc$X2[i] <- "zero"
  }
}
colnames(speciesacc) <- c("ICTVnames","accessionIDs")
# adding ICTV species that have zero as ID to sp
sp <- vector()
for (i in 1:length(speciesacc$ICTVnames)) {
  if (speciesacc$accessionIDs[i] == "zero") {
    sp <- c(sp,speciesacc$ICTVnames[i])
  }
}
# removing ICTV species that have zero as accession ID from speciesacc
for (i in 1:length(speciesacc$ICTVnames)) {
  if (speciesacc$accessionIDs[i] == "zero") {
    speciesacc <- speciesacc[-i,]
  }
}
write.table(sp, file = "speciestosearch.txt",row.names = FALSE)
write.csv(speciesacc,file = "~/Downloads/COMP_383-483_compbio/speciesaccessions.csv",row.names = FALSE)

species <- read.csv("/home/ssohail/speciesaccessions.csv", header = TRUE)
IDsaccess <- species$accessionIDs
# speciesaccessions.csv is input to the fullfastadownload.R file
                
            
