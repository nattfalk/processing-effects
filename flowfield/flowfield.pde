//
// Test with noise-based flowfields
// Based on the article:
// https://codepen.io/DonKarlssonSan/post/particles-in-simplex-noise-flow-field
//

final int WIDTH = 640;
final int HEIGHT = 512;

final int scale = 32;
final int vec_size = floor((scale / 2) * 0.8);
final float noise_scale = 0.08;
final int max_particles = 100;

class Particle {
  PVector pos;
  PVector acc = new PVector(0, 0);
  PVector vel = new PVector((float)(Math.random()*2-1), (float)(Math.random()*2-1));

  Particle(float x, float y) {
    this.pos = new PVector(x, y);
  }

  void update(PVector acc) {
    this.acc.add(acc);
    this.vel.add(this.acc);
    this.vel.limit(1.5);
    this.pos.add(this.vel);

    if (this.pos.x < 0 || this.pos.x >= WIDTH || this.pos.y < 0 || this.pos.y >= HEIGHT) {
      this.pos.x = (float)(Math.random() * 300 - 150) + WIDTH / 2;
      this.pos.y = (float)(Math.random() * 300 - 150) + HEIGHT / 2;
    }

    this.acc.mult(0);
  }
}

int cols, rows;
PVector[] flowfield;
Particle[] particles;

void setup() {
  size(640, 480);

  cols = floor(WIDTH / scale);
  rows = floor(HEIGHT / scale);

  particles = new Particle[max_particles];
  for (int i=0; i<max_particles; i++) {
    particles[i] = new Particle(
      (float)(Math.random() * 500 - 250) + WIDTH / 2, 
      (float)(Math.random() * 500 - 250) + HEIGHT / 2);
  }
}

void draw() {
  noFill();
  background(255);
  stroke(0, 128);

  float flowZ = frameCount * 0.006; // For moving flowfield
  //float flowZ = 0; // For static flowfield

  // Create flowfield
  flowfield = new PVector[cols * rows];
  for (int y=0; y<rows; y++) {
    for (int x=0; x<cols; x++) {
      float angle = noise(x * noise_scale, y * noise_scale, flowZ) * TWO_PI*2;
      flowfield[x + y * cols] = PVector.fromAngle(angle);
    }
  }

  // Render grid and flow-vectors
  for (int y=0; y<rows; y++) {
    for (int x=0; x<cols; x++) {
      rect(x*scale, y*scale, scale, scale);

      int px = floor(x * scale + (scale / 2));
      int py = floor(y * scale + (scale / 2));
      PVector flowVec = flowfield[x + y * cols];

      line(px, py, px + floor(flowVec.x * vec_size), py + floor(flowVec.y * vec_size));
      circle(px, py, 4);
    }
  }

  // Render particles
  fill(40, 90, 120);
  stroke(40, 90, 120);
  for (Particle p : particles) {
    int fx = floor(p.pos.x / scale);
    int fy = floor(p.pos.y / scale);

    if (fx >= 0 && fx < cols && fy >= 0 && fy < rows)
      p.update(flowfield[fx + fy * cols]);

    circle(p.pos.x, p.pos.y, 6);
  }
}
