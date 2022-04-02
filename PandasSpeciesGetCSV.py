#This code automates getting the 3rd sheet from the ICTV master species excel file 

#In order to install pandas on Python3, use this command in terminal -
#sudo apt install python3-pandas
#The rest of the documentation is done in Python3.

import pandas as pd
import csv

#read sheet directly into data frame
#df = pd.read_excel(fileName, SheetName)
df= pd.read_excel(r'ICTV Master Species List 2020.v1.xlsx', 'ICTV2020 Master Species List#36')

#make list of species data using tolist (method)
data = df['Species'].tolist()

#write to Species.csv file to be used in our for loop 
with open ('species.csv', 'w') as f:
    writer = csv.writer(f)
    writer.writerow(data)
