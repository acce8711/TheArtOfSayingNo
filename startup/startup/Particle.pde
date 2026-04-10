// Referenced https://processing.org/examples/simpleparticlesystem.html with some modifications for randomisation of particle properties

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  float xoff = 0.0;
  Perlin particlePerlin = new Perlin(100);
  float noiseVal = particlePerlin.octaveNoise(xoff, random(0, 100), 0.8, 4, 0.8);

  Particle(PVector l) {
    acceleration = new PVector(0, -0.1);
    velocity = new PVector(random(-noiseVal * 3, noiseVal * 3), random(-noiseVal - 1, noiseVal));
    position = l.copy();
    lifespan = 80.0;
  }

  void run() {
    update();
    display();
    noiseVal = particlePerlin.octaveNoise(xoff, random(0, 100), 0.8, 4, 0.8);
  }

  // Method to update position
  void update() {
    acceleration.mult(1 * noiseVal);
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 2;
    xoff++;
  }

  // Method to display
  void display() {
    stroke(color(lifespan * 10, lifespan * 3, 0), 255);
    fill(color(lifespan * 10, lifespan * 3, 0), 255);

    pushMatrix();
    translate(position.x, position.y);
    rotate(radians(noiseVal + xoff) * 3);
    rectMode(CENTER);
    rect(0, 0, noiseVal * 10, noiseVal * 10);
    popMatrix();
  }

  // Is the particle still useful?
  boolean isDead() {
    return lifespan < 0.0;
  }
}
