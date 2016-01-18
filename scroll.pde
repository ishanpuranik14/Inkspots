
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
