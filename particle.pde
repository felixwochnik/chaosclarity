class particle {
  // initialize stuff
  // general attributes
  PVector position;
  PVector position2;
  PVector acceleration;
  float lifespan;
  float COUNTER;
  // select illustration
  PImage currentFill;
  PImage currentCage;
  PImage currentCageline;
  PImage currentSymbol;
  int selectedSvg;
  // determine size
  float ratio;
  float ratio1;
  float ratio2;
  // everything concerning lifespan
  final float maxLifespan;
  float minLifespan;
  float MAX_CHANGE;
  boolean goUp;
  float add;
  
  final float maxCounter;
  float minCounter;
  float MAX_CHANGE2;
  boolean goUp2;
  float add2;
  //float reduce;
  // determine opacity and shit
  float opacity;
  int active;
  // phase 2, what to display
  boolean showSymbol = false;
  int showCage;
  int randomizeCage;
  int[] categories = {
    int(random(1,3)),
    int(random(4,6)),
    int(random(7,9)),
    int(random(10,12)),
    int(random(13,15)),
  };
  int selectedCategory;
  String currentName;
  int id;
  

  particle(int a, String name) {
    id = a;
    currentName = name;
    
    
    acceleration = new PVector(random(-0.25,0.25), random(-0.25,0.25)); // movement speed
    position = new PVector(random(-width/2.1, width/2.1),random(-height/2.1, height/2.1)); //start position phase 1
    position2 = new PVector(random(-width/4, width/4),random(-height/4, height/4)); // start position phase 2, slightly smaller
    
    
    if (phaseTrigger == true) {
      selectedSvg = categories[id];
    }
    else {
      selectedSvg = int(random(svgNumber)); // select Symbol, Cage & Fill
    }
    currentFill = fills[selectedSvg];
    currentCage = cages[selectedSvg];
    currentCageline = cagelines[selectedSvg];
    currentSymbol = symbols[selectedSvg];
    
    lifespan = 0; // initial lifespan
    COUNTER = 0; // initial lifespan
    
    ratio = 0;
    ratio1 = random(7.5,10); // pahse 1: size relative to image size
    ratio2 = random(3,6); // phase 2
    maxLifespan = random(0.75, 1); // max opacity
    minLifespan = 0;
    MAX_CHANGE = 0.005; // used for calculation how much lifespan to add/reduce  
    goUp = true; // determines whether to add or reduce lifespan
    maxCounter = maxLifespan; // max opacity
    minCounter = minLifespan;
    MAX_CHANGE2 = 0.005; // used for calculation how much lifespan to add/reduce  
    goUp2 = true; // determines whether to add or reduce lifespan
    randomizeCage = (int) random(1,4); // randomize whther cage is shown in phase 2
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
      add=(MAX_CHANGE);  //You need max value here to avoid a bug
    }
    //add
    if ( lifespan <= minLifespan) {  //NOT equal to zero (!)
      goUp=true;
      add=MAX_CHANGE;  //You need max value here to avoid a bug
    }
    int stepDir=goUp?1:-1;  //Terniary operator.. stepDir is +1 if tru, -1 otherwise
    lifespan += stepDir*add;
    
    if (lifespan > 0 && phaseTrigger == false) {
      COUNTER = lifespan;
    }
    else {
      //reduce
      if ( COUNTER > maxCounter) {
        goUp2=false;
        add2=(MAX_CHANGE2);  //You need max value here to avoid a bug
      }
      //add
      if ( COUNTER <= minCounter) {  //NOT equal to zero (!)
        goUp2=true;
        add2=MAX_CHANGE2;  //You need max value here to avoid a bug
      }
      int stepDir2=goUp2?1:-1;  //Terniary operator.. stepDir is +1 if tru, -1 otherwise
      COUNTER += stepDir2*add2;
    }
    
    opacity = COUNTER*255;

  }

  // Method to display
  void display() {   
    colorMode(RGB, 255);
    
    if (showSymbol == false) { //schaltet in phase 2 aus
      imageMode(CENTER);
      tint(active, opacity); // hides conncting line under illustration, according to BG color
      image(currentFill, position.x, position.y, currentFill.width/ratio, currentFill.height/ratio);
    }
    
    tint(255, opacity);    
    
    
    if (showSymbol == true) { //schaltet in phase 2 ein
      imageMode(CENTER);
      image(currentSymbol, position.x, position.y, currentSymbol.width/ratio, currentSymbol.height/ratio);
    }
    
    
    if (showSymbol == false) { //schaltet in phase 2 aus
      imageMode(CENTER);
      image(currentCage, position.x, position.y, currentCage.width/ratio, currentCage.height/ratio);
    }
    
    // random Cage durchstreichen, nur wenn TRIGGERED
    if (showCage == 1) {
      imageMode(CENTER);
      image(currentCageline, position.x, position.y, currentCageline.width/ratio, currentCageline.height/ratio);
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