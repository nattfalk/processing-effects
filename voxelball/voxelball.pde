int pixelCount;
float angle;

void setup() {
  size(640, 512, P2D);
  frameRate(50);

  noStroke();
  background(0);
}

void draw() {
  int prevX = -999; //<>//
  int prevY = -999;

  pixelCount = 0;

  for(int a=0; a<128; a++) {
    int x = (int)(sin((PI/512.0)*(float)a)*64.0) + 160;
    int y = -(int)(cos((PI/512.0)*(float)a)*64.0) + 128;

    angle = ((128.0/PI) * atan2((float)y-128.0, (float)x-160.0));
    angle = angle > 0.0 ? angle : 256.0 + angle;
    
    if (x != prevX || y != prevY) {
      setPixel2(x, y, 255.0); //(255.0/1024.0)*(float)a);
      prevX = x;
      prevY = y;
      pixelCount++;
    }
  }
}

void setPixel(int x, int y, int pixelColor) {
  fill(pixelColor);
  square(x*2, y*2, 2);
}

void setPixel2(int x, int y, float pixelColor) {
  fill(pixelColor);
  square(x*2, y*2, 2);
}
