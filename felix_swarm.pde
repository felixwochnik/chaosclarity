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
int svgNumber = 2;



PShape[] svgs = new PShape[svgNumber];
PShape[] symbols = new PShape[svgNumber];

void setup() {
  fullScreen(P2D,2);
  //size(500, 500, P2D);

  //surface.setResizable(true);
  
  // ARDUINO INTEGRATION
  final String portName = Serial.list()[2]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');  
  
  frameRate(30);
  ps = new ParticleSystem(new PVector(0,0));
  
  for (int i = 0; i < svgs.length; i++) {
    svgs[i] = loadShape("test/svg" + (i + 1) + ".svg");
    symbols[i] = loadShape("test/svgg" + (i + 1) + ".svg");
    //svgs[i].disableStyle();
  }
}

void serialEvent( Serial myPort) {
  val = int(myPort.readString());
  //redraw = true;
}

void draw() {
  //surface.setTitle( str(frameRate) );
  //translate(width/2, height/2);    // Move coordinate system to center of sketch
  background(bg);
  
  // !!!!!WORKING!!!!!!
  for (int i = 0; i < ps.particles.size(); i++) {
      for (int j = i + 1;  j < ps.particles.size(); j ++) {
        // connect every particle with a line, brightness depends on particle's lifespan
        colorMode(HSB,1);
        stroke(1, 0, lineCol, (ps.particles.get(i).lifespan / 1.5 ));
        //stroke(1, 0, 1, 1);
        strokeWeight(0.5);
        float positionXi = ps.particles.get(i).position.x;
        float positionYi = ps.particles.get(i).position.y;
        float positionXj = ps.particles.get(j).position.x;
        float positionYj = ps.particles.get(j).position.y;
        
        if ( abs((positionXi - positionXj )) < lineDistance && abs((positionYi - positionYj )) < 100 ){ 
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
        println(bg + " " + val); //print it out in the console
        ps.particles.get(i).ratio = ps.particles.get(i).ratio1;
        lineDistance = 100;
        ps.numberParticles = 250;
        if (bg >= 0) {
          bg -= 0.1;
        }        
        lineCol = 1;
      }
      
      // TRIGGERED
      else {
        int newPartNumb = 10;
        
        println(bg + " " + val + " TRIGGERED ");
        ps.particles.get(i).ratio = ps.particles.get(i).ratio2;
        ps.numberParticles = newPartNumb;
        if (bg < 255) {
          bg += 0.1;
        }
        lineCol = 0;
        //ps.particles.get(i).showSymbol = true;
        //lineDistance = 100;
        
        // make sure there are only 10 particles
        if (ps.particles.size() > newPartNumb) {
          ps.particles.get(i).add = random(0.001, 0.1);
          //shapeMode(CENTER);
          //shape(ps.particles.get(i).currentSymbol, ps.particles.get(i).position.x, ps.particles.get(i).position.y, ps.particles.get(i).currentSvg.width/ps.particles.get(i).ratio, ps.particles.get(i).currentSvg.height/ps.particles.get(i).ratio);
        }
        else {
          lineDistance = 100000;
          ps.particles.get(i).showSymbol = true;
        }
      }
    
}

}