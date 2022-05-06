"""
Created on Mon Apr 18 17:30:35 2022

@author: jgrandinetti
"""
## credit to JoergVanAken on Stack Overflow for sharing code to remove overlaps using depth first search in a graph
## https://stackoverflow.com/questions/54969074/python-3-remove-overlaps-in-table/55716443#55716443?newreg=bee73dc269464a38b8b22bf3ace5549b
## many modifications have been made to serve the project, but much of the core code remains the same
## His code kept the smallest value in an overlapping sequence, while for our purposes we wanted the largest to be represented in total nident

import pandas as pd
import numpy as np
import os 

current = os.getcwd()

fileA = pd.read_csv(current + '/results/blastoutA.csv', sep = '\t') #opening blastoutA which is forwards blast output in the user results folder as dataframe
fileB = pd.read_csv(current + '/results/blastoutB.csv', sep = '\t') #opening blastoutB which is reciprocal blast output in the user results folder as dataframe

fileA.columns = ['input_accessionID', 'database_accessionID', 'qstart', 'qend', 'nident','input_length'] #column labels added to dataframes
fileB.columns = ['input_accessionID', 'database_accessionID', 'qstart', 'qend', 'nident','input_length']

fileA.name = 'blastoutA' #giving dataframes names to identify them in the totident function
fileB.name = 'blastoutB'

def totident(df): #function to find totident
    
    if df.name == 'blastoutA':
        accessionID = 'database_accessionID'
    else:
        accessionID = 'input_accessionID'
        
    #changing accession depending on dataframe name because either database or input will have 1 non changing ID
    #and we want the column with many accessions so that we can sort correctly
    
    df['ID'] = range(df.shape[0])
    df['Interval'] = df.apply(lambda x: pd.Interval(x['qstart'], x['qend'], closed='both'), axis=1) # dataframe based on the hsp intervals
    
    columns = [accessionID, 'Interval', 'ID'] #new dataframe columns for df
    connected = df[columns].merge(df[columns], on = accessionID) #merging new columns with df to create new dataframe, connected
    connected['Overlap'] = connected.apply(lambda x: x['Interval_x'].overlaps(x['Interval_y']), axis=1)  #mapping all overlaps into x and y and on connected df
    connected = connected.loc[connected['Overlap'] == True, [accessionID, 'ID_x', 'ID_y']]
    
    graph = connected.groupby([accessionID, 'ID_x']).agg(list) #using dataframe of overlaps to create graph of aggregated overlaps (x -> y)
                                                  
    def connections(graph, id): #function to create depth first search from graph
        def dict_to_df(d): # function to convert dictionaries into dataframes: keys are ID, values are subgraph
            df = pd.DataFrame(data=[d.keys(), d.values()], index=['ID', 'Subgraph']).T
            df['id'] = id
            return df[['id', 'Subgraph', 'ID']]
    
        def dfs(node, num): #dfs to go down graph and find largest overlaps
            visited[node] = num
            
            for _node in graph.loc[node].iloc[0]:
                if _node not in visited:
                    dfs(_node, num)
    
        visited = {} #visited dictionary appends all visited nodes
        graph = graph.loc[id]
        
        for (num, node) in enumerate(graph.index):
            if node not in visited:
                dfs(node, num)
    
        return dict_to_df(visited) #returns df output of dictionary visited
    
    dfs = [] #new empty list for dfs output
    
    for id in graph.index.get_level_values(0).unique(): # for every unique id in graph
        dfs.append(connections(graph, id)) #dfs list is appending output from dfs function
    
    conns = pd.concat(dfs) #list into dataframe
    
    data = df.merge(conns[['Subgraph', 'ID']], on=['ID']) #merging dfs subgraph back to original df based on ID
    
    def select_max(x): # function that finds maximum length in overlapping hsps - ie; rows we want to keep to add to total nident
        m = x['nident'].max() 
        if len(x) > 1 and (x['nident'] == m).all():
            return -1
        else:
            return x['nident'].idxmax()
    
    selected = data.groupby([accessionID, 'Subgraph'])['nident', 'ID'].apply(select_max) #applying function select_max to df data
    selected = selected[selected >= 0] 
    
    max_only = df.loc[df.ID.isin(selected), :].drop(columns=['ID', 'Interval'])
    df_onlysome = max_only[['input_accessionID','database_accessionID','nident']]
    df_new = df_onlysome.groupby(['input_accessionID','database_accessionID']).agg('sum').reset_index() #add remaining hsps to find totnident!
    
    df_new = df_new.rename(columns = {'nident':'totident'}) #renaming nident to totident to avoid confusion
    
    return(pd.merge(left=max_only, right=df_new[[accessionID,'totident']], how='right', on=accessionID))
#merging totident columns to A and B file


with open(current + '/results/totidentA.csv','w') as f: #open csv file to write
    totident(fileA).to_csv(f) #totalident function on fileA to csv
    f.write("\n") # newline between dataframes

with open(current + '/results/totidentB.csv','w') as f: #open csv file to write
    totident(fileB).to_csv(f) #totalident function on fileB to csv
    f.write("\n") # newline between dataframes
