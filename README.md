# Proj-4-ictv-viridic

# Introduction
This is a Python wrapper for a pipeline that simplifies the process of classifying new viral sequences per ICTV classifications. 

# Installation and Dependencies

## ICTV Master Species List
ICTV publishes a Master Species List every year which includes the new additions and updates to viral taxonomy. These excel files can be found [here](https://talk.ictvonline.org/files/master-species-lists/m/msl) on the ICTV website.  

## BLAST
- commands to download and install current version of BLAST for linux server

```sudo apt-get update```

```sudo apt-get install ncbi-blast+```

- to check that it is correctly installed type

```blastn help```

## User Requirements
- Install pandas package for dist calculations: ```sudo apt install python3-pandas```
- Install seaborn package to make heatmap: ```pip install seaborn```
- Install dependencies for installing rentrez:
```
sudo apt-get install libssl-dev
sudo apt-get install libxml2-dev
sudo apt-get install libcurl4-openssl-dev
sudo apt install r-cran-devtools
install_github("ropensci/rentrez")
```
## User Instructions
1. Run below code to download necessary run files from github
- ```sudo apt install subversion```
- ```svn checkout https://github.com/ssohail1/Proj-4-ictv-viridic/trunk/run```
2. Copy/move your input fasta into the run folder, and modify the user path in the run.py code
- A sample input fasta is included, so by default the code will be run with that data
3. Once in the downloaded folder, run the lines of code below
- ```python3 run1.py```
- ```python3 run2.py```

# Pipeline
1. Download the Master Species List from ICTV website: [Master Species List 2020](https://talk.ictvonline.org/files/master-species-lists/m/msl/12314)
2. Download the Virus Metadata Repository from ICTV website: [Virus Metadata Repository 2021](https://talk.ictvonline.org/taxonomy/vmr/m/vmr-file-repository)
3. Run the VMR python script for parsing the ICTV Virus Metadata Repository excel file where output is a csv file
4. Run the Pandas python script for parsing the ICTV Master Species List excel file where output is a csv file
5. This csv file will be input to R for retrieval of sequences from NCBI using the rentrez package
6. BLASTn the user fasta with inhouse database
- Explanation for sampleblastout A and B, such as column information, can be found in terminalblast.txt
7. Calculate intergenomic similarity distance from BLAST output
- Get total nident by removing overlapping HSPs in BLAST output
- Use total nident and other variables output from BLAST to calculate intergenomic similarity distance
8. Next Steps: 
    - We can have the class machine run this Rscript in the background with nohup and using the & option
    - Retrieve the accession ids for all species that yield greater than 0 hits from NCBI searches
    - Retrieve the fasta sequences by doing a search with all accession ids as input
    - Parse through the fasta sequence output to only save fasta sequences that start with ">NC_" in the header
## Input

## Output

## Limitations
