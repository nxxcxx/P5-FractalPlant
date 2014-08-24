// utility functions
float rndNoise(float _mag) {
  float mag = _mag;
  return noise( random(99999) + frameCount*random(0.001, 0.01)*mag );
}

float rvar(float x) {
  return random(-x, x);
}

// class
class fractalPlant {

  PVector ori, tgt, dir;
  float headingAngle, tangentLength, tangent_OriX, tangent_OriY, 
  tangent_TgtX, tangent_TgtY, rndAngleOri, rndAngleTgt;
  PShape cv;
  int cvSteps;  // curve vertex resolution
  int generation;
  fractalPlant fp;

  fractalPlant(float ox, float  oy, float  tx, float  ty, float tLength, int _cvStep, int gen) {
    ori = new PVector(ox, oy);
    tgt = new PVector(tx, ty);
    generation = gen;
    cvSteps = _cvStep;

    tangentLength = tLength;
    dir = PVector.sub(tgt, ori);
    //headingAngle = dir.heading(); // heading() not available in JS mode
    headingAngle = atan2(dir.y, dir.x);

    rndAngleOri = radians( random(-20, 20) );
    rndAngleTgt = radians( random(-60, 60) );
    tangent_OriX = tangentLength * cos(headingAngle + rndAngleOri) + ori.x;
    tangent_OriY = tangentLength * sin(headingAngle + rndAngleOri) + ori.y;
    tangent_TgtX = -tangentLength * cos(headingAngle + rndAngleTgt) + tgt.x;
    tangent_TgtY = -tangentLength * sin(headingAngle + rndAngleTgt) + tgt.y;

    // execute only once
    initializeCurveVertex();
  } // end of constructor

  void render() {
    addTip();
    drawCurveVertex();
  } // end of render

  void initializeCurveVertex() {
    if (generation > 0) {
      float numBranch;
      if (generation == 4) {
        numBranch = random(4, 16);  // random(2, 16);
      }
      else if (generation == 3) {
        numBranch = random(1, 6);  // random(1, 6);
      } 
      else {
        numBranch = random(1, 3);  // random(1, 3);
      }

      for (int i=0; i < numBranch; i++) {  // random number of branches
        float newLength = (ori.dist(tgt)+GEN_LENGTH) * abs(rvar(GEN_LENGTH_VAR)); 
        int newCvSteps = cvSteps-3;
        if (newCvSteps < 3) newCvSteps = 3;
        float rndAngle = radians( rvar(GEN_ANGLE) );
        float cgx = newLength*cos(headingAngle + rndAngle  /*+ rndNoise(0.5)*/);  //set target grow length + heading angle
        float cgy = newLength*sin(headingAngle + rndAngle  /*+ rndNoise(0.5)*/);
        float growRange = random(0.15, 0.95); //limit generation grow area 0=start, 1=end
        PVector j = getBzPoint(growRange).get(); 

        fp = new fractalPlant(j.x, j.y, j.x + cgx, j.y + cgy, tangentLength/2.0, newCvSteps, generation - 1 );
        allPlant.add(fp);
      } // end of loop branches
    } // end of generation
  } // end of initializeCurveVertex

  void drawCurveVertex() {
    for (float p=0; p < cvSteps; p++) {
      float tStart = p / (float)cvSteps;
      float tMid = (p+0.5f) / (float)cvSteps;
      float tEnd = (p+1.0f) / (float)cvSteps;
      PVector point_at_pStart = getBzPoint(tStart).get();
      PVector point_at_pMid = getBzPoint(tMid).get();
      PVector point_at_pEnd = getBzPoint(tEnd).get();
      // Make sure generation number is relevent to color
      noFill(); 
      colorMode(HSB, 360, 100, 100, 100);
      /***************/    stroke(G4_HUE, map(p, 0, cvSteps, 5, 100), 92, 60);      // stroke color
      if (generation == 3) stroke(G3_HUE, random(36, 85), random(40, 99), 60);
      if (generation == 2) stroke(G2_HUE, random(36, 85), random(40, 99), 60);
      if (generation == 1) stroke(G1_HUE, random(8, 60), random(60, 99), 60);
      if (generation == 0) stroke(G0_HUE, random(8, 60), random(60, 99), 60);
      colorMode(RGB, 255);

      strokeWeight(map(p, 0, cvSteps, 1, 0.1));         // stroke weight here
      beginShape();
      curveVertex(point_at_pStart.x, point_at_pStart.y);  // for curve vertex only
      curveVertex(point_at_pStart.x, point_at_pStart.y);
      curveVertex(point_at_pMid.x, point_at_pMid.y);
      curveVertex(point_at_pEnd.x, point_at_pEnd.y);
      curveVertex(point_at_pEnd.x, point_at_pEnd.y);   // for curve vertex only
      endShape();
    }
  } // end of drawCurveVertex

  void addTip() {
    float rndSize = random(0.25, 2);
    noStroke();
    colorMode(HSB, 360, 100, 100, 100);
    /***************/    stroke(G0_HUE, random(36, 85), random(40, 99), 60);      // stroke color
    if (generation == 3) stroke(G1_HUE, random(36, 85), random(40, 99), 60);
    if (generation == 2) stroke(G2_HUE, random(36, 85), random(40, 99), 60);
    if (generation == 1) stroke(G3_HUE, random(8, 60), random(60, 99), 60);
    if (generation == 0) stroke(G4_HUE, random(8, 60), random(60, 99), 60);
    colorMode(RGB, 255);
    ellipse(tgt.x, tgt.y, rndSize, rndSize);
  } // end of addTip

  PVector getBzPoint(float _step) {
    float step = _step;
    float x = bezierPoint(ori.x, tangent_OriX, tangent_TgtX, tgt.x, step);
    float y = bezierPoint(ori.y, tangent_OriY, tangent_TgtY, tgt.y, step);
    PVector bzPoint = new PVector(x, y);
    return bzPoint;
  } // end of getBzPoint
} // end of class fractalPlant
