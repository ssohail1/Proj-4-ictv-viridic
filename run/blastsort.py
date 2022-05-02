"""
Created on Mon Apr 18 17:30:35 2022

@author: jgrandinetti
"""

import pandas as pd
import numpy as np

current = os.getcwd()

fileA = pd.read_csv(current + 'results/blastoutA.csv', sep = '\t')
fileB = pd.read_csv(current + 'results/blastoutB.csv', sep = '\t')

fileA.columns = ['input_accessionID', 'database_accessionID', 'qstart', 'qend', 'nident','input_length']
fileB.columns = ['input_accessionID', 'database_accessionID', 'qstart', 'qend', 'nident','input_length']

fileA.name = 'blastoutA'
fileB.name = 'blastoutB'

def totident(df):
    
    if df.name == 'blastoutA':
        accessionID = 'database_accessionID'
    else:
        accessionID = 'input_accessionID'
        
    #changing accession depending on file because either database or input will have 1 non changing ID
    #and we want the column with many accessions so that we can sort correctly
    
    df['ID'] = range(df.shape[0])
    df['Interval'] = df.apply(lambda x: pd.Interval(x['qstart'], x['qend'], closed='both'), axis=1)
    
    columns = [accessionID, 'Interval', 'ID']
    connected = df[columns].merge(df[columns], on = accessionID)
    connected['Overlap'] = connected.apply(lambda x: x['Interval_x'].overlaps(x['Interval_y']), axis=1) 
    connected = connected.loc[connected['Overlap'] == True, [accessionID, 'ID_x', 'ID_y']]
    
    graph = connected.groupby([accessionID, 'ID_x']).agg(list)
                                                  
    def connections(graph, id):
        def dict_to_df(d):
            df = pd.DataFrame(data=[d.keys(), d.values()], index=['ID', 'Subgraph']).T
            df['id'] = id
            return df[['id', 'Subgraph', 'ID']]
    
        def dfs(node, num):
            visited[node] = num
            
            for _node in graph.loc[node].iloc[0]:
                if _node not in visited:
                    dfs(_node, num)
    
        visited = {}
        graph = graph.loc[id]
        
        for (num, node) in enumerate(graph.index):
            if node not in visited:
                dfs(node, num)
    
        return dict_to_df(visited)
    
    dfs = []
    
    for id in graph.index.get_level_values(0).unique():
        dfs.append(connections(graph, id))
    
    conns = pd.concat(dfs)
    
    data = df.merge(conns[['Subgraph', 'ID']], on=['ID'])
    
    def select_max(x):
        m = x['nident'].max()
        if len(x) > 1 and (x['nident'] == m).all():
            return -1
        else:
            return x['nident'].idxmax()
    
    selected = data.groupby([accessionID, 'Subgraph'])['nident', 'ID'].apply(select_max)
    selected = selected[selected >= 0]
    
    max_only = df.loc[df.ID.isin(selected), :].drop(columns=['ID', 'Interval'])
    df_onlysome = max_only[['input_accessionID','database_accessionID','nident']]
    df_new = df_onlysome.groupby(['input_accessionID','database_accessionID']).agg('sum').reset_index()
    
    df_new = df_new.rename(columns = {'nident':'totident'})
    
    return(pd.merge(left=max_only, right=df_new[[accessionID,'totident']], how='right', on=accessionID))


with open(current + 'results/totidentA.csv','w') as f: #open csv file to write
    totident(fileA).to_csv(f) #write dataframe from list to csv
    f.write("\n") # newline between dataframes

with open(current + 'results/totidentB.csv','w') as f: #open csv file to write
    totident(fileB).to_csv(f) #write dataframe from list to csv
    f.write("\n") # newline between dataframes
