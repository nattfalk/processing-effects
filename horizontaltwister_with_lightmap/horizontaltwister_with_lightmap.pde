int moveY = 0; //<>//
int sinV1 = 0;

int[][] heightMap;
int[][] colorMap;
int[][] lightMap;
int[] yScale;

void loadHeightmap() {
  PImage img = loadImage("../common/gfx/heightmap2_256x256.jpg");
  PImage imgLightMap = loadImage("../common/gfx/lightmap_320x256.jpg");
  heightMap = new int[256][256];
  colorMap = new int[256][256];
  lightMap = new int[320][256];
  
  for (int x=0; x<256; x++) {
    for (int y=0; y<256; y++) {
      color c = img.get(x, y);
      heightMap[x][y] = ((c & 0xFF) >> 2) + 50;
      colorMap[x][y] = c;
    }
  }

  for (int x=0; x<320; x++) {
    for (int y=0; y<256; y++) {
      color c = imgLightMap.get(x, y);
      lightMap[x][y] = c & 0xFF;
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
  sinV1++;
  for (int px=0; px<320; px++) {
    int x = px & 255;

    int sinY = (int)(sin((PI/128.0)*(float)(px + sinV1)) * 64.0);

    // Render upper half
    int prevY = 128;
    for(int hmy=0; hmy<128; hmy++) {
      // scale value    
      int sy = yScale[hmy];
      // original height value
      int mapY = (hmy + moveY + sinY) & 255;
      int h = heightMap[x][mapY];
      int c = colorMap[x][mapY];
      int l = lightMap[px][(128+hmy) & 0xFF];
      float lc = (float)(c & 0xFF) * ((float)l / 255.0);
      
      // scaled height value
      int sh = (int)((float)h * ((float)sy / 100.0));
    
      int y = 128-sh;
      if (y < prevY) {
        for (int yy=y; yy<prevY; yy++) {
          setPixel2(px, yy, lc);
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
      int mapY = (-hmy + moveY + sinY) & 255;
      int h = heightMap[x][mapY];
      int c = colorMap[x][mapY];
      int l = lightMap[px][(128+hmy) & 0xFF];
      float lc = (float)(c & 0xFF) * ((float)l / 255.0);

      // scaled height value
      int sh = (int)((float)h * ((float)sy / 100.0));
    
      int y = 129+sh;
      if (y > prevY) {
        for (int yy=prevY; yy<y; yy++) {
          setPixel2(px, yy, lc);
        }
        prevY = y;
      }
    }    
    
  }
  moveY++;
}

void setPixel(int x, int y, int pixelColor) {
  fill(pixelColor);
  square(x*2, y*2, 2);
}

void setPixel2(int x, int y, float pixelColor) {
  fill(pixelColor);
  square(x*2, y*2, 2);
}