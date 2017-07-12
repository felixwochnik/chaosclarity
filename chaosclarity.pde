/* TODO:
  [ ]  "acceleration" fix
  [ ]  
  [ ]  
  [ ]  
  [ ]  
*/
import java.util.*;
ParticleSystem ps;
/*import processing.serial.*;
Serial myPort;*/
float val;
float bg;
color lineCol = 1;
float lineDistance = 100;
int svgNumber = 15;


// import sound
/*import ddf.minim.*;
import ddf.minim.effects.*;
Minim minim;
AudioPlayer stressing;
AudioPlayer soothing;*/



PImage[] cages = new PImage[svgNumber];
PImage[] cagelines = new PImage[svgNumber];
PImage[] fills = new PImage[svgNumber];
PImage[] symbols = new PImage[svgNumber];


void setup() {
  fullScreen(P2D,2);
  smooth();
  noCursor();
  //size(500, 500, P2D);
  
  /*
  minim = new Minim(this);
  stressing = minim.loadFile("black-noise.mp3");
  soothing = minim.loadFile("meer.wav");
  */
  
  // ARDUINO INTEGRATION
  /*
  final String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');
  */
  
  frameRate(30);
  ps = new ParticleSystem(new PVector(0,0)); // draw particle system in center because of translate, 1st line of draw()
  
  //load images
  for (int i = 0; i < svgNumber; i++) {
    cages[i] = loadImage("test/cage-" + (i + 1) + ".png");
    cagelines[i] = loadImage("test/cageline-" + (i + 1) + ".png");
    fills[i] = loadImage("test/fill-" + (i + 1) + ".png");
    symbols[i] = loadImage("test/symbol-" + (i + 1) + ".png");
  }
}

// arduino magic
/*
void serialEvent( Serial myPort) {
  val = int(myPort.readString());
}
*/

void draw() {
  translate(width/2, height/2); // Move coordinate system to center of sketch
  background(bg);
  
  // connect every particle with a line, brightness depends on particle's lifespan
  for (int i = 0; i < ps.particles.size(); i++) {
      for (int j = i + 1;  j < ps.particles.size(); j ++) {
        colorMode(HSB,1); // to use 0-1 color range
        stroke(1, 0, lineCol, (ps.particles.get(i).lifespan / 1.25 )); // line color
        strokeWeight(0.75); // line stroke weight
        
        // define stuff for better legibility
        float positionXi = ps.particles.get(i).position.x;
        float positionYi = ps.particles.get(i).position.y;
        float positionXj = ps.particles.get(j).position.x;
        float positionYj = ps.particles.get(j).position.y;
        
        // draws line between particles
        if ( abs((positionXi - positionXj )) < lineDistance && abs((positionYi - positionYj )) < lineDistance ){ 
          line(positionXi, positionYi, positionXj, positionYj);
        }
      }
    }
    
  colorMode(RGB, 255);
  ps.addParticle();  
  ps.run();
  
  for (int i = 0; i < ps.particles.size(); i++) {
      float changeSpeed = 0.05;
      // INACTIVE
      // FOR TESTING WITHOUT ARDUINO
      if ( mousePressed && mouseButton == LEFT ) {
      //if ( val < 15 ) {
        println(" Distance:" + val + " FPS:" + frameRate + "ratio:" + ps.particles.get(i).ratio); // DEBUG
        //ps.particles.get(i).ratio = ps.particles.get(i).ratio1; // change to phase 1 size
        lineDistance = 100; // draw line if <100px distance
        ps.numberParticles = ps.initialNumberParticles; // change back to initial number of particles
        ps.particles.get(i).MAX_CHANGE = 0.01; // change back to initial max_change
        lineCol = 1; // changes line color from black (on white) to white (on black)
        ps.particles.get(i).active = 0;
        ps.particles.get(i).opacity = ps.particles.get(i).lifespan*255;
        
        ps.particles.get(i).ratio = map(ps.particles.get(i).lifespan, 0, 1, ps.particles.get(i).ratio1 + 2.5, ps.particles.get(i).ratio1);
        
                
        //fade BG color to black 
        if (bg >= 0) {
          bg -= changeSpeed;
        }
        /*
        if (!stressing.isPlaying()) {
            soothing.rewind();
            soothing.pause();
            stressing.rewind();
            stressing.play();
        }
        */
      }
      
      // TRIGGERED
      else {
        ps.particles.get(i).opacity = ps.particles.get(i).lifespan*255;
        //println("BG:" + bg + " Distance:" + val + " FPS:" + frameRate + " ratio:" + ps.particles.get(i).ratio + " TRIGGERED"); // DEBUG
        println(ps.particles.get(0).id + " " + frameRate);
        
          
        lineCol = 0; // changes line color from white (on black) to black (on white)
        
        
        // how many particles to leave
        int newPartNumb = 5;
        ps.numberParticles = newPartNumb;

        
        // fade BG color to white
        if (bg <= 255) {
          bg += changeSpeed;
        }
        ps.particles.get(i).active = int(bg); // sets Fill's BG color
        
        // make sure there are only X particles
        if (ps.particles.size() > newPartNumb) {
          ps.particles.get(i).add = random(0.01, 0.05);
          
          // change to phase 2 size
          ps.particles.get(i).ratio += 0.5;
        }
        
        // then do this:
        else {
          // select symbols from category 1-5
          /* eigentlich könnte man es so lösen, aber dadurch dass die ArrayList beim löschen geshuffelt wird, ändert sich die Variable i willkürlich */
          //ps.particles.get(i).selectedCategory = ps.particles.get(i).id;
          /*
          ps.particles.get(i).currentSymbol = symbols[i];
          ps.particles.get(i).currentCageline = cagelines[i];
          */
          
          ps.particles.get(i).position = ps.particles.get(i).position2; //change to phase2 spawn position
          ps.particles.get(i).ratio = map(ps.particles.get(i).lifespan, 0, 1, ps.particles.get(i).ratio2 + 1.5, ps.particles.get(i).ratio2);
          //ps.particles.get(i).opacity = 255;
          ps.particles.get(i).MAX_CHANGE = random(0.0005, 0.0025); // reduce lifespan reduction speed
          lineDistance = 100000; // connect all symbols
          ps.particles.get(i).showSymbol = true; // show symbol
          ps.particles.get(i).hideCage = ps.particles.get(i).hiddenCage; // random: show cage yey, nay?
          
          /*
          if (!soothing.isPlaying()) {
            stressing.rewind();
            stressing.pause();
            soothing.rewind();
            soothing.play();
          }
          */
        }
      }
  }
}