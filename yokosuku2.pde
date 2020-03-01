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

void settings() {
  //noiseSeed(34);
  sysbegin();
  noSmooth();
  dwidth = WIDTH*block_size;
  dheight = HEIGHT*block_size;
  size((dwidth+(DEBUG?150:0))*SCALE, dheight*SCALE);
}

int player_num = 3;

mob[] players = new mob[player_num];

void setup() {
  loading_images();
  title_start();
  map_begin();
  frameRate(30);
  for (int i = 0; i < player_num; i++) {
    players[i] = new mob(0, 0);
    players[i].script(playerscripts[i]);
    players[i].loads();
  }
  maptest();
}

void maptest() {
  noiseSeed(int(random(-999999,999999)));
  for (int f = 0; f < map.data.height; f++) {
    for (int i = 0; i < map.data.height; i++) {
      int x = i;
      int y = f;
      int s = 0;

      float e = noise(i/50.0, f/30.0);
      e -= 0.5;
      e /= 10;
      e += 0.5;
      if (e < (float)f/map.data.height || f > map.data.height-4) {
        s = 0x1e;
      } else {
        s = 0x00;
      }
      map.data.data[x][y] = map.data.set_map(map.data.data[x][y], s);
    }
  }
  for (int f = 1; f < map.data.height; f++) {
    for (int i = 0; i < map.data.height; i++) {
      //
      if (map.data.data[i][f-1] != 0 && map.data.data[i][f] == 0x1e) {
        map.data.data[i][f] = 0x1f;
      }
      //
    }
  }
  kaisiiti();
}

void kaisiiti() {
  int x = 1;
  for (int f = 0; f < map.data.height; f++) {
    if (map.data.data[x][f] != 0) {
      //
      for (int i = 0; i < player_num; i++) {
        players[i].tp(x*block_size, (f-1)*block_size);
      }
      break;
      //
    }
  }
}

int pmousex, pmousey, mousex, mousey;

void draw() {
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
  map.mapdraw();
  image(map.get(), 0, 0);
  float hekinx = 0;
  float hekiny = 0;
  for (int i = 0; i < player_num; i++) {
    players[i].map(map);
    players[i].proc();
    players[i].ctrl(keys);
    players[i].draw();
    hekinx += players[i].pos.x;
    hekiny += players[i].pos.y;
  }
  hekinx /= player_num;
  hekiny /= player_num;

  map.scroll.to(hekinx-(dwidth/2), hekiny-(dheight/2));
  map.scroll.proc();

  /*********** 前面 ***********/
  if (status == 0) {
    title();
    start_button();
  } else {
    title_start();
  }

  /********** ﾃﾞﾊﾞｯｸﾞ **********/
  if (DEBUG) {
    wakuimage(map.g.get(), dwidth+10, 0+10, map.g.width/4, map.g.height/4, color(0), 2);

    fill(255);
    textFont(system_font);
    text(nf(frameRate, 2, 4), 0, 16);

    cursor(nowCursor);
  }

  /**********  ｽｹｰﾗｰ  **********/
  image(get(0, 0, width/SCALE, height/SCALE), 0, 0, width, height);
}
