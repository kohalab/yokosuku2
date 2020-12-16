int WIDTH;
int HEIGHT;

int SCALE;
boolean DEBUG;

int dwidth;
int dheight;

int menu_height = 48;

enum status_s {
  title, 
    edit, 
    play
}

status_s status;

debug_window debug_window;

int right_control_width = 0;

void settings() {
  status = status_s.title;
  //noiseSeed(34);
  sysbegin();
  noSmooth();
  dwidth = WIDTH*block_size;
  dheight = HEIGHT*block_size;
  size(dwidth*SCALE+right_control_width, dheight + menu_height *SCALE);
  noiseDetail(6);
}

float fr;

int player_num = 3;

int mobs_max;
mob[] mobs;

int yoyu_old;
int yoyu;

void setup() {
  loading_images();
  title_start();
  map_begin();
  frameRate(30);
  maptest();
  kaisiiti();
  soundbegin();
}

void playerreset() {
  for (int i = 0; i < player_num; i++) {
    int[] indexs = find_mobs_by_name(mobs, "player"+i);

    for (int c = 0; c < indexs.length; c++) {
      mobs[indexs[c]] = null;
    }
  }

  for (int i = 0; i < player_num; i++) {
    mob mob = new mob(0, 0);
    mob.script(characters.get("player"+i));
    mob.loads();
    mob.num(i);
    println("[playerreset] "+mob.name);
    if (i != 0)mob.deaded = true;
    new_mobs(mob);
  }
}

void maptest() {
  noiseSeed(int(random(-999999, 999999)));
  //noiseSeed(2);

  for (int f = 0; f < map.data.height; f++) {
    for (int i = 0; i < map.data.width; i++) {
      map.data.background_data[i][f] = 0;
    }
  }

  //kumos
  for (int n = 0; n < 10000; n++) {
    int x_len = 0;
    int y_len = 0;
    int index = 0;
    int x = 0;
    int y = 0;
    /*
    index = 0x0206;
     x_len = 3;
     y_len = 1;
     x = (int)random(0, map.data.width - x_len);
     y = (int)random(0, map.data.height - y_len);
     for (int y_len_counter = 0; y_len_counter < y_len; y_len_counter++) {
     for (int x_len_counter = 0; x_len_counter < x_len; x_len_counter++) {
     map.data.background_data[x_len_counter + x][y_len_counter + y] = 
     (index + x_len_counter) + (16 * y_len_counter);
     }
     }
     
     index = 0x0209;
     x_len = 2;
     y_len = 1;
     x = (int)random(0, map.data.width - x_len);
     y = (int)random(0, map.data.height - y_len);
     for (int y_len_counter = 0; y_len_counter < y_len; y_len_counter++) {
     for (int x_len_counter = 0; x_len_counter < x_len; x_len_counter++) {
     map.data.background_data[x_len_counter + x][y_len_counter + y] = 
     (index + x_len_counter) + (16 * y_len_counter);
     }
     }
     */
    index = 0x020c;
    x_len = 2;
    y_len = 1;
    x = (int)random(0, map.data.width - x_len);
    y = (int)random(0, map.data.height - y_len);
    for (int y_len_counter = 0; y_len_counter < y_len; y_len_counter++) {
      for (int x_len_counter = 0; x_len_counter < x_len; x_len_counter++) {
        map.data.background_data[x_len_counter + x][y_len_counter + y] = 
          (index + x_len_counter) + (16 * y_len_counter);
      }
    }

    index = 0x020E;
    x_len = 2;
    y_len = 1;
    x = (int)random(0, map.data.width - x_len);
    y = (int)random(0, map.data.height - y_len);
    for (int y_len_counter = 0; y_len_counter < y_len; y_len_counter++) {
      for (int x_len_counter = 0; x_len_counter < x_len; x_len_counter++) {
        map.data.background_data[x_len_counter + x][y_len_counter + y] = 
          (index + x_len_counter) + (16 * y_len_counter);
      }
    }
  }

  for (int f = 0; f < map.data.height; f++) {
    for (int i = 0; i < map.data.height; i++) {
      int x = i;
      int y = f;
      int s = 0x00;

      float e = noise(i/2.0/100.0, f/2.0/50.0);
      e -= 0.5;
      e /= 5;
      e += 0.5;


      e += 0.4;
      if (e < (float)f/map.data.height || f > map.data.height-4) {
        s = 0x20;
      } else {
        s = 0x00;
      }
      map.data.set(map.data.data, x, y, s, 0xffff);
      if (i > 10 && noise(i/10.0, f/10.0) < ((float)(map.data.height-f)/map.data.height)/2) {
        //map.data.set(x, y, 0);
      }
    }
  }

  /*
  for (int f = 0; f < map.data.height; f++) {
   for (int i = 0; i < map.data.width; i++) {
   int x = i;
   int y = f;
   int s = 0x00;
   
   if (f > map.data.height-4) {
   s = 0x20;
   } else {
   s = 0x00;
   }
   if (f == map.data.height-3) {
   if(random(100) < 6)s = 0x48;
   if(random(100) < 6)s = 0x49;
   }
   map.data.set(map.data.data, x, y, map.data.set_map(map.data.data[x][y], s));
   }
   }
   */
  for (int f = 0; f < map.data.height-1; f++) {
    for (int i = 10; i < map.data.width; i++) {
      //
      if (map.data.get(map.data.data, i, f+1) != 0 && map.data.get(map.data.data, i, f) == 0) {
        if (noise(i/2.0, f/2.0) < 0.2)map.data.set(map.data.data, i, f, 0x40);
        if (random(100) < 3)map.data.set(map.data.data, i, f, 0x48);
        if (random(100) < 3)map.data.set(map.data.data, i, f, 0x49);
        if (random(100) < 3)map.data.set(map.data.data, i, f, 0x58);
        if (noise(i/15.0, 1230.0) < 0.3)map.data.set(map.data.data, i, f, 0x59);
        if (noise(i/15.0, 1230.2) < 0.3)map.data.set(map.data.data, i, f, 0x5A);
        if (noise(i/4.0, 1230.4) < 0.3)map.data.set(map.data.data, i, f, 0x5B);
        if (noise(i/4.0, 1230.6) < 0.3)map.data.set(map.data.data, i, f, 0x5C);

        if (noise(i/4.0, 4513.6) < 0.35)map.data.set(map.data.data, i, f, 0x4A);
      }
      //
    }
  }
  //for(int d = 0;d < ){

  //}
  /*
  for (int f = 1; f < map.data.height; f++) {
   for (int i = 0; i < map.data.width; i++) {
   //
   if (map.data.get(map.data.data, i, f-1) != 0 && map.data.get(map.data.data, i, f) == 0x1e) {
   map.data.set(map.data.data, i, f, 0x1f);
   }
   //
   }
   }
   */
}

