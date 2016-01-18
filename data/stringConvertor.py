f = open("fromAndTo.txt")
fw = open("string.pde","w")
temp = f.readline()
i=0
while temp != "" :
    temp = temp.split('\n')[0]
    temp = temp.replace("\"\"","")
    if i!=0 :
        fw.write(',')        
    else :
        i=i+1
        fw.write("String[] readStrings = {")
    writeString = "\""+ temp + "\""
    fw.write(writeString)
    temp = f.readline()
    
fw.write("};")
print "done"
