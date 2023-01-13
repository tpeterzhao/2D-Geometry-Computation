public class MyFace{
  ArrayList<MyEdge> edges;
  public MyFace(){
    edges = new ArrayList<MyEdge>();
  }
  
  public MyFace(ArrayList<PVector> vs){
    edges = new ArrayList<MyEdge>();
    for(int i=0; i<vs.size()-1; i++){
      MyEdge e = new MyEdge(vs.get(i),vs.get(i+1));
      edges.add(e);
    }
    MyEdge end = new MyEdge(vs.get(vs.size()-1),vs.get(0));
    edges.add(end);
  }
  public MyFace(ArrayList<MyEdge> es, boolean holder){
    edges = es;  
  }
  
  public int size(){
    return edges.size();
  }
  
  public MyEdge get(int i){
    if(i >= edges.size()){
      println("no such edge");
      return null;
    }
    return edges.get(i);  
  }
  
  public boolean isIn(PVector v){
    MyEdge ray = new MyEdge(new PVector(0, v.y), v);
    int count = 0;
    for(int i=0; i<edges.size(); i++){
      if(ray.intersect(edges.get(i))!=null){
        count++;
      }
    }
    if(count==1){
      return true;
    }
    return false;
  }
  
  public ArrayList<PVector> inPoints(MyFace face){
    ArrayList<PVector> points = new ArrayList<PVector>();
    for(int i=0; i<face.size(); i++){
      if(isIn(face.get(i).p)){
        PVector temp = new PVector(face.get(i).p.x, face.get(i).p.y);
        points.add(temp);
      }
    }
    return points;
  }
  
  public MyFace intersect(MyFace face){
    ArrayList<MyEdge> new_edges = new ArrayList<MyEdge>();

    for(int i=0; i<edges.size(); i++){
      for(int j=0; j<face.size(); j++){
        PVector inter = edges.get(i).intersect(face.get(j));
        if(inter!=null){
          if(isIn(face.get(j).p) && (face.isIn(edges.get(i).p) || face.isIn(edges.get(i).q))){
            // if edge is from inside
            MyEdge new_edge = new MyEdge(face.get(j).p.copy(), inter.copy());
            new_edges.add(new_edge);
            new_edge = new MyEdge(inter.copy(), edges.get(i).q.copy());
            new_edges.add(new_edge);
          } else if(isIn(face.get(j).q) && (face.isIn(edges.get(i).p) || face.isIn(edges.get(i).q))){
            // if edge is from outside
            MyEdge new_edge = new MyEdge(inter.copy(), face.get(j).q.copy());
            new_edges.add(new_edge);
            new_edge = new MyEdge(edges.get(i).p.copy(), inter.copy());
            new_edges.add(new_edge);
          } else if((face.isIn(edges.get(i).p) || face.isIn(edges.get(i).q)) && (!isIn(face.get(j).p) && !isIn(face.get(j).q))){
            // if edge cross the face
            // find two intersections
            PVector[] two_inter = new PVector[2];
            int count = 0;
            for(int k=0; k<edges.size(); k++){
              PVector  one = face.get(j).intersect(edges.get(k));
              if(one !=null){
                two_inter[count] = one.copy();
                count++;
                
                if(face.isIn(edges.get(k).p)){
                  MyEdge new_edge = new MyEdge(one.copy(), edges.get(k).p.copy());
                  new_edges.add(new_edge);
                }
                if(face.isIn(edges.get(k).q)){
                  MyEdge new_edge = new MyEdge(edges.get(k).q.copy(), one.copy());
                  new_edges.add(new_edge);
                }
              }
            }
            MyEdge new_edge = new MyEdge(two_inter[0].copy(), two_inter[1].copy());
            new_edges.add(new_edge);
          } else if(!face.isIn(edges.get(i).p) && !face.isIn(edges.get(i).q) && (isIn(face.get(j).p) || isIn(face.get(j).q))){
            PVector[] two_inter = new PVector[2];
            int count = 0;
            for(int k=0; k<face.size(); k++){
              PVector  one = edges.get(i).intersect(face.get(k));
              if(one !=null){
                two_inter[count] = one.copy();
                count++;
                
                if(isIn(face.get(k).p)){
                  MyEdge new_edge = new MyEdge(face.get(k).p.copy(), one.copy());
                  new_edges.add(new_edge);
                }
                if(isIn(face.get(k).q)){
                  MyEdge new_edge = new MyEdge(one.copy(), face.get(k).q.copy());
                  new_edges.add(new_edge);
                }
              }
            }
            MyEdge new_edge = new MyEdge(two_inter[0].copy(), two_inter[1].copy());
            new_edges.add(new_edge);
          } else{
            PVector[] two_inter = new PVector[2];
            int count = 0;
            for(int k=0; k<edges.size(); k++){
              PVector  one = face.get(j).intersect(edges.get(k));
              if(one !=null){
                two_inter[count] = one.copy();
                count++;
                
                if(face.isIn(edges.get(k).p)){
                  MyEdge new_edge = new MyEdge(one.copy(), edges.get(k).p.copy());
                  new_edges.add(new_edge);
                }
                if(face.isIn(edges.get(k).q)){
                  MyEdge new_edge = new MyEdge(edges.get(k).q.copy(), one.copy());
                  new_edges.add(new_edge);
                }
              }
            }
            MyEdge new_edge = new MyEdge(two_inter[0].copy(), two_inter[1].copy());
            new_edges.add(new_edge);
            
            two_inter = new PVector[2];
            count = 0;
            for(int k=0; k<face.size(); k++){
              PVector  one = edges.get(i).intersect(face.get(k));
              if(one !=null){
                two_inter[count] = one.copy();
                count++;
                
                if(isIn(face.get(k).p)){
                  new_edge = new MyEdge(face.get(k).p.copy(), one.copy());
                  new_edges.add(new_edge);
                }
                if(isIn(face.get(k).q)){
                  new_edge = new MyEdge(one.copy(), face.get(k).q.copy());
                  new_edges.add(new_edge);
                }
              }
            }
            new_edge = new MyEdge(two_inter[0].copy(), two_inter[1].copy());
            new_edges.add(new_edge);
          }
        }
      }
    }
    
    for(int i=0; i<face.size(); i++){
        if(isIn(face.get(i).p) && isIn(face.get(i).q)){
          MyEdge new_edge = new MyEdge(face.get(i).p.copy(), face.get(i).q.copy());
          new_edges.add(new_edge);
        }
    }
    
    for(int i=0; i<edges.size(); i++){
      if(face.isIn(edges.get(i).p) && face.isIn(edges.get(i).q)){
        MyEdge new_edge = new MyEdge(edges.get(i).p.copy(), edges.get(i).q.copy());  
        new_edges.add(new_edge);
      }
    }
    MyFace new_face = new MyFace(new_edges, true);
    return new_face;
  }
  
  public MyFace diff(MyFace face){
    ArrayList<MyEdge> new_edges = new ArrayList<MyEdge>();
    for(int i=0; i<edges.size(); i++){
      for(int j=0; j<face.size(); j++){
        PVector inter = edges.get(i).intersect(face.get(j));
        if(inter!=null){
          if(isIn(face.get(j).p) && (face.isIn(edges.get(i).p) || face.isIn(edges.get(i).q))){
            // if edge is from inside
            MyEdge new_edge = new MyEdge(inter.copy(), face.get(j).q.copy());
            new_edges.add(new_edge);
            new_edge = new MyEdge(edges.get(i).q.copy(), inter.copy());
            new_edges.add(new_edge);
          } else if(isIn(face.get(j).q) && (face.isIn(edges.get(i).p) || face.isIn(edges.get(i).q))){
            // if edge is from outside
            MyEdge new_edge = new MyEdge(face.get(j).p.copy(), inter.copy());
            new_edges.add(new_edge);
            new_edge = new MyEdge(inter.copy(), edges.get(i).p.copy());
            new_edges.add(new_edge);
          } else if((face.isIn(edges.get(i).p) || face.isIn(edges.get(i).q)) && (!isIn(face.get(j).p) && !isIn(face.get(j).q))){
            // if edge cross the face
            // find two intersections
            PVector[] two_inter = new PVector[2];
            int count = 0;
            for(int k=0; k<edges.size(); k++){
              PVector  one = face.get(j).intersect(edges.get(k));
              if(one !=null){
                two_inter[count] = one.copy();
                count++;
                
                if(face.isIn(edges.get(k).p)){
                  MyEdge new_edge = new MyEdge(one.copy(), edges.get(k).p.copy());
                  new_edges.add(new_edge);
                }
                if(face.isIn(edges.get(k).q)){
                  MyEdge new_edge = new MyEdge(one.copy(), edges.get(k).q.copy());
                  new_edges.add(new_edge);
                }
              }
            }
            //MyEdge new_edge = new MyEdge(two_inter[0].copy(), two_inter[1].copy());
            if(PVector.dist(face.get(j).p,two_inter[0]) < PVector.dist(face.get(j).q, two_inter[0])){
              MyEdge new_edge = new MyEdge(face.get(j).p.copy(), two_inter[0].copy());
              new_edges.add(new_edge);
              new_edge = new MyEdge(face.get(j).q.copy(), two_inter[1].copy());
              new_edges.add(new_edge);
            } else{
              MyEdge new_edge = new MyEdge(face.get(j).q.copy(), two_inter[0].copy());
              new_edges.add(new_edge);
              new_edge = new MyEdge(face.get(j).p.copy(), two_inter[1].copy());
              new_edges.add(new_edge);
            }
          } else if(!face.isIn(edges.get(i).p) && !face.isIn(edges.get(i).q) && (isIn(face.get(j).p) || isIn(face.get(j).q))){
            PVector[] two_inter = new PVector[2];
            int count = 0;
            for(int k=0; k<face.size(); k++){
              PVector  one = edges.get(i).intersect(face.get(k));
              if(one !=null){
                two_inter[count] = one.copy();
                count++;
                
                if(isIn(face.get(k).p)){
                  MyEdge new_edge = new MyEdge(one.copy(), face.get(k).q.copy());
                  new_edges.add(new_edge);
                }
                if(isIn(face.get(k).q)){
                  MyEdge new_edge = new MyEdge(face.get(k).p.copy(), one.copy());
                  new_edges.add(new_edge);
                }
              }
            }
            MyEdge new_edge = new MyEdge(two_inter[0].copy(), two_inter[1].copy());
            new_edges.add(new_edge);
          } else{
            PVector[] two_inter = new PVector[2];
            int count = 0;
            for(int k=0; k<edges.size(); k++){
              PVector  one = face.get(j).intersect(edges.get(k));
              if(one !=null){
                two_inter[count] = one.copy();
                count++;
                
                if(face.isIn(edges.get(k).p)){
                  MyEdge new_edge = new MyEdge(one.copy(), edges.get(k).p.copy());
                  new_edges.add(new_edge);
                }
                if(face.isIn(edges.get(k).q)){
                  MyEdge new_edge = new MyEdge(one.copy(), edges.get(k).q.copy());
                  new_edges.add(new_edge);
                }
              }
            }
            //MyEdge new_edge = new MyEdge(two_inter[0].copy(), two_inter[1].copy());
            if(PVector.dist(face.get(j).p,two_inter[0]) < PVector.dist(face.get(j).q, two_inter[0])){
              MyEdge new_edge = new MyEdge(face.get(j).p.copy(), two_inter[0].copy());
              new_edges.add(new_edge);
              new_edge = new MyEdge(face.get(j).q.copy(), two_inter[1].copy());
              new_edges.add(new_edge);
            } else{
              MyEdge new_edge = new MyEdge(face.get(j).q.copy(), two_inter[0].copy());
              new_edges.add(new_edge);
              new_edge = new MyEdge(face.get(j).p.copy(), two_inter[1].copy());
              new_edges.add(new_edge);
            }
            
            two_inter = new PVector[2];
            count = 0;
            for(int k=0; k<face.size(); k++){
              PVector  one = edges.get(i).intersect(face.get(k));
              if(one !=null){
                two_inter[count] = one.copy();
                count++;
                
                if(isIn(face.get(k).p)){
                  MyEdge new_edge = new MyEdge(one.copy(), face.get(k).q.copy());
                  new_edges.add(new_edge);
                }
                if(isIn(face.get(k).q)){
                  MyEdge new_edge = new MyEdge(face.get(k).p.copy(), one.copy());
                  new_edges.add(new_edge);
                }
              }
            }
            MyEdge new_edge = new MyEdge(two_inter[0].copy(), two_inter[1].copy());
            new_edges.add(new_edge);
          }
        }
      }
    }
    for(int i=0; i<face.size(); i++){
        boolean cross = false;
        for(int x=0; x<edges.size(); x++){
          if(face.get(i).intersect(edges.get(x))!=null){
            cross = true;  
          }
        }
        if(!isIn(face.get(i).p) && !isIn(face.get(i).q) && !cross){
          MyEdge new_edge = new MyEdge(face.get(i).p.copy(), face.get(i).q.copy());
          new_edges.add(new_edge);  
        }
    }
    for(int i=0; i<edges.size(); i++){
        boolean cross = false;
        for(int x=0; x<face.size(); x++){
          if(edges.get(i).intersect(face.get(x))!=null){
            cross = true;  
          }
        }
      if(face.isIn(edges.get(i).p) && face.isIn(edges.get(i).q) && !cross){
        MyEdge new_edge = new MyEdge(edges.get(i).p.copy(), edges.get(i).q.copy());  
        new_edges.add(new_edge);
      }
    }
    MyFace new_face = new MyFace(new_edges, true);
    return new_face;
  }
  
  public MyFace union(MyFace face){
    ArrayList<MyEdge> new_edges = new ArrayList<MyEdge>();
    MyFace intersection = intersect(face);
    MyFace right = diff(face);
    MyFace left = face.diff(this);
    for(int i=0; i<right.size(); i++){
      new_edges.add(right.get(i));
    }
    for(int j=0; j<left.size(); j++){
      new_edges.add(left.get(j));
    }
    for(int k=0; k<intersection.size(); k++){
      for(int x=0; x<new_edges.size(); x++){
        PVector p1 = intersection.get(k).p;
        PVector q1 = intersection.get(k).q;
        PVector p2 = new_edges.get(x).p;
        PVector q2 = new_edges.get(x).q;
        if((PVector.dist(p1, p2)==0 && PVector.dist(q1, q2)==0) || (PVector.dist(p1, q2)==0 && PVector.dist(q1, p2)==0)){
          new_edges.remove(x);
          x--;
        }
      }
    }
    MyFace new_face = new MyFace(new_edges, true);
    return new_face;
  }
  
  public void remove(int i){
    edges.remove(i);
  }
  
  public void moveLeft(int speed){
    for(int i=0; i<edges.size(); i++){
      edges.get(i).moveLeft(speed);
    }
  }
  public void moveRight(int speed){
    for(int i=0; i<edges.size(); i++){
      edges.get(i).moveRight(speed);
    }
  }
    public void moveUp(int speed){
    for(int i=0; i<edges.size(); i++){
      edges.get(i).moveUp(speed);
    }
  }
    public void moveDown(int speed){
    for(int i=0; i<edges.size(); i++){
      edges.get(i).moveDown(speed);
    }
  }
  
  
  public void print(){
    for(int i=0; i<edges.size(); i++){
      edges.get(i).print();
    }
    println();
  }
}
