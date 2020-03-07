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

void settings() {
  //noiseSeed(34);
  sysbegin();
  noSmooth();
  dwidth = WIDTH*block_size;
  dheight = HEIGHT*block_size;
  size(dwidth*SCALE, dheight*SCALE);
  noiseDetail(6);
}

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
  /*
  for (int f = 0; f < map.data.height; f++) {
    for (int i = 0; i < map.data.height; i++) {
      int x = i;
      int y = f;
      int s = 0x00;

      float e = noise(i/100.0, f/50.0);
      e -= 0.5;
      e /= 5;
      e += 0.5;
      //e -= 0.53;
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
  */
  
  for (int f = 0; f < map.data.height; f++) {
    for (int i = 0; i < map.data.height; i++) {
      int x = i;
      int y = f;
      int s = 0x00;

      if (f > map.data.height-4) {
        s = 0x20;
      } else {
        s = 0x00;
      }
      map.data.set(map.data.data, x, y, map.data.set_map(map.data.data[x][y], s));

    }
  }
  for (int f = 0; f < map.data.height-1; f++) {
    for (int i = 0; i < map.data.width; i++) {
      //
      if (map.data.get(map.data.data, i, f+1) != 0 && map.data.get(map.data.data, i, f) == 0) {
        if (noise(i/2.0, f/2.0) < 0.2)map.data.set(map.data.data, i, f, 0x40);
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
  if(frameCount == 1 && DEBUG)debug_window = new debug_window();
  /**********  ｽｹｰﾗｰ  **********/
  image(get(0, 0, width/SCALE, height/SCALE), 0, 0, width, height);
  //println(map.data.get(0,0),col_list[0]);
  
  yoyu_old = millis();
}
