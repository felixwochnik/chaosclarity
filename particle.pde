class particle {
  // initialize stuff
  // general attributes
  PVector position;
  PVector position2;
  PVector acceleration;
  float lifespan;
  // select illustration
  PImage currentFill;
  PImage currentCage;
  PImage currentSymbol;
  int selectedSvg;
  // determine size
  float ratio;
  float ratio1;
  float ratio2;
  // everything concerning lifespan
  final float maxLifespan;
  float MAX_CHANGE;
  boolean goUp;
  float add;
  //float reduce;
  // determine color and shit
  int col;
  color[] colors = {
    
    color(93,203,238),
    color(220,31,38),
    color(112,197,155),
    color(237,45,131),
    color(239,245,220),
    color(120,54,149),
    color(251,172,29)
  };
  int active;
  // phase 2, what to display
  boolean showSymbol = false;
  int hideCage = 0;
  int hiddenCage;
  

  particle() {
    acceleration = new PVector(random(-0.25,0.25), random(-0.25,0.25)); // movement speed
    position = new PVector(random(-width/2.1, width/2.1),random(-height/2.1, height/2.1)); //start position phase 1
    position2 = new PVector(random(-width/3, width/3),random(-height/3, height/3)); // start position phase 2, slightly smaller
    selectedSvg = int(random(svgNumber)); // select Symbol, Cage & Fill
    currentFill = fills[selectedSvg];
    currentCage = cages[selectedSvg];
    currentSymbol = symbols[selectedSvg];
    lifespan = 0; // initial lifespan
    ratio = ratio1;
    ratio1 = random(7.5,15); // pahse 1: size relative to image size
    ratio2 = random(2,5); // phase 2
    maxLifespan = random(0.75, 1); // max opacity 
    MAX_CHANGE = 0.01; // used for calculation how much lifespan to add/reduce  
    goUp = true; // determines whether to add or reduce lifespan
    //add = random(0.0001, MAX_CHANGE); // amount to add to lifespan
    //reduce = add/2; // amount to reduce from lifespan
    col = colors[(int)random(6)];
    hiddenCage = (int) random(2) -1; // randomize whther cage is shown in phase 2
    active = 0; // initial color of Fill
  }

  void run() {
    update();
    display();
 }
 
  // Method to update position & lifespan
  void update() {
    position.add(acceleration);
    
    //reduce
    if ( lifespan > maxLifespan) {
      goUp=false;
      add=(MAX_CHANGE/1.5);  //You need max value here to avoid a bug
    }
    //add
    if ( lifespan <= 0) {  //NOT equal to zero (!)
      goUp=true;
      add=MAX_CHANGE;  //You need max value here to avoid a bug
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
    
    if (hideCage == 0) {
      imageMode(CENTER);
      tint(active, lifespan*255); // hides conncting line under illustration, according to BG color
      image(currentFill, position.x, position.y, currentFill.width/ratio, currentFill.height/ratio);
    }
    
    tint(255, lifespan*255);    
    
    
    if (showSymbol == true) {
      imageMode(CENTER);
      image(currentSymbol, position.x, position.y, currentSymbol.width/ratio, currentSymbol.height/ratio);
    }
    
    if (hideCage == 0) {
      imageMode(CENTER);
      // TODO: entfernen, wenn Bella mehr Illus liefert 
      //tint(col, lifespan*255);
      image(currentCage, position.x, position.y, currentCage.width/ratio, currentCage.height/ratio);
    }
    
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