class ParticleSystem {
  ArrayList<particle> particles = new ArrayList<particle>();
  int initialNumberParticles = 250; // only set this once, gets reused in distance measurement
  int numberParticles = initialNumberParticles; // gets redefined for phase 2
  PVector origin; // found it like this, but works

// found it like this, but works
  ParticleSystem(PVector position) {
    origin = position.copy();
    particles = new ArrayList<particle>();
  }
  
// found it like this, but works
  void addParticle() {        
    for (int i = 0; i < numberParticles; i++) {
      if (particles.size() < numberParticles) {
        particles.add(new particle(i));
      }
    }
  
  }

// found it like this, but works
  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      particles.get(i).run();
      if (particles.get(i).isDead()) {
        particles.remove(i);
      }
    }
  }
  
  

  
}