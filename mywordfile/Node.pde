// Code from Visualizing Data, First Edition, Copyright 2008 Ben Fry.
// Based on the GraphLayout example by Sun Microsystems.


class Node {
  
  float x, y, w;
  float dx, dy;
  boolean fixed;
  String label;
  int count;
  int myX = 10;
  int fromTo;//0=from, 1=to
  float midX, midY;
  


  Node(String label) {
    this.label = label;
    if(fromTo ==0){
      x = random(width-40);
      y = random(height-40);
    }
    else{
      x = myX;
      myX = myX + 25;
      y = random(height-40);
    }
    midX = x;
    midY = y;
    
  }
  
  
  void increment() {
    count++;
  }
  
  
  void relax() {
    float ddx = 0;
    float ddy = 0;

    for (int j = 0; j < nodeCount; j++) {
      Node n = nodes[j];
      if (n != this) {
        float vx = x - n.x;
        float vy = y - n.y;
        float lensq = vx * vx + vy * vy;
        if (lensq == 0) {
          ddx += random(1);
          ddy += random(1);
        } else if (lensq < 100*100) {
          ddx += vx / lensq;
          ddy += vy / lensq;
        }
      }
    }
    float dlen = mag(ddx, ddy) / 2;
    if (dlen > 0) {
      dx += ddx / dlen;
      dy += ddy / dlen;
    }
  }


  void update() {
    if (!fixed) {      
      x += constrain(dx, -5, 5);
      y += constrain(dy, -5, 5);
      
      x = constrain(x, 0, width);
      y = constrain(y, 0, height);
    }
    dx /= 2;
    dy /= 2;
  }


  void draw() {
    fill(nodeColor);
    stroke(255);
    strokeWeight(0.5);
    
    while((x+(count*5)>width)||(y+(count*5)>height)){
      
        x = random(width-40);
        y = random(height-40);
      
    }
    
    if(fromTo == 0){
       fill(nodeColor);
      ellipse(x, y, count*5, count*5);
    }
    else if(fromTo==1){
      fill(categoryColor);
      rect(x, y, count*3.5, count*3.5);
      fixed=true;
      
    }
    midX = (x)+((count*3))/2;
    midY = (y)+((count*3))/2;
    fill(0);
    textSize(14);
    w = textWidth(label);

    if (count*3 > w+4) {
      //textSize(14);
      textAlign(LEFT);
      fill(0);
   //   stroke(255,255,255,200);
   //   strokeWeight(20);
      rect(midX-2, midY-10, w+2, 16);
      fill(255,255,255);
      text(label, midX, midY);
    }
    else if(count*3>w-20 && count*3<w+4){
      textSize(12);
      w = textWidth(label);
      fill(0);
     // stroke(255,255,255,200);
     // strokeWeight(20);
      rect(midX-2, midY-10, w+2, 16);
      fill(255,255,255);
      textAlign(LEFT);
      text(label, midX, midY);
    }
  }
}

