
// to re-assign x and y values of nodes to achieve a tree like structure (uses BFT; todo using DFT)

void AssignCoordinates(){
  ArrayList<node> rootNodes = new ArrayList<node>();
  ArrayList<node> childNodes = new ArrayList<node>();
  ArrayList<String> nodesDone = new ArrayList<String>();
  int ystorage;
  int y=0;
  
  // get the rootnodes
  try{    
    for(node Node : nodes){    
      int flag = 0;
      //br = createReader("fromAndTo.txt");
      //String temp = br.readLine();    
      //  while(temp != null){
        for(String temp : readStrings){
          String[] tempArray = split(temp,":");          
          String[] temp2 = split(tempArray[1], ",");
          if(temp2[0].equals(Node.nodeName) & (!tempArray[0].equals(""))){
            flag = 1;
            break;
          }
          //temp = br.readLine();
        }
      if(flag == 0){
        if(Node.size > y){
          y = Node.size;
        }
        rootNodes.add(Node);
        nodesDone.add(Node.nodeName);  
      }
    }
    println(rootNodes.size());
    //br.close();
  }
  catch(Exception e){
    println("some error occured during reading file - 3");
  }
  
  // initial value of y
  y = (y*8) + 5;
  
  //Assign coordinates to child nodes recursively(through iteration) 
  while(rootNodes.size() != 0){
    // initial configuration for each level of nodes
    int x = Width/(rootNodes.size()+1);  
    ystorage = 0;
    
    for(int j=0;j<rootNodes.size();j++){
      //code to assign the x and y value to each of the node in the level.
      node rootnode = rootNodes.get(j);
      rootnode.x = x;
      rootnode.y = y;
      if(rootnode.size > ystorage){
        ystorage = rootnode.size;
      }      
      
      //code to add the child nodes.
      for(int i=0; i<nodesFrom.size();i++){
        node tempFrom = nodesFrom.get(i);
        node tempTo = nodesTo.get(i);
        if(rootnode.nodeName.equals(tempFrom.nodeName) & !(nodesDone.contains(tempTo.nodeName))){
          childNodes.add(tempTo);
          nodesDone.add(tempTo.nodeName);
        }
        
      }    
      x = x + Width/(rootNodes.size()+1) + 5;
    }
    rootNodes = childNodes;
    childNodes = new ArrayList<node>();
    y=y+(ystorage*8)+100;
  }
}

