class Goal extends GameObject
{
  Goal (float x, float y, float w_, float h_)
  {
    this.w_ = w_;
    this.h_ = h_;
    
    PolygonShape sd = new PolygonShape();
  
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);

    sd.setAsBox(box2dW, box2dH);

    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.angle = 0;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    body = box2d.createBody(bd);
    
    body.createFixture(sd,1);
    
    body.setUserData(this);
    pos = box2d.getBodyPixelCoord(body);
  }
  
  void update()
  {
    pos = box2d.getBodyPixelCoord(body);
  }
  
  void render()
  {
    pos = box2d.getBodyPixelCoord(body);
    
    pushMatrix();
      
      translate(pos.x-32, pos.y+22);
      scale(1);
      
      beginShape();
      stroke(0);
      fill(0);
      vertex(0,0);
      vertex(44, -32);
      vertex(50, 0);
      endShape();
         
      beginShape();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0);
      fill(0);
      bezier(0, 0, -0.45, -6.83, 5.7, -9.58, 9.03, -6.76);
      bezier(9.03, -6.76, 8.8, -12.9, 12.7, -14.86, 18.3, -13.03);
      bezier(18.3, -13.03, 18.34, -18.53, 22.5, -21.63, 28.86, -18.9); 
      bezier(28.86, -18.9, 28.84, -29.3, 36.9, -32.25, 43.32, -32.3); 
      bezier(43.32, -32.3, 55.44, -29.13, 61.4, -15.2, 50, 0);
      endShape();
      
      beginShape();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0);
      fill(0);
      vertex(0, 0);
      vertex(50, 0);
      endShape();
      
      beginShape();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0);
      fill(0);
      vertex(29, -25);
      vertex(19, -40);
      vertex(34, -30);
      endShape();
      
      beginShape();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0);
      fill(0);
      vertex(34, -30);
      vertex(33, -48);
      vertex(40, -33);
      endShape();
      
      beginShape();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0);
      fill(0);
      vertex(40, -33);
      vertex(45, -50);
      vertex(49, -30);
      endShape();
      
      beginShape();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0);
      fill(0);
      vertex(49, -30);
      vertex(58, -48);
      vertex(54, -26);
      endShape();
      
      beginShape();
      stroke(0);
      fill(0);
      ellipse(46, -23, 2.5, 2.5);
      
      stroke(0);
      fill(0);
      bezier(40, -25, 40.99, -27.73, 42.77, -29.33, 47.49, -28.58);
      endShape();
      
      beginShape();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0);
      fill(0);
      vertex(56, -18);
      vertex(42, -17);
      vertex(56, -12);
      endShape();
      
      beginShape();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0);
      fill(0);
      vertex(47, -7);
      vertex(59, -11);
      vertex(60, -5);
      vertex(48, -3);
      endShape();
      
      popMatrix();
  }
}