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
