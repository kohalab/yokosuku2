class mob {

  int num;

  int mob_num;

  point[] oldposs;
  point pos;

  point startpos = new point(0, 0, 0, 0);

  yokoscript script;

  boolean enable;

  boolean collision;

  boolean ai_enable;

  PImage nowplayer;
  int player_width = 0;
  int player_height = 0;
  int ai_type;

  float gravity = 0;

  int lr = -1;//-1or1
  float workxs = 0;
  float work = 0;

  int col_len = 4;
  int col_left;
  int col_right;
  int col_up;
  int col_down;

  int stopcount;

  float disp_x;
  float disp_y;

  int counter;

  PImage img;

  background map;

  HashMap <String, Float>control = new HashMap<String, Float>();

  int newasituiteru;
  int oldasituiteru;
  int asituiteru;
  int umatteru;
  int asituiteru_len = 5;

  boolean deaded;
  int deadcount;


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
  void startpos(int x, int y) {
    startpos.x = x;
    startpos.y = y;
  }
  void tp(float x, float y) {
    pos.x = x;
    pos.y = y;
    pos.xs = 0;
    pos.ys = 0;
  }
  void tp(float x, float y, float a, float b) {
    pos.x = x;
    pos.y = y;
    pos.xs = a;
    pos.ys = b;
  }
  void num(int a) {
    num = a;
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
    if (umatteru > 0) {
      control.put("down", 1f);
      //println(frameCount);
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
    oldposs = new point[3];
    for (int i = 0; i < oldposs.length; i++) {
      oldposs[i] = startpos;
    }
    pos = startpos.get();
  }

  int nowjump;
  int nowjumplen = 4;

  int dead_soto = 0;
  int dead_bloc = 1;
  int dead_end = 2;

  int jump_count;
  int down_count;

  int hc_count;
  int tk0_count;
  int tk1_count;

  int bsdr_count;

  int disp_kyori;
  float vol;

  float size;

  int frameCount;

  void proc() {
    //
    //println(num, pos.x, pos.y);
    pos.ys += 0.5*gravity;

    pos.x += pos.xs;
    pos.y += pos.ys;

    pos.xs /= script.floats.get("speed_div");
    workxs /= script.floats.get("speed_div");
    pos.ys /= script.floats.get("air_div");
    if (pos.ys > +15)pos.ys = +15;
    if (pos.ys < -15)pos.ys = -15;
    //
    if (ai_enable) {
      ai();
    }

    if (deaded == true) {
      frameCount = 0;
      if (script.floats.get("player") != 0) {
        if (control.get("jump") > 0.5) {
          respawn();
        }
        if (control.get("dash") > 0.5) {
          if (tk0_count == 0) {
            String t = "tk";
            int f = 0;
            //stop_sound(t+f);
            play_sound(t+f, (int)((float)num/(player_num-1)*dwidth), vol);
            tk0_count = 9999;
          }
        } else {
          tk0_count = 0;
        }
        if (control.get("down") > 0.5) {
          if (tk1_count == 0) {
            String t = "tk";
            int f = 1;
            //stop_sound(t+f);
            play_sound(t+f, (int)((float)num/(player_num-1)*dwidth), vol);
            tk1_count = 9999;
          }
        } else {
          tk1_count = 0;
        }
        if (control.get("left") > 0.5) {
          if (bsdr_count == 0) {
            String t = "bsdr";
            play_sound(t, (int)((float)num/(player_num-1)*dwidth), vol);
            bsdr_count = 9999;
          }
        } else {
          bsdr_count = 0;
        }
        if (control.get("right") > 0.5) {
          if (hc_count == 0) {
            String t = "hc";
            int f = int(random(0, soundscripts.floats.get(t+"_length")));
            //stop_sound(t+f);
            play_sound(t+f, (int)((float)num/(player_num-1)*dwidth), vol);
            hc_count = 9999;
          }
        } else {
          hc_count = 0;
        }
      }
      //
      deadcount++;
    }
    if (deaded == false) {

      float s = 1;
      s += control.get("dash")/2;
      s /= control.get("down")*4+1;
      //player

      oldasituiteru = newasituiteru;
      newasituiteru = asituiteru;

      float jump_div = 1;

      if (control.get("down") > 0.5) {
        if (down_count == 0)play_sound("syagamu", (int)disp_x, vol);
        down_count++;
        jump_div = 3;
      } else {
        down_count = 0;
      }

      if (control.get("jump")  > 0 && oldasituiteru > 0) {
        pos.ys = -script.floats.get("jump_level")*control.get("jump")/jump_div;
        pos.y -= 4;
        if (jump_count == 0 && script.floats.get("player") != 0) {
          stop_sound("minijmp");
          play_sound("minijmp", (int)disp_x, vol);
        }
        //println(jump_count);
        nowjump = nowjumplen+1;
        jump_count++;
      } else {
        jump_count = 0;
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
      frameCount++;
      if (script.floats.get("age") != null) {
        if (frameCount > script.floats.get("age"))dead(dead_end);
      }
      disp_kyori = int(disp_x-(dwidth/2));
      vol = -((disp_kyori > 0?disp_kyori:-disp_kyori)/70.0);
    }
    collision();
  }

  int ai_lr = +1;
  void ai() {
    //
    if (ai_type == 0) {
      if (ai_lr > 0) {
        control.put("right", 1f);
        control.put("left", 0f);
      } else {
        control.put("right", 0f);
        control.put("left", 1f);
      }

      if (col_right > 0 || col_left > 0) {
        control.put("jump", 1f);
      } else {
        control.put("jump", 0f);
      }

      /*
      
       */

      if (col_right > 0 && random(100) < 50)ai_lr = +1;
      if (col_left > 0 && random(100) < 50)ai_lr = -1;
      //
    }

    if (ai_type == 1) {
      if (ai_lr > 0) {
        control.put("right", 1f);
        control.put("left", 0f);
      } else {
        control.put("right", 0f);
        control.put("left", 1f);
      }

      if (col_right > 0 || col_left > 0) {
        control.put("jump", 1f);
      } else {
        control.put("jump", 0f);
      }
      //
    }
    if (ai_type == 100) {
    }
    if (ai_type == 88580) {
      String name = script.Strings.get("syokanname");
      float syokantime  = script.floats.get("syokantime");
      if (int(frameCount%syokantime) == 0) {
        mob c = new mob((int)pos.x, (int)pos.y);
        c.script(monsters.get(name));
        c.loads();
        c.pos.xs = lr*script.floats.get("syokanspeed");
        c.pos.ys = -script.floats.get("syokanheight");
        new_mobs(c);
      }
    }
    //
  }

  void collision() {
    if (deaded) {
      return;
    }
    if (collision) {
      /*
      if (script.floats.get("player") != 0) {
       if (disp_x < -32) {
       dead(dead_soto);
       }
       }
       if (script.floats.get("player") != 0) {
       if (disp_x > dwidth+32) {
       dead(dead_soto);
       }
       }
       if (script.floats.get("player") != 0) {
       if (disp_y < -32) {
       dead(dead_soto);
       }
       }
       if (script.floats.get("player") != 0) {
       if (disp_y > dheight+32) {
       dead(dead_soto);
       }
       }
       */
      //
      point old = pos.get();
      //
      int scrx = (int)(pos.x/block_size)-(map.DISP_HEIGHT/2);
      int scry = (int)(pos.y/block_size)-(map.DISP_HEIGHT/2);
      //


      int pw = player_width;
      int ph = player_height;

      int e = 0;
      for (int y = 0; y < map.DISP_HEIGHT+2; y++) {
        for (int x = 0; x < map.DISP_WIDTH+2; x++) {
          //
          int X = x+scrx;
          int Y = y+scry;
          if (X >= 0 && Y >= 0 && X < map.data.width && Y < map.data.height) {
            boolean deb = DEBUG&&false;
            //  -------- start -------- 
            int n = map.data.data[X][Y];
            int xp = X*block_size-(block_size/2);
            int yp = Y*block_size;

            boolean jimen_enable = true;

            if (
              col(xp, yp, block_size, block_size, 
              (int)old.x-4, (int)old.y-(ph/2), pw+8, ph+4, col_list[n]&&deb
              )) {
              if (dead_list[n]) {
                dead(dead_bloc);
              }
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
            //if (umatteru != 0) {
            //  //println("umatteru"+frameCount);
            //}
            //
            // up
            if (
              col(xp, yp, block_size, block_size, 
              (int)old.x+(pw/2/2), (int)old.y-(ph)+8, pw/2, 8, col_list[n]&&deb
              )) {
              if (col_list[n]) {
                pos.ys = 2;
                //pos.y = yp+(ph/2)+1;
                asituiteru = 0;
                col_up = col_len;
                //
                //
              }
            } else
              // jimen
              if (jimen_enable) {
                if (
                  col(xp, yp, block_size, block_size, 
                  (int)old.x+(pw/2/2), (int)old.y+(block_size)-4, pw/2, 4, col_list[n]&&deb
                  )) {
                  if (col_list[n] && nowjump == 0) {
                    pos.ys = -0;
                    pos.y = yp-block_size+1;
                    asituiteru = asituiteru_len;
                    col_down = col_len;
                    if (big_list[n]) {
                      if (frameCount%5 == 0)size += 0.125;
                    }
                    if (small_list[n]) {
                      if (frameCount%5 == 0)size -= 0.125;
                    }
                    if (normal_jump_list[n]) {
                      pos.ys = -15;
                      pos.y -= 16;
                      stop_sound("jmp");
                      play_sound("jmp", (int)disp_x, vol);
                    }
                    if (mover_left_list[n]) {
                      pos.xs -= 0.25;
                      //pos.x -= 2;
                    }
                    if (mover_right_list[n]) {
                      pos.xs += 0.25;
                      //pos.x += 2;
                    }
                    if (size > 3)size = 3;
                    if (size < -0.5)size = -0.5;
                    //
                  }
                }
              }
            //

            // ---- left ----
            if (
              col(xp, yp, block_size, block_size, 
              (int)old.x+(pw/2)+(4), (int)(old.y-(ph)+12) +4, pw/4, ph-8, col_list[n]&&deb
              )) {
              if (col_list[n] ) {
                pos.x -= 1;
                pos.xs = -1;
                col_left = col_len;
              }
            }
            // ---- right ----
            if (
              col(xp, yp, block_size, block_size, 
              (int)old.x, (int)(old.y-(ph)+12) +4, pw/4, ph-8, col_list[n]&&deb
              )) {
              if (col_list[n] ) {
                pos.x += 1;
                pos.xs = +1;
                col_right = col_len;
              }
            }
            /*
            if (
             col(xp, yp, block_size, block_size, 
             (int)old.x+(pw/3)+(pw/4)+2, (int)old.y-(ph)+(ph/4)+2, pw/4, ph-8-4, col_list[n]&&deb
             )) {
             if (col_list[n]) {
             pos.y -= 1;
             pos.xs = -1;
             //println("left");
             }
             }
             // ---- right ----
             if (
             col(xp, yp, block_size, block_size, 
             (int)old.x+(pw/4/3), (int)old.y-(ph)+(ph/4)+2, pw/4, ph-8-4, col_list[n]&&deb
             )) {
             if (col_list[n]) {
             pos.y += 1;
             pos.xs = +1;
             }
             }
             */


            //  --------  end  --------
            e = 1;
          }
          //
        }
      }

      for (int i = 0; i < mobs_max+player_num; i++) {
        mob now = null;
        if (i < mobs_max) {
          now = mobs[i];
        } else {
          now = players[i-mobs_max];
        }

        if (
          (now != null) &&
          !now.deaded &&
          (mob_num != i || i >= mobs_max) &&
          (num != (i-mobs_max) || i < mobs_max)
          ) {
          int xp = (int)now.pos.x;
          int yp = (int)now.pos.y;
          int bs_x = now.player_width;
          int bs_y = now.player_height;

          if (
            col(xp, yp, bs_x, bs_y, 
            (int)old.x+(pw/2/2), (int)old.y+(bs_y-4), pw/2, 4, false
            )) {
            //pos.ys += -1;
            pos.y = yp-bs_y+0.1-4;

            //pos.x += now.pos.xs/1.05;
            //pos.y += now.pos.ys/1.05;

            asituiteru = asituiteru_len;
            col_down = col_len;
          }
          if (
            col(xp, yp, bs_x, bs_y, 
            (int)old.x+(pw/2)+(4), (int)(old.y-(ph)+12) +4, pw/4, ph-8, false
            )) {
            //pos.x -= 1;
            pos.xs += -1.5;
            col_left = col_len;
          }
          // ---- right ----
          if (
            col(xp, yp, bs_x, bs_y, 
            (int)old.x, (int)(old.y-(ph)+12) +4, pw/4, ph-8, false
            )) {
            //pos.x += 1;
            pos.xs += +1.5;
            col_right = col_len;
          }
        }
        //
      }

      if (e == 0)dead(dead_soto);

      if (col_up > 0)col_up--;
      if (col_down > 0)col_down--;

      if (col_right > 0)col_right--;
      if (col_left > 0)col_left--;
      //
      //
      if (umatteru > 0)umatteru--;
      if (asituiteru > 0)asituiteru--;
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

    if (control.get("up") > 0.5)r = script.rects.get("img:uem");
    if (wk == 0 && (control.get("left") > 0 || control.get("right") > 0) )r = script.rects.get("img:wk0");
    if (wk == 1 && (control.get("left") > 0 || control.get("right") > 0) )r = script.rects.get("img:wk1");
    if (wk == 2 && (control.get("left") > 0 || control.get("right") > 0) )r = script.rects.get("img:wk0");
    if (wk == 3 && (control.get("left") > 0 || control.get("right") > 0) )r = script.rects.get("img:wk2");

    float axs = oldposs[(counter+0)%oldposs.length].xs;
    float bxs = oldposs[(counter+1)%oldposs.length].xs;
    if ((axs >= 0) != (bxs >= 0)) {
      stopcount = 8;
    }
    //if (stopcount > 0)r = script.rects.get("img:stp");
    //println(axs, bxs);
    //if(stopcount > 0)pos.x += ((counter%2)*2);

    player_width = (int)(nowplayer.width*(size+1));
    player_height = (int)(nowplayer.height*(size+1));
    if (control.get("down") > 0.5) {

      if (down_count >= 2) {
        r = script.rects.get("img:sya");
        if (script.floats.get("sya_anime") != null) {
          if (wk%2 == 1)r = script.rects.get("img:sya2");
        }
      }

      if (down_count > 0 && down_count < 2) {
        rect nr = script.rects.get("img:nml");
        rect sr = script.rects.get("img:sya");
        player_height = (int)aida(nr.h, sr.h, (down_count)/2f);
      }
    }

    nowplayer = flip(get(img, r), lr==1, deaded);
    if (map == null)return;
    disp_x = pos.x-(player_width/2)-map.scroll.x;
    disp_y = pos.y-player_height-map.scroll.y;
    image(nowplayer, disp_x, disp_y, player_width, player_height);
    noFill();
    stroke(255, 0, 0);
    //rect(disp_x, disp_y, player_width, player_height);
    if (stopcount > 0)stopcount--;
    if (deaded && script.floats.get("player") != 0) {
      rect g = script.rects.get("img:gan");
      if (disp_x >= -g.w && disp_y >= -g.h && disp_x < dwidth && disp_y < dheight) {
        rect j = script.rects.get("jump");
        image(get(blocks, j), num*(g.w*2), dheight-(g.h*2)-j.h);
        image(get(img, g), num*(g.w*2), dheight-(g.h*2), g.w*2, g.h*2);
      }
    }
  }

  void dead(int t) {
    collision = false;
    deaded = true;
    if (t != dead_end) {
      pos.ys = -6;
    }
    if (script.floats.get("nodeadsound") == null) {
      stop_sound("dead");
      play_sound("dead", (int)disp_x, vol);
    }
    if (script.floats.get("deadnull") != null) {
      pos.ys = 10000;
    }
  }

  void respawn() {
    println("respawn!");
    loads();
    float x = 0, y = map.data.height*block_size;
    float kazu = 0;
    for (int i = 0; i < players.length; i++) {
      if (!players[i].deaded) {
        x += players[i].pos.x;
        y = min(y, players[i].pos.y);
        kazu++;
      }
    }
    x /= kazu;

    pos.x = x;
    pos.y = y;
    deaded = false;
    //
  }
}
