class mob {
  point pos;

  point startpos = new point(0, 0, 0, 0);

  yokoscript script;

  boolean enable;

  boolean ai_enable;
  int ai_type;

  float gravity = 0;

  PImage img;

  background map;

  HashMap <String, Float>control = new HashMap<String, Float>();

  mob() {
    setup();
    ctrlstart();
  }
  mob(int x, int y) {
    startpos.x = x;
    startpos.y = y;
    setup();
    ctrlstart();
  }
  void ctrlstart() {
    String[] keys = {"left", "right", "up", "down", 
    /*********/      "jump"};
    for (int i = 0; i < keys.length; i++) {
      control.put(keys[i], 0f);
    }
  }
  void ctrl(boolean[] nowkey) {
    for (HashMap.Entry<String, Float> entry : control.entrySet()) {
      //Float r = entry.getValue();
      String k = entry.getKey();
      //
      String a = script.Strings.get("key:"+k);
      if (a != null) {
        control.put(k, 0f);
        for (int l = 0; l < a.length(); l++) {
          if (nowkey[a.charAt(l)&0xffff]) {
            control.put(k, 1f);
            //println(k);
            println(k+":"+a.charAt(0));
          }
        }
      } else {
        //println(k+" notfound");
      }
      //
    }
  }
  void en(boolean a) {
    enable = a;
  }
  void gravity(float a) {
    gravity = a;
  }
  void script(yokoscript in) {
    script = in;
  }
  void map(background in) {
    map = in;
  }
  void loads() {
    img = loadImage(script.Strings.get("img"));
    gravity = ((float)script.floats.get("gravity"));
    ai_enable = int((float)script.floats.get("ai:enable")) != 0;
    ai_type = int((float)script.floats.get("ai:type"));
    //script.dump();
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
    pos.ys += 0.4*gravity;

    pos.x += pos.xs;
    pos.y += pos.ys;

    pos.xs /= script.floats.get("speed_div");
    pos.ys /= script.floats.get("air_div");
    //
    if (ai_enable) {
      ai();
    } else {
      //player
      if (control.get("jump")  > 0)pos.ys = -script.floats.get("jump_level")*control.get("jump");
      if (control.get("left")  > 0)pos.xs -= control.get("left");
      if (control.get("right") > 0)pos.xs += control.get("right");
      //
    }
  }
  void ai() {
  }

  void draw() {
    rect r = script.rects.get("img:nml");
    image(get(img, r), pos.x-(r.w/2)-map.scroll.x, pos.y-r.h-map.scroll.y);
  }
}
