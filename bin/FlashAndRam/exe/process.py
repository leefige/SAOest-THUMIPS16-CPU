f = open("ram2.data")
for line in f:
    print(line.strip().split('=')[1])
