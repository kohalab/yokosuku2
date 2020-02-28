class mob {
  point pos;

  point startpos = new point(0, 0, 0, 0);

  yokoscript script;

  boolean enable;

  boolean gravity = false;

  PImage img;

  mob() {
    setup();
  }
  mob(int x, int y) {
    startpos.x = x;
    startpos.y = y;
    setup();
  }
  void en(boolean a) {
    enable = a;
  }
  void gravity(boolean a) {
    gravity = a;
  }
  void script(yokoscript in) {
    script = in;
  }
  void loads(){
    img = loadImage(script.Strings.get("img"));
    gravity = ((int)((float)script.floats.get("gravity"))) != 0;
  }
  void speed(float x, float y) {
    pos.xs = x;
    pos.ys = y;
  }
  void speedto(float x, float y) {
    pos.xs += x;
    pos.ys += y;
  }

  void setup() {
    pos = startpos;
  }

  void proc() {
    //
    if (gravity) {
      pos.ys += 0.1;
    }

    pos.x += pos.xs;
    pos.y += pos.ys;
    //
  }
  
  void draw(){
    rect r = script.rects.get("img:nml");
    image(get(img,r),pos.x-(r.w/2),pos.y-r.h);
  }
}
