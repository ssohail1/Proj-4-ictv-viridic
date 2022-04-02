#This code automates getting the 3rd sheet from the ICTV master species excel file 

#In order to install pandas on Python3, use this command in terminal -
#sudo apt install python3-pandas
#The rest of the documentation is done in Python3.

import pandas as pd
import csv

#read sheet directly into data frame
#df = pd.read_excel(fileName, SheetName)
df= pd.read_excel(r'ICTV Master Species List 2020.v1.xlsx', 'ICTV2020 Master Species List#36')

# In order to get the number of the `Species` column, 
print(df.columns)
# This shows that the `Species` column is the 16th column
data = df.iloc[:,15]
header = ['Species']

# This will write the data frame to a csv file without the index
# Each species name will be in an individual row with `Species` as the header
csv_data = data.to_csv("/home/rprag/species1.csv", index = False)
