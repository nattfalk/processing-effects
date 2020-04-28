int moveY = 0;
int sinV1 = 0;
int sinV2 = 0;

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
      heightMap[x][y] = (int)((c & 0xFF) >> 1) + 30;
      colorMap[x][y] = c;
    }
  }
}

void precalcYOffset() {
  yScale = new int[128];

  for (int a=0; a<128; a++) {
    int h = (int)(sin((PI/128.0) * (float)a) * 60.0);
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
  sinV2++;
  for (int px=0; px<320; px++) {
    int x = px & 255;

    int sinY = (int)(sin((PI/128.0)*(float)(px + sinV1)) * 64.0);
    int yPos = (int)(sin((PI/256.0)*(float)(sinV2+px)) * 32.0) + 128;

    // Render upper half
    int prevY = yPos;
    for(int hmy=0; hmy<128; hmy++) {
      // calculate y offset into height and colormap
      int mapY = (hmy + moveY + sinY) & 255;
      // original height value
      int h = heightMap[x][mapY];
      int c = colorMap[x][mapY];
      // scale height value
      int sh = (int)((float)h * ((float)yScale[hmy] / 100.0));
    
      int y = yPos-sh;
      if (y < prevY) {
        for (int yy=y; yy<prevY; yy++) {
          setPixel(px, yy, c);
        }
        prevY = y;
      }
    }    
    
    // Render lower half
    prevY = yPos;
    for(int hmy=0; hmy<128; hmy++) {
      // calculate y offset into height and colormap
      int mapY = (-hmy + moveY + sinY) & 255;
      // original height value
      int h = heightMap[x][mapY];
      int c = colorMap[x][mapY];
      // scale height value
      int sh = (int)((float)h * ((float)yScale[hmy] / 100.0));
    
      int y = yPos + 1 + sh;
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
