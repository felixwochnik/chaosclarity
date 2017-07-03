class particle {
  PVector position;
  PVector acceleration;
  float lifespan;
  PShape currentSvg;
  PShape currentSymbol;
  int selectedSvg;
  float ratio;
  float ratio1;
  float ratio2;
  final float maxLifespan;
  final float MAX_CHANGE;
  boolean goUp;
  float add;
  float lifespanRand;
  int col;
  boolean showSymbol = false;
  color[] colors = {
    
    color(93,203,238),
    color(220,31,38),
    color(112,197,155),
    color(237,45,131),
    color(239,245,220),
    color(120,54,149),
    color(251,172,29)
  };
  

  particle() {
    acceleration = new PVector(random(-0.25,0.25), random(-0.25,0.25));
    position = new PVector(random(width),random(height));
    selectedSvg = int(random(svgNumber));
    currentSvg = svgs[selectedSvg];
    currentSymbol = symbols[selectedSvg];
    lifespan = 0;
    ratio = ratio1;
    ratio1 = random(20,50);
    ratio2 = random(5,10);
    maxLifespan = random(0.5, 0.75);
    MAX_CHANGE=0.01;
    goUp = true;
    add = random(0.0001, MAX_CHANGE);
    col = colors[(int)random(6)];
    lifespanRand = map(ratio,20,50,3,1.5);
    //random(1,4);
  }

  void run() {
    update();
    display();
 }
  // Method to update position
  void update() {
    position.add(acceleration);

   
    if ( lifespan > maxLifespan) {
      goUp=false;
      add=(MAX_CHANGE/2);  //You need max value here to avoid a bug
    }
   
    if ( lifespan <= 0) {  //NOT equal to zero (!)
      goUp=true;     add=MAX_CHANGE;  //You need max value here to avoid a bug
    }
   
    int stepDir=goUp?1:-1;  //Terniary operator.. stepDir is +1 if tru, -1 otherwise
    lifespan += stepDir*add;
    
  }

  // Method to display
  void display() {   
    colorMode(RGB, 255);
    //strokeWeight(30);
    //stroke( col, lifespan*255 );
    //fill(0, lifespan*255);
    //tint(255, lifespan*255);    
    
      if (showSymbol == true) {
        shapeMode(CENTER);
        shape(currentSymbol, position.x, position.y, currentSymbol.width/ratio, currentSymbol.height/ratio);
      }
    
    shapeMode(CENTER);
    shape(currentSvg, position.x, position.y, currentSvg.width/ratio, currentSvg.height/ratio);
    
  }  

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0) {
      return true;
    } else {
      return false;
    }
  }
}