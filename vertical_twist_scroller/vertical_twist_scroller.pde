final int WIDTH = 640;
final int HEIGHT = 512;

color white = color(255, 255, 255);

int x = 0;

void drawLine(int x1, int y1, int x2, int y2, int c) {
  stroke(c);
  strokeWeight(3);
  line(x1, y1, x2, y2);
}

void settings() {
  size(WIDTH, HEIGHT, P2D);
}

void setup() {
  frameRate(50);
}

PVector rotateY(PVector p, int angle) {
  
  float a = (float)(PI / 180.0f) * (angle % 360.0f);
  float s = (float)Math.sin(a);
  float c = (float)Math.cos(a);

  return new PVector(
    (p.x * c) - (p.z * s) + (WIDTH/2),
    p.y + (HEIGHT/2)); //,
    //(-p.x * s) + (p.z * c));
  
}

void draw() {
  background(0);
  
  x += 10;
  
  PVector p1 = new PVector(-50, -50, 10);
  PVector p2 = new PVector(-50, 50, 10);
  
  PVector r1 = rotateY(p1, x);
  PVector r2 = rotateY(p2, x);
  
  //print("r1: " + r1);
  //println(", r2: " + r2);
  drawLine((int)r1.x, (int)r1.y, (int)r2.x, (int)r2.y, white);
  
}
