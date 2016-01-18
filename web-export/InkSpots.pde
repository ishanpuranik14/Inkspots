/*This is the InkSpots Graph Visualizer built by Ishan Puranik in June 2014.
The current version accepts a particular data format, and suits the needs of Snapwiz Edutech Inc, India 
which is a subsidiary of Snapwiz Inc, USA, where I work as a summer intern(mid May 2014 - mid July 2014).
The code skeleton can be altered to suit various input format and functionality requirements.
Currently it comes with a set of basic functionalities :
1. press 't' to toggle colour modes
2. Press 'e' to show/ hide edges
3. press 's' to store the current Frame as 'graph.png'
4. nodes can be dragged using left mouse button an
5. nodes along with 1st level children can be dragged together using the right mouse button.
6. The graph can be explored by dragging the mouse on the canvas.

for more details, you can view the 2-3 page documentation. It gives a better picture.
Enjoy playing with it!
For any queries, you can mail me at: ishanpuranik14 (at) gmail (dot) com*/
// Description of a node.

static int maxstrength = 0;

class node{
  public int x, y;
  public String nodeName;
  public int sizE;
  public float difficulty;
  public String progress;
  public int infered;
  // constructor  
  public node(int xc, int yc,String name, int Size, float Difficulty, String Progress, int Infered){
    x=xc;
    y=yc;
    nodeName = name;
    sizE = Size;
    if(sizE == 0){
      sizE = 1;
    }
    setMaxStrength(sizE);
    difficulty = Difficulty;
    progress = Progress;
    infered = Infered;
  }
  
  // set the max strength
  public void setMaxStrength(int strength){
    if(strength > maxstrength){
      maxstrength = strength;
    }
  }
  
  // render the node's visual
  public void render(int colorFlag, int strokeFlag){  
    ellipseMode(CENTER);
    if(colorFlag == 0){
      fill(2,map(difficulty, 0, 1,190,40),map(difficulty, 0, 1,190,40),240);
    }
    else{
      if(progress.equals("Pass")){
        fill(2,190,119,240);        
      }
      else{
        fill(194,43,13,240);
      }
    }
    if(strokeFlag == 0){
      noStroke();
    }
    else if(strokeFlag == 1){
      stroke(231,50,80);
    }
    else{
      stroke(244,179,25);
    }    
    //fill(120, 150*(sizE/maxstrength), 200*(sizE/maxstrength));
    ellipse(x,y, sizE*8, sizE*8);
    stroke(0);
  }
  
  // event handling for hover
  public void hover(int mx,int my){
    if((abs(mx-x)<= (sizE*8)) & (abs(my-y)<= (sizE*8))){
      if(dist(mx, my, x, y)<=(sizE*8)){
        fill(0);        
        textAlign(CENTER);
        textSize(14);
        if(infered == 1){
          text(nodeName+" difficulty : "+ difficulty+" Inferred" , 110, 30);
          return;
        }
        text(nodeName+" difficulty : "+ difficulty+" Observed" , 110, 30);
      }
    }
  }
  
  // is the node selected via keeping the mouse pressed for a longer time than a click
  public boolean isSelected(int mx, int my){
     if((abs(mx-x)<= (sizE*8)) & (abs(my-y)<= (sizE*8))){
       if(dist(mx, my, x, y)<=(sizE*8)){        
         return true;
      }     
    }
    return false;
  }
  
  // actions to be performed if he node is selected
  public void selectedAction(int mx, int my){
    x = mx;
    y = my;
  }
  
