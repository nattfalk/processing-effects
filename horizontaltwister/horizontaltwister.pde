int moveY = 0;

int[][] heightMap;
int[][] colorMap;
int[] yScale;

void loadHeightmap() {
  PImage img = loadImage("../common/gfx/heightmap2_256x256.jpg");
  heightMap = new int[256][256];
  colorMap = new int[256][256];
  
  for (int x=0; x<256; x++) {
    for (int y=0; y<256; y++) {
      color c = img.get(x, y);
      heightMap[x][y] = (int)((c & 0xFF) >> 2) + 50;
      colorMap[x][y] = c;
    }
  }
}

void precalcYOffset() {
  yScale = new int[128];

  for (int a=0; a<128; a++) {
    int h = (int)(sin((PI/128.0) * (float)a) * 50.0);
    yScale[a] = h;       
  }
}

void setup() {
  size(640, 512, P2D);
  frameRate(50);

  loadHeightmap();
  precalcYOffset();

  noStroke();
  background(0);
}

void draw() {
  background(0);
  for (int px=0; px<320; px++) {
    int x = px & 255;

    // Render upper half
    int prevY = 128;
    for(int hmy=0; hmy<128; hmy++) {
      // scale value    
      int sy = yScale[hmy];
      // original height value
      int mapY = (hmy + moveY) & 255;
      int h = heightMap[x][mapY];
      int c = colorMap[x][mapY];
      // scaled height value
      int sh = (int)((float)h * ((float)sy / 100.0));
    
      int y = 128-sh;
      if (y < prevY) {
        for (int yy=y; yy<prevY; yy++) {
          setPixel(px, yy, c);
        }
        prevY = y;
      }
    }    
    
    // Render lower half
    prevY = 128;
    for(int hmy=0; hmy<128; hmy++) {
      // scale value    
      int sy = yScale[hmy];
      // original height value
      int mapY = (-hmy + moveY) & 255;
      int h = heightMap[x][mapY];
      int c = colorMap[x][mapY];
      // scaled height value
      int sh = (int)((float)h * ((float)sy / 100.0));
    
      int y = 129+sh;
      if (y > prevY) {
        for (int yy=prevY; yy<y; yy++) {
          setPixel(px, yy, c);
        }
        prevY = y;
      }
    }    
    
  } //<>//
  moveY++;
}

void setPixel(int x, int y, int pixelColor) {
  fill(pixelColor);
  square(x*2, y*2, 2);
}
