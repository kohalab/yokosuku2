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
  image(img.get(0, img.height/2, img.width/2, 1), x, y+(img.height/2),img.width/2,h-(img.height));
  image(img.get(img.width/2, img.height/2, img.width/2, 1), x-(img.width/2)+w, y+(img.height/2),img.width/2,h-(img.height));
  image(img.get(img.width/2, img.height/2, 1, 1), x+(img.width/2), y+(img.height/2),w-(img.width),h-(img.height));
  return (x < mousex && y < mousey && x+w > mousex && y+h > mousey);
}

int status_title = 0;
int status_edit = 1;
int status_play = 2;
