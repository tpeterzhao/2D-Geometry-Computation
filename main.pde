ArrayList<MyFace> faces;
ArrayList<PVector> vertices;
int clickCount;
int moveSpeed = 5;
MyFace selected;
void setup(){
  size(960, 720);
  background(255);
  stroke(0);
  strokeWeight(3);
  faces = new ArrayList<MyFace>();
  vertices = new ArrayList<PVector>();
  clickCount = 0;
}

void draw(){
  background(255);
  stroke(0);
  //draw constructed faces
  for(int i=0; i<faces.size(); i++){
    MyFace f = faces.get(i);
    for(int j=0; j<f.size(); j++){
      line(f.get(j).p.x, f.get(j).p.y, f.get(j).q.x, f.get(j).q.y);
    }
  }
  
  // draw current face
  for(int i=1; i<vertices.size(); i++){
      line(vertices.get(i-1).x, vertices.get(i-1).y, vertices.get(i).x, vertices.get(i).y);
  }
  int size = vertices.size();
  if(size > 2){
    line(vertices.get(0).x, vertices.get(0).y, vertices.get(size-1).x, vertices.get(size-1).y);
  }
}

void mouseClicked(){
  if(mouseButton == LEFT){
    println("click",clickCount,mouseX,mouseY);
    clickCount++;
    PVector vertex = new PVector(mouseX, mouseY, 0);
    if(vertices.size()==0){
      vertices.add(vertex);
      return;
    }
    PVector start = vertices.get(0);
    if(PVector.dist(vertex, start)<10.0){
      MyFace face = new MyFace(vertices);
      selected = face;
      faces.add(face);
      vertices = new ArrayList<PVector>();
      println("Closed polygon");
    } else{
      vertices.add(vertex);
    }
  }
  
  if(mouseButton==RIGHT){
    for(int i=0; i<faces.size(); i++){
      if(faces.get(i).isIn(new PVector(mouseX, mouseY))){
        selected = faces.get(i);  
      }
    }
    println("mouse: ",mouseX,mouseY,selected.isIn(new PVector(mouseX,mouseY)));
  }
}

void keyPressed(){
  // move the newest face
  if(key=='a'){
    selected.moveLeft(moveSpeed);  
  }
  if(key=='s'){
    selected.moveDown(moveSpeed);  
  }
  if(key=='w'){
    selected.moveUp(moveSpeed);  
  }
  if(key=='d'){
    selected.moveRight(moveSpeed);  
  }
  if(key=='u'){
    // union two faces
    MyFace new_face = union(faces.get(0),faces.get(1));
    if(new_face!=null){
      faces.add(new_face);
      selected = new_face;
    }
  }
  if(key=='i'){
    MyFace new_face = intersect(faces.get(0),faces.get(1));
    if(new_face!=null){
      faces.add(new_face);
      selected = new_face;
    }
  }
  if(key=='f'){
    MyFace new_face = faces.get(0).diff(faces.get(1));
    if(new_face!=null){
      faces.add(new_face);
      selected = new_face;
    }
  }
  if(key=='g'){
    MyFace new_face = faces.get(1).diff(faces.get(0));
    if(new_face!=null){
      faces.add(new_face);
      selected = new_face;
    }
  }
  // print faces
  if(key=='p'){
    for(int i=0; i<faces.size(); i++){
      println("Face", i, ":");  
      faces.get(i).print();
    }
  }
  
  // reset
  if(key=='r'){
    setup();
  }
}
MyFace intersect(MyFace f1, MyFace f2){
  return f1.intersect(f2);  
}
MyFace union(MyFace f1, MyFace f2){
  return f1.union(f2);
  //faces.remove(f2);
  //selected = faces.get(faces.size()-1);
}
