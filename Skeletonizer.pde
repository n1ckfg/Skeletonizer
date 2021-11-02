import ComputationalGeometry.*;
import latkProcessing.*;

NewSkeleton skeleton;
Latk la;
boolean drawOrig = false;

void setup() {
  size(800, 600, P3D);

  // Create iso-skeleton
  skeleton = new NewSkeleton(this);

  // Create points to make the network
  PVector[] pts = new PVector[100];
  for (int i=0; i<pts.length; i++) {
    pts[i] = new PVector(random(-100, 100), random(-100, 100), random(-100, 100));
  }  
 
  for (int i=0; i<pts.length; i++) {
    for (int j=i+1; j<pts.length; j++) {
      if (pts[i].dist( pts[j] ) < 50) {
        skeleton.addEdge(pts[i], pts[j]);
      }
    }
  }

  la = new Latk(this);
  
  for (ArrayList al : skeleton.adj) {
    ArrayList<LatkPoint> points = new ArrayList<LatkPoint>();
    for (int i=0; i<al.size(); i++) {
      int index = (int) al.get(i);
      PVector p = skeleton.nodes[index];
      p = new PVector(-p.x, p.z, p.y);
      points.add(new LatkPoint(this, p));
    }
    LatkStroke stroke = new LatkStroke(this, points, color(0,255,255));
    stroke.refine();
    la.layers.get(0).frames.get(0).strokes.add(stroke);
  }
}

void draw() {
  background(220);
  lights();  
  float zm = 150;
  float sp = 0.001 * frameCount;
  camera(zm * cos(sp), zm * sin(sp), zm, 0, 0, 0, 0, 0, -1);
  
  noStroke();
  if (drawOrig) {
    skeleton.plot(10.f * float(mouseX) / (2.0f*width), float(mouseY) / (2.0*height));  // Thickness as parameter
  } else {
    la.run();
  }
}

void keyPressed() {
  drawOrig = !drawOrig;
}
