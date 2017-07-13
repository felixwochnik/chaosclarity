class ParticleSystem {
  ArrayList<particle> particles = new ArrayList<particle>();
  int initialNumberParticles = 250; // only set this once, gets reused in distance measurement
  int numberParticles = initialNumberParticles; // gets redefined for phase 2
  PVector origin; // found it like this, but works
  String kategorie1 = "kategorie1";
  String kategorie2 = "kategorie2";
  String kategorie3 = "kategorie3";
  String kategorie4 = "kategorie4";
  String kategorie5 = "kategorie5";
  String nope = "nope";


  
// found it like this, but works
  void addParticle() {        
    for (int i = 0; particles.size() < numberParticles; i++) {
      
      if (phaseTrigger == true) {
        
        if (!particles.contains(kategorie1)) {
          particles.add(new particle(0, kategorie1));
        }
        if (!particles.contains(kategorie2)) {
          particles.add(new particle(1, kategorie2));
        }
        if (!particles.contains(kategorie3)) {
          particles.add(new particle(2, kategorie3));
        }
        if (!particles.contains(kategorie4)) {
          particles.add(new particle(3, kategorie4));
        }
        if (!particles.contains(kategorie5)) {
          particles.add(new particle(4, kategorie5));
        }
      }
      else {
        particles.add(new particle(99, nope)); // values don't matter
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