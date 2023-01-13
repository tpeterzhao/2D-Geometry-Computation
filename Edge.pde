public class MyEdge{
  
  PVector p, q;
  public MyEdge(PVector v1, PVector v2){
    p = v1;
    q = v2;
  }
  
  // intersection method from project 1
  public PVector intersect(MyEdge s2){
    float a = q.x-p.x;
    float b = q.y-p.y;
    float c = s2.q.x-s2.p.x;
    float d = s2.q.y-s2.p.y;
    float e = s2.p.x-p.x;
    float f = s2.p.y-p.y;
    // check if two lines are parallel
    if(a*d-b*c == 0){
      // if parallel,
      // check if two lines coincides
      float tp = (s2.p.x - p.x)/(q.x-p.x);
      float tq = (s2.q.x - p.x)/(q.x-p.x);
      float l = max(min(tp, tq),0);
      float r = min(max(tp,tq),1);
      if(l>r){
        // no intersection return null
        return null;
      } else if(l == r){
        // intersect at p1+l(q1-p1)
        PVector s = PVector.sub(q,p);
        s.mult(l);
        PVector inter = PVector.add(s, p);
        return inter;
      }
    } else{
      // t1 = -(cf-de)/(ad-bc), t2 = -(af-be)/(ad-bc)
      float t1 = -(c*f-d*e)/(a*d-b*c);
      float t2 = -(a*f-b*e)/(a*d-b*c);
      if(t1>=0 && t1<=1 && t2>=0 && t2<=1){
        //calculate intersectioin point
        PVector x = PVector.add(p, (PVector.sub(q,p)).mult(t1));
        return x;
      }
    }
    
    return null;
  }
  
  public void moveLeft(int speed){
    p.x -= speed;
    q.x -= speed;
  }
  public void moveRight(int speed){
    p.x += speed;
    q.x += speed;
  }  
  public void moveUp(int speed){
    p.y -= speed;
    q.y -= speed;
  }  
  public void moveDown(int speed){
    p.y += speed;
    q.y += speed;
  }
  
  public void print(){
    println(p,"->",q);  
  }
}
