// Random Seed Settings
long FRACTAL_SEED = 54143;
long COLOR_SEED = 5606;

//    Settings                                    //Range,       def val
int   NUM_GENERATION  = 4;                        //             4
float BASE_LENGTH = 180,                          //(1, 220)     180
      BASE_LENGTH_VAR = 60,                       //(1, 100)     60
      BASE_ROTATION = 0,                          //(0, 360)     0
      TOTAL_BRANCH = 20,                          //(1, 40)      12
      ANGLE_DISTRIBUTION = 120,                   //(0, 200)     120
      GEN_LENGTH = 0,                             //-100, 100)   0
      GEN_LENGTH_VAR = 0.5,                       //             0.5 
      GEN_ANGLE = 60,                             //(1, 360)     60
      TANGENT_LENGTH = 80,                        //(20, 180)    80
      G0_HUE, G1_HUE, G2_HUE, G3_HUE, G4_HUE;

ArrayList allPlant; 
fractalPlant fp;

void setup() {
  size(800, 800);
  smooth(16);
  randomHUE();
} // end of setup

void draw() {
  background(#111111);
  initFractalPlant();
  for (int i = allPlant.size()-1; i >= 0; i--) {
    fractalPlant p = (fractalPlant) allPlant.get(i);
    p.render();
  }
  fill(#ffffff);
  noStroke();
  ellipse(width/2, height/2, 4, 4);  // draw tiny dot at center
  //text((int)frameRate + " FPS", 10, 20);
  noLoop();  // ***disable loop and redraw only when key pressed***
} // end of draw

void initFractalPlant() {
  randomSeed(FRACTAL_SEED); 
  PVector ORIGIN = new PVector(width/2, height/2);
  allPlant = new ArrayList();
  for (int i = 0; i < TOTAL_BRANCH; i++) {
    float cLength = BASE_LENGTH + rvar(BASE_LENGTH_VAR) ; // random base length
    float rnd = radians( random(120)*ANGLE_DISTRIBUTION + BASE_ROTATION); //rgs
    float cgx = cLength*cos(rnd /*+ rndNoise(0.5)*/);
    float cgy = cLength*sin(rnd /*+ rndNoise(0.5)*/);   
    fp = new fractalPlant(ORIGIN.x, ORIGIN.y, ORIGIN.x + cgx, ORIGIN.y + cgy, TANGENT_LENGTH, 8, NUM_GENERATION);
    allPlant.add(fp);
  }
}

void randomHUE() {
  randomSeed(COLOR_SEED); 
  G0_HUE = random(360);
  G1_HUE = random(360);
  G2_HUE = random(360);
  G3_HUE = random(360);
  G4_HUE = random(360);
}

void keyPressed() {
  if (key == 'z' | key == 'Z') {
    FRACTAL_SEED = millis();
    println("FRACTAL_SEED_NUM: " + FRACTAL_SEED);
    redraw();
  }
  if (key == 'x' | key == 'X') {
    COLOR_SEED = millis();
    randomHUE();
    redraw();
  }
}
