// Referenced https://processing.org/examples/simpleparticlesystem.html

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  boolean isActive = false;

  ParticleSystem(PVector position) {
    origin = position.copy();
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
    particles.add(new Particle(origin));
  }
  
  void setPosition(PVector newPos) {
    origin = newPos;
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}
