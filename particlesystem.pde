class ParticleSystem {
  //ArrayList<particle> particles;
  ArrayList<particle> particles = new ArrayList<particle>();
  int numberParticles = 250;
  
  PVector origin;

  ParticleSystem(PVector position) {
    origin = position.copy();
    particles = new ArrayList<particle>();
    
  }
  
  

  void addParticle() {    
    for (int i = 0; particles.size() < numberParticles; i++) {
      particles.add(new particle());
    }
    
  }
  void reset() {
      ps = new ParticleSystem(new PVector(0,0));
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      particles.get(i).run();
      if (particles.get(i).isDead()) {
        particles.remove(i);
      }
    }
  }
  
  

}