# Proj-4-ictv-viridic

1. Download the master species list from ICTV website: [Master Species List 2020](https://talk.ictvonline.org/files/master-species-lists/m/msl/12314)
2. Open the downloaded xlsx file and go to the third sheet
3. Save the third sheet as a csv file 
4. This csv file will be input to R for retrieval of sequences from NCBI using the rentrez package
5. Save the ICTV_VIRIDIC R script and run it to see if everything runs on your local computer or class machine
6. Next Steps: The for-loops take a long time to run, so develop code that will write out the tax_recsp IDs as a text file where each speciesIDs are separated by a new line. We can have the class machine run this Rscript in the background with nohup and using the & option
