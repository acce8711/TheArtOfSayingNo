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
    // Set acceleration to slight upwards direction
    acceleration = new PVector(0, -0.1);
    // Randomise the initial particle velocity and angle using random and Perlin noise
    velocity = new PVector(random(-noiseVal * 3, noiseVal * 3), random(-noiseVal - 1, noiseVal));
    position = l.copy();
    // Set the lifespan
    lifespan = 80.0;
  }

  void run() {
    update();
    display();
    // Update the noiseVal based on the incrementing xoff value and a random y value
    noiseVal = particlePerlin.octaveNoise(xoff, random(0, 100), 0.8, 4, 0.8);
  }

  // Method to update position
  void update() {
    // Modify the acceleration with the current Perlin noiseVal
    acceleration.mult(1 * noiseVal);
    velocity.add(acceleration);
    position.add(velocity);
    
    // Decrease the lifespan per update call
    lifespan -= 2;
    
    // Increment the x offset
    xoff++;
  }

  // Method to display
  void display() {
    stroke(color(lifespan * 10, lifespan * 3, 0), 255);
    fill(color(lifespan * 10, lifespan * 3, 0), 255);

    pushMatrix();
    translate(position.x, position.y);
    // Apply rotation to make the particle spin as it travels
    rotate(radians(noiseVal + xoff) * 3);
    rectMode(CENTER);
    rect(0, 0, noiseVal * 10, noiseVal * 10);
    popMatrix();
  }

  // Return if the particle's lifespan has not been exceeded
  boolean isDead() {
    return lifespan < 0.0;
  }
}
