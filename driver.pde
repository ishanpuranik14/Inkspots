
// this is for reading the file, creating nodes and rendering them.

IntDict strengths = new IntDict();
FloatDict difficulties = new FloatDict();
StringDict progresses = new StringDict();
ArrayList<node> nodes = new ArrayList<node>();
//BufferedReader br;
node selectedNode = null;
ArrayList<node> nodesFrom = new ArrayList<node>();
ArrayList<node> nodesTo = new ArrayList<node>();
FloatList prereqStrengths = new FloatList();
IntDict inferences = new IntDict();

int Width = 1600, scrollFlag = 0, colorFlag = 0, edgeRectFlag = 1;

//add support for new node format.add support for orphan nodes.
//edge thickness acc. to prereq strength
  
void setup(){
  size(1350,770);          // change when you want to alter the image size.
  background(255);
  //Reading from file and adding to dictionary(name and strength)
  try{
    //br = createReader("fromAndTo.txt");
    //String temp = br.readLine();
    //while(temp != null){
      for(String temp : readStrings){
        String[] tempArray = split(temp,":");
        String temp1 = tempArray[0];
        String[] temp2 = split(tempArray[1],",");
        if(temp1.equals("")){
          strengths.add(temp2[0], 0);          
        }
        else{
          strengths.add(temp1, 1);        
          strengths.add(temp2[0], 1);          
        }
        if(!difficulties.hasKey(temp2[0])){
            difficulties.add(temp2[0], float(temp2[1]));
          }
        if(!progresses.hasKey(temp2[0])){
            progresses.set(temp2[0], temp2[3]);
          }
        if(!inferences.hasKey(temp2[0])){
            inferences.set(temp2[0], int(temp2[4]));
          }
        //temp = br.readLine();
      }
    //br.close();
  }
  catch(Exception e){
    println("some error occured during reading file - 1");
  }
  strengths.sortValuesReverse();
  int i=0;
  
  //creating nodes and assigning x,y, name and strength values
  for(String Key : strengths.keys()){
    int value = strengths.get(Key);
    float difficulty = difficulties.get(Key);
    String progress = progresses.get(Key);
    int inference = inferences.get(Key);
    if(i == 0){
      nodes.add(new node(width/2, height/2, Key, value, difficulty, progress, inference));
      i = i+1;
    }
    else{
      while(true){        
        int randx = int(random((0 + (value * 20)),(width - (value * 20))));
        int randy = int(random((0 + value * 20),(height - (value * 20))));
        int flag = 0;
        for(node Node : nodes){
          if(Node.doesOverlap(randx, randy, value)){
            flag = 1;
            break;
          }
        }
        if(flag == 0){
          nodes.add(new node(randx, randy, Key, value, difficulty, progress, inference));
          i = i+1;
          break;
        }
      }
    }
  }
  
  //Reading from file and adding to dictionaries(name and strength)- from and to
  try{
    //br = createReader("fromAndTo.txt");
    //String temp = br.readLine();
    //  while(temp != null){
      for(String temp : readStrings){
        String[] tempArray = split(temp,":");
        String temp1 = tempArray[0];
        String[] temp2 = split(tempArray[1],",");
        if(!temp1.equals("")){
          for(node Node : nodes){
            if(temp1.equals(Node.nodeName)){
              nodesFrom.add(Node);
            }
            if(temp2[0].equals(Node.nodeName)){
              nodesTo.add(Node);
            }
          }
        prereqStrengths.append(Float.parseFloat(temp2[2]));         
        }
        //temp = br.readLine();
      }
    //br.close();
  }
  catch(Exception e){
    println("some error occured during reading file - 2");
  }
  
  AssignCoordinates();
}

