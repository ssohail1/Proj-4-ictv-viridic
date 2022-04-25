print('Enter filename:')
filename = input()
print('Enter outputname:')
outputname = input()
with open(filename, 'r') as f, open(outputname, 'w') as fo:
    for line in f:
        fo.write(line.replace('"', '').replace("'", ""))