void kaisiiti() {
  playerreset();
  int x = 1;
  for (int f = 0; f < map.data.height; f++) {
    if (map.data.data[x][f] != 0) {
      //
      for (int i = 0; i < player_num; i++) {
        int[] indexs = find_mobs_by_name(mobs, "player"+i);
        for (int c = 0; c < indexs.length; c++) {
          int X = x*block_size;
          int Y = (f-1)*block_size;
          mobs[indexs[c]].tp(X, Y);
          mobs[indexs[c]].startpos(X, Y);
        }
      }
      break;
      //
    }
  }
}


void restart() {
  playerreset();
  kaisiiti();
}

int pmousex, pmousey, mousex, mousey;

void draw() {
  fr = frameRate;
  yoyu = millis()-yoyu_old;
  scroller();
  Cursor(ARROW);
  pmousex = pmouseX/SCALE;
  pmousey = pmouseY/SCALE;
  mousex = mouseX/SCALE;
  mousey = mouseY/SCALE;
  if (status == status.edit) {
    editor();
  }

  /*********  前処理 *********/
  //map.proc();
  /*********** 描画 ***********/
  simple_background();
  map.proc();
  map.mapdraw();
  image(map.get(), 0, 0);
  //************** test **************//
  g.strokeWeight(1);
  for (int i = 0; i < 100; i++) {
    g.stroke(255);
    float x = noise(i, 36, millis()/100000.0)*WIDTH*3*block_size;
    float y = noise(i, 61, millis()/100000.0)*HEIGHT*3*block_size;
    x -= WIDTH*block_size;
    y -= HEIGHT*block_size;

    if (x >= -block_size*4 && y >= -block_size*4 && x < (WIDTH*block_size)+(block_size*4) && y < HEIGHT*block_size+(block_size*4)) {

      x -= map.scroll.px*1.5;
      y -= map.scroll.py*1.5;

      x %= WIDTH*block_size;
      y %= HEIGHT*block_size;
      x += WIDTH*block_size;
      y += HEIGHT*block_size;
      x %= WIDTH*block_size;
      y %= HEIGHT*block_size;

      float tx = -((map.scroll.x-map.scroll.px)/4.0);
      float ty = -((map.scroll.y-map.scroll.py)/4.0);
      for (int f = 0; f < 3; f++) {
        tx *= abs(tx);
        ty *= abs(ty);
      }
      tx /= 30;
      ty /= 30;
      if (abs(tx) > 1 || abs(ty) > 1) {
        g.line(x, y, x+tx, y+ty);
      }
    }
    //
  }


  proc_menu();
  draw_menu();

  proc_characters();
  draw_characters();

  /*********** 前面 ***********/
  status();
  if (status == status.title) {
    title();
    start_button();
  } else {
    title_start();
  }


  /********** ﾃﾞﾊﾞｯｸﾞ **********/
  if (frameCount == 1 && DEBUG)debug_window = new debug_window();
  /**********  ｽｹｰﾗｰ  **********/
  image(get(0, 0, width/SCALE, height/SCALE), 0, 0, width, height);
  //println(map.data.get(0,0),col_list[0]);

  yoyu_old = millis();

  //if (DEBUG)devtext("TEST MAP "+nf(frameRate, 2, 4), 4, 4);
  //image(blocks.get(0,0,min(width,blocks.width),min(height,blocks.height)),0,0);
  /*
  if (DEBUG)devtext("mouse_wheel "+nf(mouse_wheel, 2, 1), 4, 4);
   */
  mouse_wheel = 0;
}