  //Check whether an ellipse will overlap with this node's ellipse
  public boolean doesOverlap(int sx, int sy, int sSize){
     if(dist(sx, sy, x, y)<((sizE+sSize)*8)){        
         return true;
      }
     return false;
  }
  
}

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
  size(1350,770);          // change when you want to alter the image sizE.
  background(255);
  //Reading from file and adding to dictionary(name and strength)
  try{
    //br = createReader("fromAndTo.txt");
    //String temp = br.readLine();
    //while(temp != null){
      for(int i=0;i<readStrings.length;i++){
        String temp =  readStrings[i];        
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
        prereqStrengths.append(float(temp2[2]));         
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
      rect((tempTo.x+((tempTo.sizE*8)*((tempFrom.x - tempTo.x)/( dist(tempFrom.x, tempFrom.y, tempTo.x, tempTo.y))))),(tempTo.y+((tempTo.sizE*8)*((tempFrom.y - tempTo.y)/( dist(tempFrom.x, tempFrom.y, tempTo.x, tempTo.y))))),6,6);
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
        if(Node.sizE > y){
          y = Node.sizE;
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
      if(rootnode.sizE > ystorage){
        ystorage = rootnode.sizE;
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


// this is working.
void scrollDragged(){
  int xIncrease = 0;    // 0 : decrease; 1 : increase; 
  int yIncrease = 0;    // 0 : decrease; 1 : increase;
  if((mouseX - pmouseX)<0){
    xIncrease = 1;
  }
  else{
    xIncrease = 0;
  }
  if((mouseY - pmouseY)<0){
    yIncrease = 1;
  }
  else{
    yIncrease = 0;
  }
  for(node Node : nodes){
    Node.x = Node.x + (mouseX - pmouseX);
    Node.y = Node.y + (mouseY - pmouseY);
  }
}
String[] readStrings = {":S0.1.0,0.2,,Pass,1",":S0.1.1,0.8,,Pass,1",":S0.1.2,0.5,,Fail,1",":S0.1.3,0.5,,Pass,1",":S0.1.4,0.2,,Pass,1",":S0.1.5,0.5,,Pass,1",":S0.1.6,0.8,,Pass,0","S0.1.3:S0.1.7,0.8,0.99,Pass,1",":S0.2.0,0.5,,Pass,1","S0.1.3:S0.2.1,0.5,0.9,Pass,1","S0.2.1:S0.2.2,0.2,0.99,Pass,0","S0.2.1:S0.2.3,0.5,0.999,Pass,0","S0.2.2:S0.2.4,0.8,0.999,Pass,0","S0.2.3:S0.2.5,0.5,0.99,Pass,0",":S0.3.0,0.5,,Pass,1","S0.1.5:S0.3.1,0.2,0.99,Pass,1","S0.3.4:S0.3.1,0.2,0.999,Pass,1","S0.1.5:S0.3.2,0.2,0.99,Pass,1","S0.2.1:S0.3.2,0.2,0.99,Pass,1","S0.3.2:S0.3.3,0.5,0.999,Fail,1",":S0.3.4,0.5,,Pass,1","S0.3.3:S0.3.5,0.5,0.99,Pass,1","S0.3.0:S0.4.0,0.5,0.9,Pass,0","S0.1.5:S0.4.1,0.5,0.99,Pass,0","S0.3.5:S0.4.2,0.5,0.99,Pass,1","S0.3.5:S0.4.3,0.5,0.999,Pass,1","S0.3.5:S0.4.4,0.5,0.99,Fail,1","S0.3.5:S0.4.5,0.8,0.99,Pass,0","S0.3.2:S0.4.6,0.5,0.99,Pass,1","S0.4.1:S0.4.7,0.5,0.999,Pass,1","S0.4.2:S0.4.7,0.5,0.999,Pass,1","S0.4.3:S0.4.7,0.5,0.9,Pass,1","S0.4.4:S0.4.7,0.5,0.9,Pass,1","S0.4.5:S0.4.7,0.5,0.999,Pass,1","S0.4.6:S0.4.7,0.5,0.9,Pass,1","S0.4.5:S0.4.8,0.5,0.9,Pass,1","S0.4.1:S0.4.9,0.8,0.99,Pass,1","S0.4.2:S0.4.9,0.8,0.99,Pass,1","S0.4.3:S0.4.9,0.8,0.99,Pass,1","S0.4.4:S0.4.9,0.8,0.99,Pass,1","S0.4.5:S0.4.9,0.8,0.999,Pass,1","S0.4.6:S0.4.9,0.8,0.999,Pass,1","S0.4.0:S0.5.0,0.5,0.9,Pass,0","S0.1.5:S0.5.1,0.2,0.9,Pass,1","S0.3.0:S0.5.2,0.5,0.99,Pass,0","S0.5.1:S0.5.2,0.5,0.99,Pass,0","S0.1.0:S0.5.3,0.5,0.9,Pass,1","S0.5.1:S0.5.3,0.5,0.99,Pass,1","S0.4.0:S0.5.4,0.2,0.99,Pass,1","S0.5.1:S0.5.4,0.2,0.99,Pass,1","S0.5.3:S0.5.5,0.5,0.99,Pass,0","S0.5.4:S0.5.5,0.5,0.99,Pass,0","S0.5.1:S0.5.6,0.8,0.99,Pass,1","S0.5.4:S0.5.7,0.5,0.99,Pass,0","S0.1.0:S0.6.0,0.5,0.99,Pass,1","S0.2.0:S0.6.0,0.5,0.99,Pass,1","S0.2.1:S0.6.1,0.5,0.99,Pass,1","S0.6.1:S0.6.2,0.5,0.99,Pass,1","S0.3.4:S0.6.3,0.5,0.99,Pass,1","S0.5.3:S0.6.4,0.2,0.999,Pass,1","S0.6.1:S0.6.4,0.2,0.99,Pass,1","S0.1.5:S0.6.5,0.8,0.99,Pass,1","S0.6.2:S0.6.5,0.8,0.9,Pass,1","S0.6.5:S0.6.6,0.5,0.99,Pass,1","S0.6.1:S0.6.7,0.8,0.99,Pass,1","S0.3.0:S0.7.0,0.5,0.99,Pass,1","S0.6.0:S0.7.1,0.8,0.99,Pass,0","S0.3.1:S0.7.2,0.2,0.9,Pass,1","S0.3.2:S0.7.3,0.5,0.999,Pass,1","S0.7.3:S0.7.4,0.8,0.99,Pass,0","S0.2.1:S0.7.5,0.5,0.9,Pass,0","S0.7.1:S0.7.6,0.2,0.99,Pass,1","S0.7.4:S0.7.7,0.5,0.99,Pass,1","S0.5.0:S1.1.0,0.8,0.99,Pass,0","S0.1.5:S1.1.1,0.5,0.999,Pass,0","S0.3.4:S1.1.1,0.5,0.99,Pass,0","S0.5.0:S1.1.2,0.5,0.999,Pass,0","S0.5.1:S1.1.3,0.8,0.999,Pass,1","S1.1.0:S1.2.0,0.5,0.9,Pass,0","S1.1.1:S1.2.1,0.8,0.99,Pass,1","S1.1.2:S1.2.1,0.8,0.9,Pass,1","S1.1.1:S1.2.2,0.5,0.9,Pass,1","S0.1.4:S1.2.3,0.2,0.9,Pass,1","S1.1.1:S1.2.4,0.8,0.99,Pass,1","S0.1.5:S1.2.5,0.5,0.99,Pass,0","S1.1.1:S1.2.5,0.5,0.99,Pass,0","S1.2.1:S1.2.6,0.8,0.99,Pass,1","S1.2.2:S1.2.6,0.8,0.9,Pass,1","S1.2.3:S1.2.6,0.8,0.99,Pass,1","S1.2.4:S1.2.6,0.8,0.99,Pass,1","S1.2.5:S1.2.6,0.8,0.99,Pass,1","S0.6.0:S1.3.0,0.8,0.9,Pass,0","S0.7.0:S1.3.0,0.8,0.99,Pass,0","S1.2.0:S1.3.0,0.8,0.9,Pass,0","S0.4.0:S1.3.1,0.5,0.99,Pass,1","S1.1.0:S1.3.1,0.5,0.99,Pass,1","S0.6.0:S1.3.2,0.5,0.999,Pass,0","S0.1.5:S1.3.3,0.5,0.999,Pass,0","S0.4.3:S1.3.3,0.5,0.999,Pass,0","S1.3.2:S1.3.3,0.5,0.99,Pass,0","S0.1.4:S1.3.4,0.5,0.99,Pass,1","S1.3.1:S1.3.5,0.8,0.9,Pass,1","S1.3.2:S1.3.5,0.8,0.99,Pass,1","S1.3.3:S1.3.5,0.8,0.9,Pass,1","S1.3.4:S1.3.5,0.8,0.99,Pass,1","S1.3.1:S1.3.6,0.5,0.99,Pass,0","S1.3.2:S1.3.6,0.5,0.9,Pass,0","S1.3.3:S1.3.6,0.5,0.99,Pass,0","S1.3.4:S1.3.6,0.5,0.99,Pass,0","S0.1.5:S1.3.7,0.5,0.99,Pass,1","S0.4.3:S1.3.7,0.5,0.99,Pass,1","S1.3.2:S1.3.7,0.5,0.99,Pass,1","S0.6.2:S1.3.7,0.5,0.99,Pass,1","S0.2.0:S1.4.0,0.2,0.999,Pass,0","S1.1.0:S1.4.0,0.2,0.99,Pass,0","S1.3.0:S1.4.0,0.2,0.999,Pass,0","S1.3.0:S1.4.1,0.5,0.999,Pass,1","S1.3.1:S1.4.2,0.5,0.9,Pass,1","S0.1.5:S1.4.3,0.5,0.99,Pass,0","S0.4.0:S1.4.3,0.5,0.99,Pass,0","S1.4.1:S1.4.4,0.5,0.999,Pass,1","S1.4.2:S1.4.4,0.5,0.99,Pass,1","S1.4.3:S1.4.4,0.5,0.99,Pass,1","S1.4.1:S1.4.5,0.8,0.999,Pass,1","S1.4.2:S1.4.5,0.8,0.9,Pass,1","S1.4.3:S1.4.5,0.8,0.99,Pass,1",":S1.4.6,0.2,,Pass,1","S1.1.0:S1.5.0,0.5,0.99,Pass,1","S1.1.1:S1.5.1,0.2,0.999,Fail,1","S1.1.1:S1.5.2,0.2,0.99,Pass,0","S1.5.1:S1.5.2,0.2,0.99,Pass,0","S1.5.2:S1.5.3,0.5,0.9,Pass,0","S1.5.2:S1.5.4,0.8,0.99,Pass,1","S1.1.1:S1.5.5,0.5,0.99,Pass,1","S1.5.1:S1.5.5,0.5,0.99,Pass,1",":S1.5.6,0.8,,Pass,0","S0.5.0:S1.6.0,0.5,0.99,Pass,1","S1.3.0:S1.6.0,0.5,0.999,Pass,1","S1.5.0:S1.6.0,0.5,0.99,Pass,1","S1.3.0:S1.6.1,0.8,0.99,Pass,1","S1.5.2:S1.6.1,0.8,0.99,Pass,1","S1.1.1:S1.6.2,0.5,0.9,Pass,1","S1.6.1:S1.6.3,0.5,0.9,Pass,1","S1.6.2:S1.6.3,0.5,0.999,Pass,1","S1.6.2:S1.6.4,0.8,0.9,Pass,1","S0.1.0:S1.7.0,0.2,0.9,Pass,1","S1.3.0:S1.7.0,0.2,0.99,Pass,1","S1.5.0:S1.7.0,0.2,0.9,Pass,1","S0.1.0:S1.7.1,0.5,0.999,Fail,1","S1.7.1:S1.7.2,0.5,0.9,Pass,1","S1.7.2:S1.7.3,0.5,0.999,Pass,1","S1.4.0:S2.1.0,0.5,0.99,Pass,1","S0.1.4:S2.1.1,0.8,0.99,Pass,1","S1.3.0:S2.1.2,0.8,0.99,Pass,1","S2.1.1:S2.1.2,0.8,0.99,Pass,1","S2.1.2:S2.1.3,0.8,0.99,Fail,1","S2.1.2:S2.1.4,0.5,0.999,Pass,1","S2.1.3:S2.1.4,0.5,0.99,Pass,1","S2.1.0:S2.2.0,0.8,0.99,Fail,1","S2.1.1:S2.2.1,0.5,0.99,Pass,1","S2.2.1:S2.2.2,0.5,0.99,Pass,0","S2.2.2:S2.2.3,0.2,0.9,Pass,1","S2.2.3:S2.2.4,0.8,0.999,Pass,1","S2.2.4:S2.2.5,0.5,0.99,Pass,0","S2.2.0:S2.3.0,0.5,0.99,Pass,1","S2.2.1:S2.3.1,0.5,0.99,Pass,1","S2.2.0:S2.3.2,0.8,0.99,Pass,1","S2.3.2:S2.3.3,0.5,0.99,Pass,0","S2.3.2:S2.3.4,0.5,0.99,Pass,1","S2.3.2:S2.3.5,0.8,0.99,Pass,1","S2.3.2:S2.3.6,0.5,0.99,Pass,1","S2.3.6:S2.3.7,0.5,0.99,Pass,0","S2.3.5:S2.3.8,0.8,0.99,Pass,1","S2.3.5:S2.3.9,0.5,0.99,Pass,1","S1.3.0:S2.4.0,0.5,0.9,Pass,1","S2.1.0:S2.4.0,0.5,0.99,Pass,1","S2.1.2:S2.4.1,0.2,0.99,Pass,0",":S2.4.2,0.5,,Pass,1","S1.3.3:S2.4.3,0.5,0.99,Pass,1","S2.4.2:S2.4.4,0.5,0.9,Pass,1","S2.4.3:S2.4.4,0.5,0.99,Pass,1","S2.3.0:S2.5.0,0.8,0.99,Pass,1","S2.2.1:S2.5.1,0.5,0.99,Pass,0","S2.5.1:S2.5.2,0.8,0.9,Pass,1","S2.3.0:S2.5.2,0.8,0.99,Pass,1","S2.5.2:S2.5.3,0.5,0.999,Pass,0","S2.5.1:S2.5.4,0.5,0.9,Pass,1","S2.5.1:S2.5.5,0.2,0.9,Pass,1","S2.5.3:S2.5.6,0.5,0.9,Pass,1","S2.1.0:S3.1.0,0.5,0.99,Pass,1",":S3.1.1,0.8,,Pass,1","S3.1.1:S3.1.2,0.5,0.99,Pass,1","S3.1.2:S3.1.3,0.2,0.999,Pass,1","S0.1.4:S3.1.4,0.8,0.99,Pass,1","S1.6.4:S3.1.5,0.2,0.999,Pass,1","S3.1.3:S3.1.6,0.8,0.99,Pass,1","S3.1.1:S3.1.7,0.5,0.9,Pass,1","S2.3.0:S3.2.0,0.8,0.99,Pass,0","S3.1.0:S3.2.0,0.8,0.99,Pass,0","S2.2.5:S3.2.1,0.8,0.99,Pass,1","S3.1.5:S3.2.2,0.2,0.99,Pass,1","S2.3.0:S3.2.3,0.5,0.99,Pass,0","S3.1.0:S3.2.4,0.5,0.999,Pass,1","S3.1.0:S3.2.5,0.5,0.999,Pass,0","S3.1.2:S3.2.6,0.5,0.99,Pass,1","S3.2.5:S3.2.7,0.8,0.99,Pass,0","S3.2.1:S3.2.8,0.5,0.999,Pass,1","S3.2.1:S3.2.9,0.5,0.9,Pass,1","S3.2.0:S3.3.0,0.2,0.999,Pass,0","S3.2.0:S3.3.1,0.8,0.99,Pass,1","S3.3.1:S3.3.2,0.5,0.99,Pass,0","S3.3.1:S3.3.3,0.2,0.9,Pass,1","S3.3.2:S3.3.4,0.5,0.99,Pass,1","S3.3.3:S3.3.4,0.5,0.99,Pass,1","S3.2.6:S3.3.5,0.5,0.99,Pass,1","S3.3.4:S3.3.6,0.8,0.999,Pass,1","S3.3.6:S3.3.7,0.2,0.9,Pass,1","S3.3.0:S3.4.0,0.8,0.99,Pass,0","S3.3.1:S3.4.1,0.5,0.99,Pass,1","S3.4.1:S3.4.2,0.5,0.999,Pass,1","S3.4.2:S3.4.3,0.2,0.99,Pass,1","S3.4.1:S3.4.4,0.8,0.99,Pass,1","S3.4.3:S3.4.5,0.5,0.99,Pass,1","S2.2.0:S3.5.0,0.5,0.99,Pass,1","S3.2.0:S3.5.0,0.5,0.99,Pass,1","S3.1.0:S3.5.1,0.2,0.99,Pass,1","S3.5.1:S3.5.2,0.2,0.99,Pass,1","S3.5.2:S3.5.3,0.5,0.9,Pass,1","S3.5.3:S3.5.4,0.5,0.99,Pass,1","S3.5.3:S3.5.5,0.2,0.9,Pass,1","S3.5.3:S3.5.6,0.2,0.99,Pass,0","S1.2.0:S3.6.0,0.8,0.99,Pass,0","S3.2.0:S3.6.0,0.8,0.999,Pass,0","S1.2.0:S3.6.1,0.5,0.999,Pass,1","S3.6.1:S3.6.2,0.5,0.99,Pass,1","S3.6.2:S3.6.3,0.2,0.999,Pass,1","S3.6.2:S3.6.4,0.8,0.9,Pass,1","S3.6.1:S3.6.5,0.8,0.9,Pass,0","S3.6.2:S3.6.5,0.8,0.99,Pass,0","S3.6.3:S3.6.6,0.5,0.99,Pass,1","S3.6.4:S3.6.6,0.5,0.99,Pass,1","S3.2.0:S4.1.0,0.5,0.99,Pass,1","S3.2.0:S4.1.1,0.5,0.9,Pass,0","S4.1.1:S4.1.2,0.8,0.999,Pass,1","S3.3.0:S4.1.3,0.8,0.9,Pass,1","S4.1.2:S4.1.4,0.5,0.99,Pass,1","S4.1.0:S4.2.0,0.2,0.99,Pass,0","S0.3.1:S4.2.1,0.5,0.99,Pass,1","S3.3.0:S4.2.2,0.5,0.99,Pass,1","S4.1.0:S4.2.3,0.8,0.99,Pass,1","S4.2.3:S4.2.4,0.5,0.99,Pass,0","S4.1.0:S4.2.5,0.2,0.999,Pass,1","S4.2.3:S4.2.6,0.5,0.99,Pass,1","S4.2.4:S4.2.7,0.5,0.999,Pass,1","S4.2.3:S4.2.8,0.5,0.99,Pass,0","S4.2.0:S4.3.0,0.5,0.9,Pass,1","S4.2.1:S4.3.1,0.5,0.99,Pass,1","S4.3.1:S4.3.2,0.5,0.9,Pass,1","S4.3.1:S4.3.3,0.5,0.99,Pass,0","S4.3.2:S4.3.4,0.8,0.9,Pass,1","S4.3.0:S4.4.0,0.5,0.99,Pass,1","S4.3.2:S4.4.1,0.5,0.999,Pass,0","S4.3.1:S4.4.2,0.5,0.999,Pass,1","S4.4.2:S4.4.3,0.2,0.9,Pass,0","S4.4.3:S4.4.4,0.2,0.99,Pass,1","S4.4.4:S4.4.5,0.8,0.99,Pass,1","S4.4.5:S4.4.6,0.8,0.99,Pass,1","S4.4.2:S4.4.7,0.8,0.99,Pass,1","S4.4.4:S4.4.8,0.5,0.99,Pass,1","S4.4.3:S4.4.9,0.5,0.9,Pass,1","S4.4.8:S4.4.10,0.5,0.99,Pass,1","S4.4.8:S4.4.11,0.5,0.99,Pass,1","S4.4.0:S4.5.0,0.5,0.99,Pass,1","S4.4.0:S4.5.1,0.5,0.999,Pass,1","S4.5.1:S4.5.2,0.2,0.999,Pass,0","S4.4.5:S4.5.3,0.5,0.999,Pass,1","S0.7.0:S4.5.4,0.5,0.9,Pass,1","S4.4.0:S4.5.4,0.5,0.999,Pass,1","S4.4.0:S4.5.5,0.5,0.99,Pass,0","S4.5.1:S4.5.6,0.5,0.99,Pass,1","S3.4.0:S4.6.0,0.5,0.99,Pass,1","S3.4.4:S4.6.1,0.5,0.99,Pass,0","S4.6.1:S4.6.2,0.5,0.99,Pass,1","S4.6.2:S4.6.3,0.5,0.99,Pass,1","S4.6.1:S4.6.4,0.8,0.999,Pass,1","S4.6.1:S4.6.5,0.5,0.99,Pass,1","S0.2.0:S5.1.0,0.5,0.99,Pass,1","S3.3.0:S5.1.0,0.5,0.99,Pass,1","S0.2.0:S5.1.1,0.8,0.9,Pass,0","S5.1.1:S5.1.2,0.5,0.9,Pass,1","S5.1.1:S5.1.3,0.2,0.999,Pass,1","S5.1.3:S5.1.4,0.5,0.99,Pass,1","S5.1.1:S5.1.5,0.5,0.99,Fail,1","S5.1.1:S5.1.6,0.5,0.9,Pass,1","S5.1.1:S5.1.7,0.5,0.9,Pass,1","S3.3.0:S5.2.0,0.2,0.99,Pass,1","S3.5.0:S5.2.0,0.2,0.99,Pass,1","S5.1.0:S5.2.0,0.2,0.99,Pass,1","S5.1.1:S5.2.1,0.5,0.99,Pass,1","S5.2.1:S5.2.2,0.2,0.99,Pass,1","S5.2.2:S5.2.3,0.2,0.99,Pass,1","S5.2.3:S5.2.4,0.5,0.99,Pass,1","S3.3.0:S5.2.5,0.5,0.99,Pass,1","S3.5.0:S5.2.5,0.5,0.9,Pass,1","S5.1.2:S5.2.5,0.5,0.99,Pass,1","S5.2.5:S5.2.6,0.5,0.99,Pass,1","S5.2.5:S5.2.7,0.5,0.99,Fail,1","S3.3.0:S5.2.8,0.8,0.999,Pass,0","S3.5.0:S5.2.8,0.8,0.9,Pass,0","S5.1.2:S5.2.8,0.8,0.999,Pass,0","S5.2.7:S5.2.9,0.5,0.999,Pass,1","S0.2.0:S5.3.0,0.5,0.99,Pass,1","S0.2.0:S5.3.1,0.2,0.99,Pass,1","S0.2.0:S5.3.2,0.2,0.9,Pass,0","S0.2.0:S5.3.3,0.8,0.9,Pass,1","S5.2.8:S5.3.4,0.2,0.99,Pass,1","S5.3.4:S5.3.5,0.2,0.9,Pass,1","S3.5.0:S5.4.0,0.8,0.9,Fail,1","S5.1.1:S5.4.1,0.2,0.9,Pass,1","S5.3.2:S5.4.2,0.2,0.99,Pass,1","S5.4.1:S5.4.3,0.5,0.99,Pass,0","S5.4.2:S5.4.3,0.5,0.99,Pass,0","S5.4.1:S5.4.4,0.5,0.99,Pass,1","S5.4.2:S5.4.4,0.5,0.99,Pass,1","S5.3.0:S5.5.0,0.8,0.99,Pass,1","S5.4.0:S5.5.0,0.8,0.99,Pass,1","S5.3.0:S5.5.1,0.2,0.9,Pass,1","S5.3.0:S5.5.2,0.8,0.99,Pass,1","S5.4.0:S5.5.3,0.5,0.99,Pass,1","S5.5.3:S5.5.4,0.5,0.999,Pass,1","S5.5.4:S5.5.5,0.8,0.999,Pass,1","S2.3.0:S6.1.0,0.8,0.99,Pass,0","S2.3.0:S6.1.1,0.5,0.99,Pass,1","S2.3.0:S6.1.2,0.5,0.999,Pass,1","S2.3.3:S6.1.3,0.8,0.999,Pass,1","S6.1.1:S6.1.4,0.5,0.99,Pass,1","S6.1.2:S6.1.4,0.5,0.99,Pass,1","S6.1.3:S6.1.4,0.5,0.9,Pass,1","S6.1.1:S6.1.5,0.5,0.99,Pass,1","S6.1.2:S6.1.5,0.5,0.99,Pass,1","S6.1.3:S6.1.5,0.5,0.999,Pass,1","S6.1.3:S6.1.6,0.5,0.99,Pass,1","S6.1.0:S6.2.0,0.5,0.99,Pass,1","S6.1.1:S6.2.1,0.5,0.999,Pass,0","S6.1.2:S6.2.1,0.5,0.9,Pass,0","S6.2.1:S6.2.2,0.2,0.99,Pass,1","S6.2.1:S6.2.3,0.5,0.9,Pass,1","S6.2.3:S6.2.4,0.2,0.999,Pass,0","S4.3.0:S6.3.0,0.8,0.99,Pass,1","S4.6.0:S6.3.0,0.8,0.99,Pass,1","S4.6.0:S6.3.1,0.5,0.9,Fail,1","S6.3.1:S6.3.2,0.5,0.9,Pass,1","S1.5.0:S6.4.0,0.5,0.9,Pass,1","S6.2.0:S6.4.0,0.5,0.999,Pass,1","S1.5.0:S6.4.1,0.5,0.99,Fail,1","S6.4.1:S6.4.2,0.5,0.99,Pass,1","S6.4.1:S6.4.3,0.5,0.99,Pass,1","S6.4.2:S6.4.4,0.5,0.99,Pass,1","S6.4.0:S6.5.0,0.8,0.99,Pass,1","S6.4.4:S6.5.1,0.5,0.99,Pass,1","S6.4.4:S6.5.2,0.5,0.999,Pass,1","S6.5.2:S6.5.3,0.5,0.99,Pass,0","S6.5.3:S6.5.4,0.5,0.99,Pass,1","S6.5.3:S6.5.5,0.5,0.9,Pass,1","S6.2.0:S7.1.0,0.5,0.99,Pass,1",":S7.1.1,0.5,,Pass,1","S6.2.0:S7.1.2,0.5,0.999,Pass,1","S6.1.2:S7.1.3,0.5,0.99,Pass,1","S7.1.2:S7.1.4,0.5,0.99,Pass,1","S7.1.4:S7.1.5,0.2,0.9,Pass,0","S7.1.5:S7.1.6,0.2,0.999,Pass,1","S7.1.6:S7.1.7,0.8,0.9,Pass,1","S7.1.2:S7.1.8,0.8,0.99,Pass,0","S7.1.3:S7.1.9,0.2,0.99,Pass,1","S7.1.7:S7.1.10,0.8,0.999,Fail,1","S7.1.0:S7.2.0,0.5,0.99,Pass,1","S7.1.1:S7.2.1,0.5,0.99,Pass,1","S7.2.1:S7.2.2,0.5,0.999,Pass,1","S7.2.2:S7.2.3,0.5,0.99,Pass,1","S7.2.3:S7.2.4,0.2,0.99,Pass,0","S7.2.1:S7.2.5,0.8,0.9,Pass,1","S7.2.4:S7.2.6,0.5,0.99,Pass,1","S7.2.4:S7.2.7,0.8,0.99,Pass,1","S7.2.0:S7.3.0,0.5,0.99,Pass,1","S7.1.2:S7.3.1,0.2,0.99,Pass,1","S7.1.3:S7.3.2,0.8,0.99,Pass,1","S7.2.4:S7.3.2,0.8,0.99,Pass,1","S7.3.2:S7.3.3,0.5,0.999,Pass,1","S7.3.1:S7.3.4,0.5,0.99,Pass,1","S7.3.2:S7.3.5,0.5,0.99,Pass,1","S7.3.2:S7.3.6,0.5,0.999,Pass,1","S7.1.0:S7.4.0,0.8,0.9,Pass,1","S7.1.1:S7.4.1,0.8,0.99,Pass,1","S7.4.1:S7.4.2,0.5,0.99,Pass,1","S7.4.2:S7.4.3,0.5,0.999,Pass,0","S7.1.3:S7.4.4,0.5,0.99,Pass,1","S7.4.1:S7.4.4,0.5,0.9,Pass,1","S7.4.4:S7.4.5,0.8,0.99,Pass,1","S7.4.3:S7.4.6,0.5,0.9,Pass,0","S2.4.0:S8.1.0,0.5,0.99,Pass,1","S2.4.0:S8.1.1,0.5,0.999,Pass,1","S4.1.3:S8.1.1,0.5,0.99,Pass,1","S8.1.1:S8.1.2,0.5,0.99,Pass,1","S8.1.2:S8.1.3,0.5,0.99,Pass,1","S8.1.1:S8.1.4,0.5,0.99,Pass,1","S8.1.1:S8.1.5,0.5,0.999,Pass,1","S4.1.0:S8.2.0,0.5,0.99,Pass,1","S8.1.0:S8.2.0,0.5,0.9,Pass,1","S4.1.0:S8.2.1,0.5,0.9,Pass,1","S8.2.1:S8.2.2,0.5,0.99,Pass,1","S8.2.2:S8.2.3,0.8,0.99,Pass,1","S2.1.2:S8.2.4,0.5,0.99,Pass,1","S8.2.3:S8.2.5,0.5,0.99,Pass,1","S2.4.0:S8.3.0,0.2,0.99,Pass,1","S8.2.0:S8.3.0,0.2,0.999,Pass,1","S2.4.0:S8.3.1,0.2,0.999,Pass,1","S8.3.1:S8.3.2,0.5,0.99,Pass,0","S8.3.2:S8.3.3,0.2,0.999,Pass,1","S8.3.3:S8.3.4,0.5,0.99,Pass,1","S2.1.2:S8.3.5,0.8,0.99,Pass,1","S8.3.3:S8.3.6,0.2,0.99,Pass,0","S8.3.2:S8.3.7,0.5,0.9,Pass,1","S8.3.0:S8.4.0,0.5,0.99,Pass,1","S8.3.6:S8.4.1,0.5,0.99,Pass,1","S8.4.1:S8.4.2,0.5,0.9,Pass,1","S8.4.2:S8.4.3,0.5,0.99,Fail,1","S8.4.3:S8.4.4,0.2,0.999,Pass,0","S8.4.4:S8.4.5,0.5,0.99,Pass,1","S8.3.5:S8.4.6,0.2,0.99,Pass,0","S8.4.4:S8.4.7,0.8,0.99,Pass,1","S8.4.3:S8.4.8,0.2,0.99,Pass,1","S6.1.0:S8.5.0,0.5,0.999,Pass,1","S8.4.0:S8.5.0,0.5,0.99,Pass,1","S6.1.2:S8.5.1,0.5,0.99,Pass,1","S6.1.1:S8.5.2,0.5,0.99,Pass,1","S8.5.1:S8.5.2,0.5,0.99,Pass,1","S8.5.2:S8.5.3,0.5,0.9,Pass,1","S8.5.2:S8.5.4,0.2,0.99,Pass,1","S8.5.1:S8.5.5,0.5,0.99,Pass,1","S8.1.0:S8.5.6,0.2,0.999,Pass,1","S6.4.0:S8.6.0,0.5,0.9,Pass,1","S8.5.0:S8.6.0,0.5,0.99,Pass,1","S6.4.1:S8.6.1,0.2,0.99,Pass,1","S8.5.4:S8.6.1,0.2,0.99,Pass,1","S6.4.2:S8.6.2,0.2,0.999,Pass,1","S8.6.1:S8.6.2,0.2,0.999,Pass,1","S8.6.2:S8.6.3,0.5,0.99,Pass,1","S8.6.3:S8.6.4,0.2,0.99,Pass,1","S3.1.0:S9.1.0,0.2,0.999,Pass,0","S3.1.4:S9.1.1,0.5,0.99,Fail,0","S9.1.1:S9.1.2,0.5,0.9,Pass,1","S9.1.2:S9.1.3,0.8,0.99,Pass,1","S9.1.3:S9.1.4,0.2,0.99,Pass,1","S9.1.4:S9.1.5,0.2,0.99,Pass,1","S9.1.5:S9.1.6,0.5,0.99,Pass,1","S9.1.6:S9.1.7,0.5,0.99,Pass,0","S9.1.6:S9.1.8,0.5,0.99,Pass,0","S9.1.0:S9.2.0,0.8,0.9,Pass,0","S9.1.2:S9.2.1,0.5,0.99,Pass,1","S9.2.1:S9.2.2,0.5,0.999,Pass,1","S9.2.2:S9.2.3,0.5,0.9,Pass,1","S9.2.3:S9.2.4,0.5,0.9,Pass,1","S9.2.4:S9.2.5,0.2,0.99,Pass,1","S9.2.0:S9.3.0,0.8,0.99,Pass,0","S9.2.1:S9.3.1,0.2,0.9,Pass,1","S9.3.1:S9.3.2,0.5,0.99,Pass,0","S9.3.2:S9.3.3,0.5,0.99,Pass,1","S9.3.3:S9.3.4,0.8,0.99,Pass,1","S9.3.4:S9.3.5,0.5,0.99,Pass,1","S9.3.5:S9.3.6,0.5,0.99,Pass,1","S9.3.1:S9.3.7,0.8,0.999,Pass,1","S9.3.4:S9.3.8,0.5,0.999,Pass,1","S9.3.0:S9.4.0,0.5,0.9,Pass,0","S9.6.1:S9.4.1,0.2,0.99,Pass,1","S9.4.1:S9.4.2,0.5,0.99,Pass,0","S0.3.0:S9.5.0,0.2,0.999,Pass,1","S9.1.0:S9.5.0,0.2,0.99,Pass,1","S9.1.3:S9.5.1,0.5,0.99,Pass,1","S9.1.5:S9.5.1,0.5,0.99,Pass,1","S9.5.1:S9.5.2,0.5,0.99,Pass,1","S9.5.2:S9.5.3,0.5,0.99,Fail,1","S9.5.3:S9.5.4,0.5,0.99,Pass,0","S9.5.2:S9.5.5,0.5,0.9,Pass,0","S9.1.0:S9.6.0,0.5,0.99,Pass,1","S0.1.1:S9.6.1,0.5,0.999,Pass,0","S9.1.3:S9.6.2,0.2,0.99,Pass,1","S9.6.1:S9.6.2,0.2,0.999,Pass,1","S9.6.2:S9.6.3,0.5,0.99,Pass,1","S9.6.3:S9.6.4,0.8,0.9,Pass,1","S9.6.0:S9.7.0,0.2,0.9,Pass,1","S9.6.1:S9.7.1,0.5,0.99,Pass,1","S9.7.1:S9.7.2,0.2,0.9,Pass,1","S9.7.2:S9.7.3,0.8,0.99,Pass,0","S1.5.4:S9.7.4,0.2,0.99,Pass,1","S9.7.3:S9.7.4,0.2,0.9,Pass,1","S9.7.4:S9.7.5,0.5,0.99,Pass,1","S9.7.2:S9.7.6,0.8,0.999,Pass,1","S9.7.5:S9.7.7,0.2,0.99,Pass,1"};

