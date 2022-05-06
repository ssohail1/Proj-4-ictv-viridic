# Proj-4-ictv-viridic

## Sidra Sohail, Rhea Prag, Jacob Grandinetti, Sabrina Lutfiyeva

### Introduction
This builds a database that simplifies the process of classifying new viral sequences per ICTV classifications. The database is a multi-fasta file with fasta sequences for each ICTV designated species.

#### ICTV Master Species List
ICTV publishes a Master Species List every year which includes the new additions and updates to viral taxonomy. The complete list of files can be found [here](https://talk.ictvonline.org/files/master-species-lists/m/msl) on the ICTV website. The database currenty uses [ICTV Master Species List MSL #37](https://talk.ictvonline.org/files/master-species-lists/m/msl/13425) which was published in March 2022.

#### Virus Repository Resource
ICTV also publishes a developing resource that includes key pieces of information such as viral taxonomy, GenBank accession numbers, RefSeq IDs, and exemplar isolates. The complete list of files can be found [here](https://talk.ictvonline.org/taxonomy/vmr/) on the ICTV website. The database currently uses [Virus Metadata Repository #36](https://talk.ictvonline.org/taxonomy/vmr/m/vmr-file-repository/13181) which was published in October 2021. 

### Installation and Dependencies

#### User Requirements for Linux server
- Install [Python](https://www.python.org/downloads/)
- Install [R](https://cran.r-project.org/) ([RStudio](https://www.rstudio.com/products/rstudio/download/) is optional)  
- Install pandas package for distance calculations: ```sudo apt install python3-pandas```
- Install seaborn package to make heatmap: ```pip install seaborn```
- Install dependencies for installing rentrez:
    - ```sudo apt-get install libssl-dev```
    - ```sudo apt-get install libxml2-dev```
    - ```sudo apt-get install libcurl4-openssl-dev```
    - ```sudo apt install r-cran-devtools```
- Install rentrez:
    - ```install_github("ropensci/rentrez")``` 

#### BLAST
- commands to download and install current version of BLAST for linux server

```sudo apt-get update```

```sudo apt-get install ncbi-blast+```

- to check that it is correctly installed

```blastn help```

#### User Instructions
1. Run below code to download necessary run files from github
- ```sudo apt install subversion```
- For using full complete data: ```svn checkout https://github.com/ssohail1/Proj-4-ictv-viridic/trunk/run```
- For test data: ```svn checkout https://github.com/ssohail1/Proj-4-ictv-viridic/trunk/sample_data```
3. Copy/move your input fasta into the run folder, and modify the user path in the run.py code
- A sample input fasta is included, so by default the code will be run with that data
    - The SIRV3.fasta is the sample input multi-fasta and contains three fasta sequences (for the run folder) and two sequences (for the sample_data folder)
4. Once in the downloaded folder, run the lines of code below
- ```Rscript fullfastadownload.R```
- ```Rscript accessions.R``` _(not applicable for the sample_data)_
- ```python3 modify_fasta.py```
- ```python3 run2.py```

### Pipeline
1. Download the Master Species List from ICTV website: [Master Species List 2021](https://talk.ictvonline.org/files/master-species-lists/m/msl/13425)
2. Download the Virus Metadata Repository from ICTV website: [Virus Metadata Repository 2021](https://talk.ictvonline.org/taxonomy/vmr/m/vmr-file-repository)
3. Run the VMR python script for parsing the ICTV Virus Metadata Repository excel file where output is a csv file
4. Run the Pandas python script for parsing the ICTV Master Species List excel file where output is a csv file
5. These csv files will be input to generating_species_list.R to output a csv file with ICTV species names and accession IDs and a text file with ICTV species names
6. The output csv file will be input to fullfastadownload.R and text file will be input to accessions.R (_not applicable to sample_data folder_) and two multi-fasta files will be output
7. The two multi-fasta files will be input to modify_fasta.py to modify headers and output is the database multi-fasta file
8. BLASTn the user fasta with inhouse database
- Explanation for BLAST output can be found in terminalblast.txt
9. Calculate intergenomic similarity distance from BLAST output
- Get total nident by removing overlapping HSPs in BLAST output
- Use total nident and other variables output from BLAST to calculate intergenomic similarity distance
Using precompiled speciesaccessions.csv and speciestolookfor.txt files:
- Run steps 6 - 9
    - For the sample_data folder, only the fullfastadownload.R file needs to be run for step 6 and one multi-fasta file will be output from step 6
#### Input
These are in the order that the files should be run:
Assuming that using the precompiled speciesaccessions.csv and speciestolookfor.txt files
1. fullfastadownload.R: input is speciesaccessions.csv
2. accessions.R: input is speciestolookfor.txt
3. modify_fasta.py: input is the output from fullfastadownload.R and accessions.R files and the speciesaccesions.csv and the test_ictv_.txt files
4. run2.py: input is the database multi-fasta output from modify_fasta.py file

#### Output
1. fullfastadownload.R: output is finfasta3.fasta file
2. accessions.R: output is fasta50_finalfin.fasta file and accessandname.txt file
3. modify_fasta.py: final output is the multi-fasta database output
4. run2.py: output is the csv file containing distances (results.csv), heatmap png file, and totident csv files containing total nident values

#### Limitations
The ICTV Master Species List and Virus Metadata Resource are updated on a yearly basis. It will be integral to download and implement the **most recent** version to return an accurate output. 

Furthermore, the speciesaccessions.csv does not include species from the Master Species List that do not return hits from NCBI. These are excluded from the tool and put into a separate text file for the user. 

The tool is also limited to distance calculations. While the BLAST does alignment, anything beyond distance calculations is not explored. It will be up to the user to how they want to address their questions.
