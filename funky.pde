/********************   rect   ********************/

class rect {
  int x, y, w, h;
  rect() {
  }
  rect(int a, int b) {
    x = a;
    y = b;
  }
  rect(int a, int b, int c, int d) {
    x = a;
    y = b;
    w = c;
    h = d;
  }
  void x(int a) {
    x = a;
  }
  int x() {
    return x;
  }
  void y(int a) {
    y = a;
  }
  int y() {
    return y;
  }
  void w(int a) {
    w = a;
  }
  int w() {
    return w;
  }
  void h(int a) {
    h = a;
  }
  int h() {
    return h;
  }

  void xy(int a, int b) {
    x = a;
    y = b;
  }
  void wh(int a, int b) {
    w = a;
    h = b;
  }
}
/********************   point   ********************/

class point {
  float x, y, xs, ys;
  point() {
  }
  point(float a, float b) {
    x = a;
    y = b;
  }
  point(float a, float b, float c, float d) {
    x = a;
    y = b;
    xs = c;
    ys = d;
  }
  void x(float a) {
    x = a;
  }
  float x() {
    return x;
  }
  void y(float a) {
    y = a;
  }
  float y() {
    return y;
  }
  void xs(float a) {
    xs = a;
  }
  float xs() {
    return xs;
  }
  void ys(int a) {
    ys = a;
  }
  float ys() {
    return ys;
  }

  void xy(float a, float b) {
    x = a;
    y = b;
  }
  void xsys(float a, float b) {
    xs = a;
    ys = b;
  }
  point get() {
    point a = new point(this.x, this.y, this.xs, this.ys);
    return a;
  }
}

/********************   get   ********************/


PImage get(PImage in, rect rect) {
  return in.get(rect.x, rect.y, rect.w, rect.h);
}

/*

 int x = width/2;
 int y = height/2;
 float z = frameCount/100.0;
 
 int w = mouseX;
 int h = mouseY*2;
 for (int i = 0; i < 40; i++) {
 stroke(0);
 noStroke();
 fill(255);
 int xx = int((noise(i/2.0,551,z)-0.5)*w);
 
 int b = int( ((noise(i/2.0,134,z)* i*3)+20)*(w+h)/500 );
 ellipse(x+xx,y-((noise(i/2.0,219,z)-0.1)*(noise(i/2.0,661,z)*h)/ ( ((xx>=0?xx:-xx)/((w+1)/10.0))+1 )  ),b,b);
 }
 
 for (int i = 0; i < width; i += 3) {
 stroke(0);
 noStroke();
 fill(255);
 int b = int(noise(i/4.0,z)*200);
 ellipse(i,height,b,b);
 }
 */

void ik(PImage data, float x, float y, float k) {
  //x -= (data.width/2);
  //y -= (data.height/2);
  pushMatrix();
  translate(x + (data.width/2), y + (data.height/2));
  rotate(radians(k));
  image(data, 0-data.width/2, 0-data.height/2);  
  popMatrix();
  rotate(0);
}

float aida(float a, float b, float s) {
  return a + ((b-a)*s);
}

void wakuimage(PImage img, int x, int y, color wk, int ww) {
  wakuimage(img, x, y, img.width, img.height, wk, ww);
}

void wakuimage(PImage img, int x, int y, int w, int h, color wk, int ww) {
  noStroke();
  fill(wk);
  rect(x-ww, y-ww, w+(ww*2), h+(ww*2));
  image(img, x, y, w, h);
}

PImage getblock(PImage i, int a) {
  int w = i.width/block_size;
  return i.get((a%w)*block_size, (a/w)*block_size, block_size, block_size);
}

PImage flip(PImage in, boolean h, boolean v) {
  PImage out = createImage(in.width, in.height, ARGB);
  for (int y = 0; y < in.height; y++) {
    for (int x = 0; x < in.width; x++) {
      out.set(h?(in.width-1)-x:x, v?(in.height-1)-y:y, in.get(x, y));
    }
  }
  return out;
}

int nowCursor;
void Cursor(int n) {
  nowCursor = n;
}

