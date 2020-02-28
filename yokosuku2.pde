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
  sysbegin();
  noSmooth();
  dwidth = WIDTH*block_size;
  dheight = HEIGHT*block_size;
  size((dwidth+(DEBUG?150:0))*SCALE, dheight*SCALE);
}

int player_num = 1;

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
}

void maptest() {
  for (int f = 0; f < map.data.height; f++) {
    for (int i = 0; i < map.data.height; i++) {
      int x = i;
      int y = f;
      int s = round(noise(i/4.0, f/4.0)*1);
      if (s == 1) {
        s = 0x1e;
      } else {
        s = 0x00;
      }
      map.data.data[x][y] = map.data.set_map(map.data.data[x][y], s);
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


  /*********** 描画 ***********/
  simple_background();
  map.mapdraw();
  image(map.get(), 0, 0);
  for (int i = 0; i < player_num; i++) {
    players[i].draw();
    players[i].proc();
  }

  map.scroll.to(frameCount*10*((frameCount+1)/1000.0), frameCount*2);
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
