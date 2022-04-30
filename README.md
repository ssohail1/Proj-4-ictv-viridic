# Proj-4-ictv-viridic

1. Download the master species list from ICTV website: [Master Species List 2020](https://talk.ictvonline.org/files/master-species-lists/m/msl/12314)
2. Open the downloaded xlsx file and go to the third sheet
3. Save the third sheet as a csv file 
4. This csv file will be input to R for retrieval of sequences from NCBI using the rentrez package
5. Steps 2 - 4 will be completed using the pandas python script
6. BLASTn the user fasta with inhouse database
- Explanation for sampleblastout A and B, such as column information, can be found in terminalblast.txt
8. Figure out intergenomic similarity distance from BLAST output
- Get total nident by removing overlapping HSPs in BLAST output
- Use total nident and other variables output from BLAST to calculate intergenomic similarity distance
10. Next Steps: 
    - We can have the class machine run this Rscript in the background with nohup and using the & option
    - Retrieve the accession ids for all species that yield greater than 0 hits from NCBI searches
    - Retrieve the fasta sequences by doing a search with all accession ids as input
    - Parse through the fasta sequence output to only save fasta sequences that start with ">NC_" in the header

# User Instructions
1. Run below code to download necessary run files from github
- ```sudo apt install subversion```
-```svn checkout https://github.com/ssohail1/Proj-4-ictv-viridic/trunk/run```
2. Once in the downloaded folder, run the line code below
-```python3 run.py```
