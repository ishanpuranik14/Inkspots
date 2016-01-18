f = open("prereq.csv")
fw = open("fromAndTo.txt","w")
temp = f.readline
i=0
while temp != "" :
    if i==0 :
        i=i+1
        temp = f.readline()       #ignore the first line
    else :        
        i=i+1
        child = temp.split(",")[0]
        child = "".join(child.split('"'))
        child = "".join(child.split(" "))
        j=0
        parents = []
        while True :
            if temp.split(",")[j+1].count(".") == 2:
                parents.append(temp.split(",")[j+1])
                j=j+1
            else :
                break
        difficulty = temp.split(",")[j+1]
        k = j+2
        l=j-1
        prereqStrengths = []
        while True :
            if "." in temp.split(",")[k] :
                prereqStrengths.append(temp.split(",")[k])
                k=k+1
            else :
                break
        progress = temp.split(",")[k]
        progress = "".join(progress.split('"'))
        inference = temp.split(",")[k+1]
        inference = "".join(inference.split('"'))
        if j > 1 :
            for parent,prereqStrength in zip(parents, prereqStrengths) :
                parent = "".join(parent.split('"'))
                prereqStrength = "".join(prereqStrength.split('"'))
                string = parent + ":" + child + "," + str(difficulty) + "," + prereqStrength + "," + progress + "," + inference
                fw.write(string)                
                l=l-1
        ## below handle list for orphan node
        else:
            if len(parents) == 0 :
                parent = ""
                difficulty = temp.split(",")[2]
                prereqStrength = temp.split(",")[3]
                progress = "".join(temp.split(",")[4].split('"'))
                inference = temp.split(",")[5]
            else:
                parent = "".join(parents[0].split('"'))
                prereqStrength = "".join(prereqStrengths[0].split('"'))
            string = parent + ":" + child + "," + str(difficulty) + "," + prereqStrength + "," + progress + "," + inference
            fw.write(string)
    print temp.split(",")
    temp = f.readline()
    if temp == "" :
        print "Done"
