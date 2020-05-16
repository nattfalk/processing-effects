color white = color(255, 255, 255);
color red = color(255, 0, 0);
color green = color(0, 255, 0);
color blue = color(0, 0, 255);

float zAngle = 0.0;

int[] verticalLines = { 160, 200, 240, 280, 320, 360, 400, 440, 480 };

PVector[][] objectLines = {
  { new PVector(140, 68), new PVector(220, 128) },
  { new PVector(220, 128), new PVector(140, 188) },
  { new PVector(140, 188), new PVector(60, 128) },
  { new PVector(60, 128), new PVector(140, 68) }
};

PVector[] vertices = {
  new PVector(-100, -100, -100),
  new PVector( 100, -100, -100),
  new PVector( 100,  100, -100),
  new PVector(-100,  100, -100),
  new PVector(-100, -100,  100),
  new PVector( 100, -100,  100),
  new PVector( 100,  100,  100),
  new PVector(-100,  100,  100)
};

int[][] lines = {
  { 0, 1 }, // 0
  { 1, 2 }, // 1
  { 2, 3 }, // 2
  { 3, 0 }, // 3
  { 4, 5 }, // 4
  { 5, 6 }, // 5
  { 6, 7 }, // 6
  { 7, 0 }, // 7
  { 0, 4 }, // 8
  { 1, 5 }, // 9
  { 2, 6 }, // 10
  { 3, 7 }, // 11
};

int[][] polys = {
  { 0, 1, 2, 3, 0 },
  { 1, 5, 6, 2, 1 },
  { 5, 4, 7, 6, 5 },
  { 4, 0, 3, 7, 4 },
  { 0, 4, 5, 1, 0 },
  { 3, 2, 6, 7, 3 }
};


PVector[] rotatedVerts = new PVector[8];

int minVLX = 160;
int maxVLX = 480;

void setPixel(int x, int y, int c) {
  noStroke();
  fill(c);
  square(x, y, 2);
}

void setPixel2(int x, int y, int c) {
  noStroke();
  fill(c);
  square(x, y, 2*2);
}

void drawLine(int x1, int y1, int x2, int y2, int c) {
  stroke(c);
  strokeWeight(1);
  line(x1, y1, x2, y2);
}

void drawLine(float x1, float y1, float x2, float y2, int c) {
  drawLine((int)x1, (int)y1, (int)x2, (int)y2, c);
}

void drawLine3(float x1, float y1, float z1, float x2, float y2, float z2, int c) {
  stroke(c);
  strokeWeight(1);
  line((int)x1, (int)y1, (int)z1, (int)x2, (int)y2, (int)z2);
}

boolean isHidden(PVector v1, PVector v2, PVector v3) {
/*
;  HIDDEN LINES
;  ~~~~~~~~~~~~
;  (Y2-Y3)*(X1-X2)-(Y1-Y2)*(X2-X3)
;  IF NEGATIVE THEN DRAW IT
*/
  float a = (v2.y - v3.y) * (v1.x - v2.x) - (v1.y - v2.y) * (v2.x - v3.x);  
  return a > 0.0;
}


void setup() {
  size(640, 512, P3D);
  frameRate(50);
}

void draw() {
  background(0);

  pushMatrix();
  
    translate(width/2, height/2, 0);
    rotateX(zAngle);
    rotateY(-zAngle);
    rotateZ(zAngle);
    zAngle+=0.01;
    
    for (int i=0; i<vertices.length; i++) {
      rotatedVerts[i] = new PVector();
      rotatedVerts[i].x = modelX(vertices[i].x, vertices[i].y, vertices[i].z);   //<>//
      rotatedVerts[i].y = modelY(vertices[i].x, vertices[i].y, vertices[i].z);  
      rotatedVerts[i].z = modelZ(vertices[i].x, vertices[i].y, vertices[i].z);  
    }

  popMatrix();
  
  pushMatrix();
    translate(0, 0, 0);
    rotateY((PI/180.0)*45.0);

  for (int i=0; i<polys.length; i++) {
    int[] poly = polys[i];
    
    if (isHidden(rotatedVerts[poly[0]], rotatedVerts[poly[1]], rotatedVerts[poly[2]]))
      continue;
  
    for (int j=0; j<poly.length-1; j++) {
      int p1 = poly[j];
      int p2 = poly[j+1];

      int x1 = (int)rotatedVerts[p1].x;
      int y1 = (int)rotatedVerts[p1].y;
      int z1 = (int)rotatedVerts[p1].z;
      int x2 = (int)rotatedVerts[p2].x;
      int y2 = (int)rotatedVerts[p2].y;
      int z2 = (int)rotatedVerts[p2].z;
    
      drawLine3(x1, y1, z1, x2, y2, z2, white);
      
      if (x1 > x2) {
        int t = x1;
        x1 = x2;
        x2 = t;
        t = y1;
        y1 = y2;
        y2 = t;
        t = z1;
        z1 = z2;
        z2 = t;
      }
      
      if (x1 > maxVLX || x2 < minVLX)
        continue;
      
      int dx = x2-x1;
      float ySlope = (float)(y2-y1) / (float)dx;
      float zSlope = (float)(z2-z1) / (float)dx;
      
      for (int il2=0; il2<verticalLines.length; il2++) {
        int xpos = verticalLines[il2];
      
        if (x1 > xpos || x2 < xpos)
          continue;
        
        float ldx = (xpos - (float)x1);
        int cutY = y1 + (int)(ySlope * ldx);
        int cutZ = z1 + (int)(zSlope * ldx);
        
        setPixel2(xpos, cutY, red);
    
      }
    }
  }

  for (int i=0; i<rotatedVerts.length; i++) {
    PVector v = rotatedVerts[i];
    setPixel2((int)v.x, (int)v.y, blue);
  }

  for (int il=0; il<verticalLines.length; il++) {
    int xpos = verticalLines[il];
    drawLine(xpos, 0, xpos, height-1, white);
  }
  
  popMatrix();
  /*for (int il=0; il<objectLines.length; il++) {
    PVector[] line = objectLines[il];
    
    drawLine(line[0].x, line[0].y, line[1].x, line[1].y, white);
    setPixel2((int)line[0].x, (int)line[0].y, blue);
    setPixel2((int)line[1].x, (int)line[1].y, blue);
    
    int x1 = (int)line[0].x;
    int y1 = (int)line[0].y;
    int x2 = (int)line[1].x;
    int y2 = (int)line[1].y;
    
    if (x1 > x2) {
      int t = x1;
      x1 = x2;
      x2 = t;
      t = y1;
      y1 = y2;
      y2 = t;
    }
    
    if (x1 > maxVLX || x2 < minVLX)
      continue;
    
    int dx = x2-x1;
    float ySlope = (float)(y2-y1) / (float)dx;
    
    for (int il2=0; il2<verticalLines.length; il2++) {
      PVector[] vLine = verticalLines[il2];
    
      if (x1 > vLine[0].x || x2 < vLine[0].x)
        continue;
      
      int cutY = y1 + (int)(ySlope * (vLine[0].x - (float)x1));
      
      setPixel2((int)vLine[0].x, cutY, red);  
  
    }
    
  }*/
}