boolean imgbox(PImage img, int x, int y, int w, int h) {
  image(img.get(0, 0, img.width/2, img.height/2), x, y);
  image(img.get(img.width/2, 0, img.width/2, img.height/2), x-(img.width/2)+w, y);
  image(img.get(0, img.height/2, img.width/2, img.height/2), x, y-(img.height/2)+h);
  image(img.get(img.width/2, img.height/2, img.width/2, img.height/2), x-(img.width/2)+w, y-(img.height/2)+h);
  image(img.get(img.width/2, 0, 1, img.height/2), x+(img.width/2), y, w-(img.width), img.height/2);
  image(img.get(img.width/2, img.height/2, 1, img.height/2), x+(img.width/2), y+h-(img.height/2), w-(img.width), img.height/2);
  image(img.get(0, img.height/2, img.width/2, 1), x, y+(img.height/2), img.width/2, h-(img.height));
  image(img.get(img.width/2, img.height/2, img.width/2, 1), x-(img.width/2)+w, y+(img.height/2), img.width/2, h-(img.height));
  image(img.get(img.width/2, img.height/2, 1, 1), x+(img.width/2), y+(img.height/2), w-(img.width), h-(img.height));
  return (x < mousex && y < mousey && x+w > mousex && y+h > mousey);
}


boolean col(int x1, int y1, int w1, int h1, int x2, int y2, int w2, int h2, boolean d) {
  boolean f = (x2 < (x1+w1)) && (x1 < (x2+w2)) && (y2 < (y1+h1)) && (y1 < (y2+h2));
  ;
  if (d && random(100) < 50) { 
    noFill();
    stroke(255, 0, 0);
    if (f)stroke(255, 127, 0);
    rect(x1-block_size/2, y1-block_size, w1, h1);

    stroke(0, 0, 255);
    if (f)stroke(0, 127, 255, 64);
    rect(x2-block_size/2, y2-block_size, w2, h2);
  }
  return f;
}

boolean col(int x1, int y1, int w1, int h1, int x2, int y2) {
  return (x1 <= x2 && x1+w1 > x2) && (y1 <= y2 && y1+h1 > y2);
}

boolean col(PImage col, int x1, int y1, int w1, int h1, int x2, int y2) {

  //if(( (x1 <= x2 && x1+w1 > x2) && (y1 <= y2 && y1+h1 > y2) ))println((x2-x1), (y2-y1));
  return getalpha(col, (x2-x1), (y2-y1)) && ( (x1 <= x2 && x1+w1 > x2) && (y1 <= y2 && y1+h1 > y2) );
}


boolean col(PImage col, int x1, int y1, int w1, int h1, int x2, int y2, int w2, int h2) {
  return getalpha(col, (x2-x1), (y2-y1)) && (x2 < (x1+w1)) && (x1 < (x2+w2)) && (y2 < (y1+h1)) && (y1 < (y2+h2));
}

int col_x(int x1, int y1, int w1, int h1, int x2, int y2) {
  return (x2-x1);
}
int col_y(int x1, int y1, int w1, int h1, int x2, int y2) {
  return (y2-y1);
}


boolean getalpha(PImage in, int x, int y) {
  if (x >= 0 && y >= 0 && x < in.width && y < in.height) {
    return (((in.get(x, y)>>24) &(1<<7)) != 0 );
  } else {
    return false;
  }
}

PImage alpha_mask(PImage rgb, PImage alpha) {
  rgb.loadPixels();
  alpha.loadPixels();
  for (int i = 0; i < min(rgb.pixels.length, alpha.pixels.length); i++) {
    rgb.pixels[i] = (rgb.pixels[i] & 0x00ffffff) | (alpha.pixels[i] & 0xff000000);
  }
  rgb.updatePixels();
  return rgb;
}

PGraphics scale_temp;

PImage scaling(PImage in, int w, int h) {
  if (w < 1)w = 1;
  if (h < 1)h = 1;
  if ((scale_temp == null) || (scale_temp.width != w || scale_temp.height != h)) {
    scale_temp = createGraphics(w, h);
  }
  scale_temp.beginDraw();
  scale_temp.clear();
  scale_temp.image(in, 0, 0, w, h);
  scale_temp.endDraw();
  return scale_temp.get();
}

boolean get_bit(int in, int bit) {
  return ( ((in >> bit) & 1) != 0 );
}

int set_bit(int in, int bit, boolean n) {
  in &= ~(1 << bit);
  if (n) {
    in |= 1 << bit;
  }
  return in;
}
