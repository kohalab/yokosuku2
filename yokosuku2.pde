int WIDTH;
int HEIGHT;

int SCALE;
boolean DEBUG;

int dwidth;
int dheight;

int status;
/*
  0 = title
 1 = edit
 2 = play
 */

debug_window debug_window;

int right_control_width = 0;

void settings() {
  //noiseSeed(34);
  sysbegin();
  noSmooth();
  dwidth = WIDTH*block_size;
  dheight = HEIGHT*block_size;
  size(dwidth*SCALE+right_control_width, dheight*SCALE);
  noiseDetail(6);
}

float fr;

int player_num = 3;

int mobs_max;
mob[] players = new mob[player_num];
mob[] mobs;

int yoyu_old;
int yoyu;

void setup() {
  loading_images();
  title_start();
  map_begin();
  frameRate(30);
  playerreset();
  maptest();
  soundbegin();
}

void playerreset() {
  for (int i = 0; i < player_num; i++) {
    players[i] = new mob(0, 0);
    players[i].script(playerscripts[i]);
    players[i].loads();
    players[i].num(i);
    if (i != 0)players[i].deaded = true;
  }
}

void maptest() {
  noiseSeed(int(random(-999999, 999999)));
  //noiseSeed(2);

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
      map.data.set(map.data.data, x, y, map.data.set_map(map.data.data[x][y], s));
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
    for (int i = 0; i < map.data.width; i++) {
      //
      if (map.data.get(map.data.data, i, f+1) != 0 && map.data.get(map.data.data, i, f) == 0) {
        if (noise(i/2.0, f/2.0) < 0.2)map.data.set(map.data.data, i, f, 0x40);
        if (random(100) < 3)map.data.set(map.data.data, i, f, 0x48);
        if (random(100) < 3)map.data.set(map.data.data, i, f, 0x49);
        if (random(100) < 3)map.data.set(map.data.data, i, f, 0x58);
        if (noise(i/8.0, 4821) < 0.3)map.data.set(map.data.data, i, f, 0x59);
        if (noise(i/8.0, 1230) < 0.3)map.data.set(map.data.data, i, f, 0x5A);
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
  kaisiiti();
}

void kaisiiti() {
  int x = 1;
  for (int f = 0; f < map.data.height; f++) {
    if (map.data.data[x][f] != 0) {
      //
      for (int i = 0; i < player_num; i++) {
        int X = x*block_size;
        int Y = (f-1)*block_size;
        players[i].tp(X, Y);
        players[i].startpos(X, Y);
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
  if (status == 1) {
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
  g.strokeWeight(2);
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
        g.line(x, y, x-tx, y-ty);
      }
    }
    //
  }

  proc_characters();
  draw_characters();

  /*********** 前面 ***********/
  status();
  if (status == 0) {
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

  if(DEBUG)devtext("TEST MAP "+nf(frameRate, 2, 4), 4, 4);
}
