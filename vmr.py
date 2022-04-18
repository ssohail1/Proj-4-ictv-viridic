#Read and assign Virus Metadata Repository (VMR)
#VMR file can be found here: https://talk.ictvonline.org/taxonomy/vmr/m/vmr-file-repository/13181

#need to extract columns ICTV names, NCBI names, genbank , refseq , exemplar or additional
import csv
import pandas as pd

#read sheet directly into data frame
vmr = pd.read_excel(r'VMR 18-191021 MSL36.xlsx')

#Print column name and index
for idx,column in enumerate(vmr.columns):
  print(idx,column)
#ICTV names - 16
#NCBI names - 18
#genbank - 21
#refseq - 22
#exemplar or additional isolate - 17

data = vmr.iloc[:,[16,18, 17, 21, 22]]
csv_data = data.to_csv("/home/rprag/vmr.csv", index = False)
    
