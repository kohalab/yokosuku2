class mob {
  point[] oldposs;
  point pos;

  point startpos = new point(0, 0, 0, 0);

  yokoscript script;

  boolean enable;

  boolean collision;

  boolean ai_enable;

  PImage nowplayer;
  int ai_type;

  float gravity = 0;

  int lr = 1;//-1or1
  float workxs = 0;
  float work = 0;

  int stopcount;
  
  float disp_x;
  float disp_y;

  int counter;

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
  void tp(float x, float y) {
    pos.x = x;
    pos.y = y;
    pos.xs = 0;
    pos.ys = 0;
  }
  void tp(float x, float y,float a,float b) {
    pos.x = x;
    pos.y = y;
    pos.xs = a;
    pos.ys = b;
  }
  void ctrlstart() {
    String[] keys = {"left", "right", "up", "down", "dash", 
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
            //println(k+":"+a.charAt(0));
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
    collision = int((float)script.floats.get("collision")) != 0;
    //script.dump();
    nowplayer = get(img, script.rects.get("img:nml"));
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
    oldposs = new point[3];
    for (int i = 0; i < oldposs.length; i++) {
      oldposs[i] = startpos;
    }
  }

  int nowjump;
  int nowjumplen = 4;

  void proc() {
    //
    pos.ys += 0.5*gravity;

    pos.x += pos.xs;
    pos.y += pos.ys;

    pos.xs /= script.floats.get("speed_div");
    workxs /= script.floats.get("speed_div");
    //pos.ys /= script.floats.get("air_div");
    if (pos.ys > +8)pos.ys = +8;
    if (pos.ys < -5)pos.ys = -5;
    //
    if (ai_enable) {
      ai();
    }

    float s = 1;
    s += control.get("dash")/2;
    s /= control.get("down")*4+1;
    //player
    if (control.get("jump")  > 0 && asituiteru > 0) {
      pos.ys = -script.floats.get("jump_level")*control.get("jump");
      pos.y -= 4;
      nowjump = nowjumplen+1;
    }
    if (control.get("left")  > 0) {
      pos.xs -= control.get("left")*script.floats.get("speed")*s;
      workxs -= control.get("left")*script.floats.get("speed")*s;
      lr = +1;
    }
    if (control.get("right") > 0) {
      pos.xs += control.get("right")*script.floats.get("speed")*s;
      workxs += control.get("right")*script.floats.get("speed")*s;
      lr = -1;
    }
    work += workxs;
    //work++;
    if (nowjump > 0)nowjump--;
    //
    //println(asituiteru);
    collision();
  }
  void ai() {
  }

  int asituiteru;
  int asituiteru_len = 5;

  void collision() {
    if (collision) {
      
      if(script.floats.get("player") != 0){
        if(disp_x < 32){
          float a = disp_x-32;
          //println(a);
          pos.x -= a;
        }
      }
      if(script.floats.get("player") != 0){
        if(disp_x > dwidth-32){
          float a = (dwidth-32)-disp_x;
          //println(a);
          pos.x += a;
        }
      }
      
      //
      point old = pos.get();
      //
      int scrx = (int)map.scroll.x/block_size;
      int scry = (int)map.scroll.y/block_size;
      //
      for (int y = 0; y < map.DISP_HEIGHT+2; y++) {
        for (int x = 0; x < map.DISP_WIDTH+2; x++) {
          //
          int X = x+scrx;
          int Y = y+scry;
          if (X >= 0 && Y >= 0 && X < map.data.width && Y < map.data.height) {
            //  -------- start -------- 
            int n = map.data.data[X][Y];
            int xp = X*block_size-(block_size/2);
            int yp = Y*block_size;

            int pw = nowplayer.width;
            int ph = nowplayer.height;

            boolean jimen_enable = true;

            boolean umatteru = false;
            if (
              col(xp, yp, block_size, block_size, 
              (int)old.x+(pw/2)-1, (int)old.y-(ph/4/2)-1, 2, 2, col_list[n]&&DEBUG
              )) {
              umatteru = true;
            }
            /*
            if (
             col(xp, yp, block_size, block_size, 
             (int)pos.x-(pw/2/2), (int)pos.y-ph, pw/2, ph/2
             )) {
             if (col_list[n] && nowjump == 0) {
             pos.ys = -4;
             pos.y = (int)pos.y+ph-(block_size)+4;
             //asituiteru = asituiteru_len;
             }
             }
             */
            if (!umatteru) {
              //
              // up
              if (
                col(xp, yp, block_size, block_size, 
                (int)old.x+(pw/2/2), (int)old.y-(ph/2), pw/2, block_size/1, col_list[n]&&DEBUG
                )) {
                if (col_list[n]) {
                  pos.ys = 4;
                  //pos.y = yp+(ph/2)+1;
                  asituiteru = 0;
                }
              } else
                // jimen
                if (jimen_enable) {
                  if (
                    col(xp, yp, block_size, block_size, 
                    (int)old.x+(pw/2/2), (int)old.y-(8)+(block_size), pw/2, 8, col_list[n]&&DEBUG
                    )) {
                    if (col_list[n] && nowjump == 0) {
                      pos.ys = -0;
                      pos.y = yp-block_size+1;
                      asituiteru = asituiteru_len;
                    }
                  }
                }
              //
            }


            //  --------  end  --------
          }
          //
        }
      }
      //
      if (asituiteru > 0)asituiteru--;
      //
    }
    oldposs[(counter+0)%oldposs.length] = pos.get();
    counter++;
  }
  int getblock(background map, int x, int y) {
    if (x >= 0 && y >= 0 && map.data.data.length > x && map.data.data[0].length > y) {
      return map.data.data[x][y];
    } else {
      return -1;
    }
  }

  void draw() {
    int wk = int((4.0+((work/10.0)%4.0))%4.0);
    //println(wk);
    rect r = script.rects.get("img:nml");
    if (wk == 0)r = script.rects.get("img:wk0");
    if (wk == 1)r = script.rects.get("img:wk1");
    if (wk == 2)r = script.rects.get("img:wk0");
    if (wk == 3)r = script.rects.get("img:wk2");

    float axs = oldposs[(counter+0)%oldposs.length].xs;
    float bxs = oldposs[(counter+1)%oldposs.length].xs;
    if ((axs >= 0) != (bxs >= 0)) {
      stopcount = 8;
    }
    //if (stopcount > 0)r = script.rects.get("img:stp");
    //println(axs, bxs);
    //if(stopcount > 0)pos.x += ((counter%2)*2);
    if (control.get("down") > 0.5)r = script.rects.get("img:sya");
    nowplayer = flip(get(img, r), lr==1, false);
    disp_x = pos.x-(r.w/2)-map.scroll.x;
    disp_y = pos.y-r.h-map.scroll.y;
    image(nowplayer, disp_x, disp_y);
    if (stopcount > 0)stopcount--;
  }
}
