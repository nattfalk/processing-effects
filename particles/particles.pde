int renderParticleCount = 128;
int updateParticleCount = 0;

class Particle
{
  long x;
  long y;
  long vx;
  long vy;
}

Particle[] particles;
int[][] velocityMap;

void loadVelocityMap() {
  PImage img = loadImage("../common/gfx/turb2_320x256.png");
  velocityMap = new int[320][256];
  
  for (int x=0; x<320; x++) {
    for (int y=0; y<256; y++) {
      color c = img.get(x, y);
      velocityMap[x][y] = (int)c & 0xFF;
    }
  }
}

void setPixel(int x, int y, int pixelColor) {
  fill(pixelColor);
  square(x*2, y*2, 2);
}

void setup() {
  size(640, 512, P2D);
  frameRate(50);

  loadVelocityMap();

  particles = new Particle[renderParticleCount];
  for(int i=0; i<renderParticleCount; i++) {

    particles[i] = new Particle();
    particles[i].x = ((320-renderParticleCount)/2 + i) << 8;
    particles[i].y = 128 << 8;
    
    //particles[i].vx = -1 << 7;
    //particles[i].vx = heightMap[;
    particles[i].vy = (int)(random(1, 6)*-1) << 5;
  }
  
  noStroke();
  background(0);
}

int updateCount = 0;

void draw() {
  background(0);

  renderParticles();
  updateParticles();
  
  if (updateParticleCount < renderParticleCount)
  {
    if (updateCount++ % 8 == 0)
      updateParticleCount++;
  }
} //<>//

void renderParticles()
{
  for(int i=0; i<renderParticleCount; i++) {
    Particle p = particles[i];
    
    int px = (int)p.x >> 8;
    int py = (int)p.y >> 8;
    
    setPixel(px, py, 255);
  }
}

void updateParticles() {
  for(int i=0; i<updateParticleCount; i++) {
    Particle p = particles[i];

    int px = (int)(p.x >> 8);
    int py = (int)(p.y >> 8);
    if (px < 0 || py < 0 || px >= 320 || py >= 259)
      continue;

    p.vx = (p.vx + (velocityMap[px][py] - 128)) >> 1;

    p.x += p.vx;
    p.y += p.vy;
  }
}