void draw(){
  // clear the screen
  background(255);
  //code to draw lines between nodes
  if(edgeRectFlag == 1){
      for(int i=0; i<nodesFrom.size();i++){
        node tempFrom = nodesFrom.get(i);
        node tempTo = nodesTo.get(i);
        float prereqStrength = prereqStrengths.get(i);
        if(prereqStrength == 0.9){
          strokeWeight(1);
        }
        else if(prereqStrength == 0.99){
          strokeWeight(2);
        }
        else{
          strokeWeight(4);  
        }
        //edit trial: for giving some edges a special colour
        if((selectedNode != null) & ((tempFrom ==  selectedNode) | (tempTo ==  selectedNode))){
          if(tempTo ==  selectedNode){
            stroke(231,50,80);
          }
          else if(tempFrom ==  selectedNode){
            stroke(244,179,25);
          }
          else{
          }
        }
        else{
          stroke(0);
        }
        // finish of trial code
        line(tempFrom.x,tempFrom.y,tempTo.x,tempTo.y);
      }
    }
    
  // trial to give the neighbours of selected node a stroke color, when the edges are not visible
  if(edgeRectFlag == 0){
    for(int i=0; i<nodesFrom.size();i++){
        node tempFrom = nodesFrom.get(i);
        node tempTo = nodesTo.get(i);
        if((selectedNode != null) & ((tempFrom ==  selectedNode) | (tempTo ==  selectedNode))){
          if(tempTo ==  selectedNode){
            tempFrom.render(colorFlag,1);
            //stroke(231,50,80);
          }
          else if(tempFrom ==  selectedNode){
            tempTo.render(colorFlag,2);
            //stroke(244,179,25);
          }
        }
    }
  }
  //trial finished
    
  // handling right click selection and dragging of nodes : trial
  if(selectedNode != null & (mouseButton == RIGHT)){
    for(int i=0; i<nodesFrom.size();i++){
      node tempFrom = nodesFrom.get(i);
      node tempTo = nodesTo.get(i);
      if(tempFrom == selectedNode){
        tempTo.x = tempTo.x + (mouseX - pmouseX);
        tempTo.y = tempTo.y + (mouseY - pmouseY);
      }
    }
  }
  // trial finished
  
  // rendering the nodes
  for(node Node : nodes){
    Node.render(colorFlag,0);
  }
  
  // rendering the rectangles for showing directedness
  if(edgeRectFlag == 1){
    for(int i=0; i<nodesFrom.size();i++){
      node tempFrom = nodesFrom.get(i);
      node tempTo = nodesTo.get(i);    
      rectMode(CENTER);
      fill(74);
      rect((tempTo.x+((tempTo.size*8)*((tempFrom.x - tempTo.x)/( dist(tempFrom.x, tempFrom.y, tempTo.x, tempTo.y))))),(tempTo.y+((tempTo.size*8)*((tempFrom.y - tempTo.y)/( dist(tempFrom.x, tempFrom.y, tempTo.x, tempTo.y))))),6,6);
    }
  }
  
  // display text if hover above the nodes
  for(node Node : nodes){
    Node.hover(mouseX, mouseY);
  }
  
}

void mousePressed(){
  if(get(mouseX, mouseY) == -1){
    scrollFlag = 1;
    return;
  }
  for(node Node : nodes){
    if(Node.isSelected(mouseX, mouseY)){
      selectedNode = Node;
      break;
    }
  }
}

void mouseDragged(){
  if(scrollFlag == 1){
    scrollDragged();
    return;
  }
  else if(selectedNode != null){
    selectedNode.selectedAction(mouseX, mouseY);
  }
  else{
  }
}

void mouseReleased(){
  if(scrollFlag == 1){
    scrollFlag = 0;
  }
  selectedNode = null;
}

void keyPressed(){
  if(key == 's'){
    println("saving....");
    saveFrame("graph.png");
  }
  if(key == 't'){
    colorFlag = abs(colorFlag - 1);
  }
  if(key == 'e'){
    edgeRectFlag = abs(edgeRectFlag - 1);
  }
}
