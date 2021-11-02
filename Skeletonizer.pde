/*-----------------------------------
Library: ComputationalGeometry
By: Mark Collins & Toru Hasegawa
Example: IsoSkeleton

Creates a 3D skeleton with adjustable 
thickness and node size, based on an
edge pairing of points.
------------------------------------*/

import ComputationalGeometry.*;
NewSkeleton skeleton;
PShape ps;
boolean drawShape = false;

void setup() {
  size(800, 600, P3D);

  // Create iso-skeleton
  skeleton = new NewSkeleton(this);

  // Create points to make the network
  PVector[] pts = new PVector[100];
  for (int i=0; i<pts.length; i++) {
    pts[i] = new PVector(random(-100, 100), random(-100, 100), random(-100, 100) );
  }  

  for (int i=0; i<pts.length; i++) {
    for (int j=i+1; j<pts.length; j++) {
      if (pts[i].dist( pts[j] ) < 50) {
        skeleton.addEdge(pts[i], pts[j]);
      }
    }
  }
 
  ps = createShape();
  ps.beginShape();
  for (PVector node : skeleton.nodes) {
    ps.vertex(node.x, node.y, node.z);
  }
  ps.endShape();
}

void draw() {
  background(220);
  lights();  
  float zm = 150;
  float sp = 0.001 * frameCount;
  camera(zm * cos(sp), zm * sin(sp), zm, 0, 0, 0, 0, 0, -1);
  
  noStroke();
  if (!drawShape) {
    skeleton.plot(10.f * float(mouseX) / (2.0f*width), float(mouseY) / (2.0*height));  // Thickness as parameter
  } else {
    stroke(0);
    strokeWeight(20);
    shape(ps, 0, 0);
  }
}

void keyPressed() {
  drawShape = !drawShape;
}
