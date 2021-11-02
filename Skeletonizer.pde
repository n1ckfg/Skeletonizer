import ComputationalGeometry.*;
import latkProcessing.*;

NewSkeleton skeleton;
Latk la;
boolean drawOrig = false;
float globalRdpEpsilon = 0.5; //0.8;
RDP rdp;

void setup() {
  size(800, 600, P3D);

  // Create iso-skeleton
  skeleton = new NewSkeleton(this);
  rdp = new RDP();
  
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
      p = new PVector(p.x, p.y, p.z);
      points.add(new LatkPoint(this, p));
    }
    
    for (int h=0; h<3; h++) {
      for (int i=1; i<points.size(); i+=2) {
        PVector p1 = points.get(i).co.copy();
        PVector p0 = points.get(i-1).co.copy();
        PVector pAvg = p1.add(p0).mult(0.5);
        points.add(i-1, new LatkPoint(this, pAvg));
      }
    }

    LatkStroke stroke = new LatkStroke(this, points, color(randomCol()));

    println("Before: " + stroke.points.size());

    for (int i=0; i<stroke.splitReps; i++) {
      stroke.splitStroke();  
      stroke.smoothStroke();  
    }
    
    ArrayList<Vert> verts = new ArrayList<Vert>();
    for (LatkPoint lp : stroke.points) {
      verts.add(new Vert(lp.co));
    }
    verts = rdp.douglasPeucker(verts, globalRdpEpsilon);
    ArrayList<LatkPoint> newPoints = new ArrayList<LatkPoint>();
    for (Vert v : verts) {
      newPoints.add(new LatkPoint(this, v));
    }
    
    for (int i=0; i<stroke.smoothReps - stroke.splitReps; i++) {
      stroke.smoothStroke();    
     }

    println("After: " + stroke.points.size());
    
    la.layers.get(0).frames.get(0).strokes.add(stroke);
  }
}

color randomCol() {
  return color(127 + random(127), 127 + random(127), 127 + random(127));
}

void draw() {
  background(127);
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
