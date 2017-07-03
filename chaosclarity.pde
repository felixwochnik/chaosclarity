/* TODO:
  [ ]  "acceleration" fix
  [ ]  
  [ ]  
  [ ]  
  [ ]  
*/
import java.util.*;
ParticleSystem ps;
import processing.serial.*;
Serial myPort;
float val;
float bg;
color lineCol = 1;
float lineDistance = 100;
int svgNumber = 10;



PImage[] cages = new PImage[svgNumber];
PImage[] fills = new PImage[svgNumber];
PImage[] symbols = new PImage[svgNumber];

void setup() {
  fullScreen(P2D,1);
  smooth();
  //size(500, 500, P2D);
  
  // ARDUINO INTEGRATION
  final String portName = Serial.list()[2]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');  
  
  frameRate(30);
  ps = new ParticleSystem(new PVector(0,0)); // draw particle system in center because of translate, 1st line of draw()
  
  //load images
  for (int i = 0; i < svgNumber; i++) {
    cages[i] = loadImage("test/cage-" + (i + 1) + ".png");
    fills[i] = loadImage("test/fill-" + (i + 1) + ".png");
    symbols[i] = loadImage("test/symbol-" + (i + 1) + ".png");
  }
}

// arduino magic
void serialEvent( Serial myPort) {
  val = int(myPort.readString());
}

void draw() {
  translate(width/2, height/2); // Move coordinate system to center of sketch
  background(bg);
  
  // connect every particle with a line, brightness depends on particle's lifespan
  for (int i = 0; i < ps.particles.size(); i++) {
      for (int j = i + 1;  j < ps.particles.size(); j ++) {
        colorMode(HSB,1); // to use 0-1 color range
        stroke(1, 0, lineCol, (ps.particles.get(i).lifespan / 2.75 )); // line color
        strokeWeight(0.5); // line stroke weight
        
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
      // INACTIVE
      
      // FOR TESTING WITHOUT ARDUINO
      //if ( mousePressed && mouseButton == LEFT ) {
        
      if ( val < 15 ) {
        println("BG:" + bg + " Distance:" + val + " FPS:" + frameRate);
        ps.particles.get(i).ratio = ps.particles.get(i).ratio1; // change to phase 1 size
        lineDistance = 100; // draw line if <100px distance
        ps.numberParticles = ps.initialNumberParticles; // change back to initial number of particles
        ps.particles.get(i).MAX_CHANGE = 0.01; // change back to initial max_change
        lineCol = 1; // changes line color from black (on white) to white (on black)
                
        //fade BG color to black 
        if (bg >= 0) {
          bg -= 0.1;
        }        
      }
      
      // TRIGGERED
      else {        
        println("BG:" + bg + " Distance:" + val + " FPS:" + frameRate + " TRIGGERED"); // DEBUG
        ps.particles.get(i).ratio = ps.particles.get(i).ratio2; // change to phase 2 size
        ps.particles.get(i).position = ps.particles.get(i).position2; //change to phase2 spawn position
        lineCol = 0; // changes line color from white (on black) to black (on white)
        
        // how many particles to leave
        int newPartNumb = 10;
        ps.numberParticles = newPartNumb;
        
        // fade BG color to white
        if (bg < 255) {
          bg += 0.1;
        }
        
        // make sure there are only 10 particles
        if (ps.particles.size() > newPartNumb) {
          ps.particles.get(i).add = random(0.01, 0.05);
        }
        
        // then do this:
        else {
          ps.particles.get(i).MAX_CHANGE = random(0.001, 0.005); // reduce lifespan reduction speed
          lineDistance = 100000; // connect all symbols
          ps.particles.get(i).showSymbol = true; // show symbol
          ps.particles.get(i).hideCage = ps.particles.get(i).hiddenCage; // random: show cage yey, nay?
          ps.particles.get(i).active = 255; // sets Fill's BG color
        }
      }
    
}

}