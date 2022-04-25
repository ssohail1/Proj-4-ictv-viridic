#because prior step output includes unnecessary quotations that cannot be read in a fasta file, we need to remove them for blast to run

print('Enter filename:')
filename = input() #use full path name here!

print('Enter outputname:')
outputname = input()

with open(filename, 'r') as f, open(outputname, 'w') as fo:
    for line in f:
        fo.write(line.replace('"', '').replace("'", ""))
