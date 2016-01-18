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
  public int size;
  public float difficulty;
  public String progress;
  public int infered;
  // constructor  
  public node(int xc, int yc,String name, int Size, float Difficulty, String Progress, int Infered){
    x=xc;
    y=yc;
    nodeName = name;
    size = Size;
    if(size == 0){
      size = 1;
    }
    setMaxStrength(size);
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
    //fill(120, 150*(size/maxstrength), 200*(size/maxstrength));
    ellipse(x,y, size*8, size*8);
    stroke(0);
  }
  
  // event handling for hover
  public void hover(int mx,int my){
    if((abs(mx-x)<= (size*8)) & (abs(my-y)<= (size*8))){
      if(dist(mx, my, x, y)<=(size*8)){
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
     if((abs(mx-x)<= (size*8)) & (abs(my-y)<= (size*8))){
       if(dist(mx, my, x, y)<=(size*8)){        
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
     if(dist(sx, sy, x, y)<((size+sSize)*8)){        
         return true;
      }
     return false;
  }
  
}
