/*                      bg                      */

class bgdata {
  int[][] olddata;
  int[][] data;

  int width, height;

  /*
  
   ** data **
   
   31      24 23      16 15      8  7       0
   |       |  |       |  |       |  |       |
   [cccc cccc][bbbb aaVH][mmmm mmmm][mmmm mmmm]
   
   m = map [7:0]
   H = H-Flip ( 0 = LEFT  |  1 = RIGHT )
   V = V-Flip ( 0 = NOMAL |  1 = VFLIP ) (???)
   a = cfg0 [1:0]
   b = speed[3:0]
   c = cfg2 [7:0]
   
   */

  int get_map(int in) {
    return in&0xffff;
  }
  boolean get_h(int in) {
    return ((in>>16)&1) == 1;
  }
  boolean get_v(int in) {
    return ((in>>17)&1) == 1;
  }
  int get_a(int in) {
    return ((in>>18)&3);
  }
  int get_speed(int in) {
    return ((in>>20)&15);
  }
  int get_c(int in) {
    return ((in>>24)&0xff);
  }

  int set_map(int in, int a) {
    in &= 0xffff0000;
    in |= a;
    return in;
  }
  int set_h(int in, boolean a) {
    in &= ~(1<<16);
    if (a)in |= (1<<16);
    return in;
  }
  int set_v(int in, boolean a) {
    in &= ~(1<<17);
    if (a)in |= (1<<17);
    return in;
  }
  int set_a(int in, int a) {
    in &= ~((1<<18)|(1<<19));
    in |= a<<18;
    return in;
  }
  int set_speed(int in, int a) {
    in &= 0xff0fffff;
    in |= a<<20;
    return in;
  }
  int set_c(int in, int a) {
    in &= 0x00ffffff;
    in |= a<<24;
    return in;
  }

  void begin(int w, int h, int dw, int dh) {
    data = new int[w][h];
    olddata = new int[w][h];
    width  = w;
    height = h;
  }
  int[][] all_set(int[][] in, int s) {
    int[][] out = new int[in.length][in[0].length];
    for (int f = 0; f < in[0].length; f++) {
      for (int i = 0; i < in.length; i++) {
        out[i][f] = s;
      }
    }
    return out;
  }
}

/* ################################################ scroller ################################################ */

class scroller {
  float ix, iy;
  float x, y ;
  float xs, ys;
  int w, h;
  scroller() {
    xs = x = ix = 0;
    ys = y = iy = 0;
  }
  void wh(int a, int b) {
    w = a;
    h = b;
  }
  scroller(float a, float b) {
    x = ix = a;
    y = iy = b;
    xs = 0;
    ys = 0;
  }
  void proc() {
    x = ix;
    y = iy;
    if (x < 0)x = 0;
    if (y < 0)y = 0;
  }
  void go(float a, float b) {
    x = ix = a;
    y = iy = b;
    xs = 0;
    ys = 0;
  }
  void to(float a, float b) {
    ix = a;
    iy = b;
  }
}

/* ############################################### background ############################################### */

class background {
  bgdata data;
  scroller scroll;

  int DISP_WIDTH;
  int DISP_HEIGHT;

  int MAP_WIDTH;
  int MAP_HEIGHT;

  PGraphics g;

  background(int W, int H) {
    data = new bgdata();
    resize(W, H);
    scroll = new scroller(0, 0);
    scroll.wh(MAP_WIDTH, MAP_HEIGHT);
  }
  void resize(int w, int h) {
    DISP_WIDTH = w;
    DISP_HEIGHT = h;

    g = createGraphics( (DISP_WIDTH+2) *block_size, (DISP_HEIGHT+2) *block_size);
    g.beginDraw();
    g.background(ERROR_COLOR);
    g.endDraw();
  }
  void begin(int a, int b) {
    map.data.begin(a, b, DISP_WIDTH, DISP_HEIGHT);
    map.data.olddata = map.data.all_set(map.data.olddata, 0xffffffff);
  }
  int hazi = 0;
  void mapdraw() {
    g.beginDraw();
    int scrx = (int)scroll.x/block_size;
    int scry = (int)scroll.y/block_size;
    //println("scr",scrx,scry);
    for (int y = 0; y < DISP_HEIGHT+2; y++) {
      for (int x = 0; x < DISP_WIDTH+2; x++) {
        //
        int X = x+scrx;
        int Y = y+scry;
        if (X >= 0 && Y >= 0 && X < data.width && Y < data.height) {
          //dr
          if (data.data[X][Y] != data.olddata[x][y] || hazi != 0) {
            g.image(getblock(blocks, 0), x*block_size, y*block_size);
            int n = data.data[X][Y];
            g.image(getblock(blocks, n), x*block_size, y*block_size);
            data.olddata[x][y] = data.data[X][Y];
            //println(x,y);
          }
        } else {
          hazi = 2;
          g.image(getblock(blocks, 1), x*block_size, y*block_size);
        }
        //
      }
    }
    if (hazi > 0)hazi--;
    g.endDraw();
    //
  }
  PImage get() {
    return g.get(block_size+int(scroll.x%16), block_size+int(scroll.y%16), DISP_WIDTH *block_size, DISP_HEIGHT *block_size);
  }
  int getxmouse(int x) {
    int a = int((float)(x+scroll.x+16)/block_size);

    return a;
  }
  int getymouse(int y) {
    int a = int((float)(y+scroll.y+16)/block_size);

    return a;
  }
}

/*-------------------map-------------------*/

background map;

void map_begin() {
  println("[mapbegin] start");
  map = new background(WIDTH, HEIGHT);
  map.begin(int(systemscripts.floats.get("map_width")), int(systemscripts.floats.get("map_height")));
  //maptest();
  println("[mapbegin] end");
}

/*-------------------title-------------------*/

String logo_images_path;
int title_animations_frames;
PImage[] title_animations;

PImage mokubox;

void loading_images() {
  title_animations_frames = int(loadStrings(logo_images_path+"info")[0]);
  title_animations = new PImage[title_animations_frames];
  for (int i = 0; i < title_animations_frames; i++) {
    title_animations[i] = loadImage(logo_images_path+i+".png");
  }
  mokubox = loadImage("imgs/mokubox.png");
}

void title_start() {
  title_position_x_default = dwidth/2;
  title_position_y_default = dheight/4;
  title_position_x = title_position_x_default;
  title_position_y = title_position_y_default;
  title_r = 0;
  title_rn = 0;
  title_ro = 0;
}

color background_color = #bbeeff;

void simple_background() {
  background(background_color);
}

int title_position_x_default;
int title_position_y_default;

float title_position_x = 0;
float title_position_y = 0;
float title_r = 0;

float title_rn = 0;
float title_ro = 0;

int title_random;

int title_move_random = 8;

void title() {

  /* title random generater */
  if ((frameCount-1)%15 == 0) {
    int oldtitle_random = title_random;
    title_random = int(title_random+random(3))%title_animations_frames;

    for (;; ) {
      if (oldtitle_random == title_random) {
        title_random = int(title_random+random(3))%title_animations_frames;
      }
      if (oldtitle_random != title_random) {
        break;
      }
    }
  }
  /* owari */

  PImage nowimage = title_animations[ title_random ];

  int sx = (int)title_position_x-(nowimage.width/2);
  int sy = (int)title_position_y-(nowimage.height/2);

  PImage moto = get(title_position_x_default-(nowimage.width/2), title_position_y_default-(nowimage.height/2), nowimage.width, nowimage.height);

  noStroke();
  fill(0);
  rect(title_position_x_default-(nowimage.width/2), title_position_y_default-(nowimage.height/2), nowimage.width, nowimage.height);

  image(moto, sx, sy);
  title_ro = title_rn;
  title_rn = title_r;
  float sa = title_ro-title_rn;
  if (sa < 0)sa = -sa;
  //println(sa,int(sa/5.0)+1);
  for (int i = 0; i < int(sa); i += int(sa/30.0)+1) {
    tint(255, 255/(sa/i));
    ik(nowimage, sx, sy, aida(title_ro, title_rn, ((i/sa)/2)+0.5 ));
  }
  noTint();
  ik(nowimage, sx, sy, title_rn);
  int mv = 0;
  if (sx <= mousex && sy <= mousey && sx+nowimage.width > mousex && sy+nowimage.height > mousey) {
    if (mousePressed) {
      title_position_x += ((mousex-pmousex)*4/3)+int(noise(millis()/30.0, 13)*3-1.5);
      title_position_y += ((mousey-pmousey)*4/3)+int(noise(millis()/30.0, 47)*3-1.5);
      mv = 1;
      title_move_random = int(random(1, 2.2));
      float s = (title_r>=0?title_r:-title_r);
      s /= ((s/1000)+1);
      //println(s);
      title_r += ((s/1)+10)*( (dmouseX-sx) - (nowimage.width/2))/9000.0;
    }
    stroke(255);
    noFill();
    rect(sx, sy, nowimage.width, nowimage.height);
    Cursor(MOVE);
  }
  if (mv == 0) {
    float tx = (title_position_x_default-title_position_x);
    float ty = (title_position_y_default-title_position_y);
    tx *= title_move_random;
    ty *= title_move_random;
    if (tx > +1)tx = +1;
    if (ty > +1)ty = +1;
    if (tx < -1)tx = -1;
    if (ty < -1)ty = -1;

    title_position_x += ( (tx/1.15)* ( (sin(frameCount/60.0*TWO_PI)*2)+1 ) );
    title_position_y += ( (ty/1.15)* ( (cos(frameCount/60.0*TWO_PI)*2)+1 ) );

    float s = (title_r*0.95)-title_r;
    s /= ( (s >= 0?s:-s) /40.0)+1;
    title_r += s;
  }
}

/*-------------------start-------------------*/

String start_text;

boolean start_button() {
  textFont(system_font);
  //imgbox(mokubox,0,0,mousex,mousey);
  int x = (dwidth/2)-int((textWidth(start_text))/2);
  int y = (int)(dheight/1.3);
  int w = (int)textWidth(start_text);
  int h = 64;
  boolean a = imgbox(mokubox, x-32-16-4 +20, y-32-16, w+32+32, h);
  fill(#aa6622);
  if (a)fill(#ffffff);
  text(start_text, x, y-10);
  if (a&&mousePressed) {
    status = status_edit;
  }
  return a&&mousePressed;
}

/* ############################################### editor ############################################### */

void editor() {
  int x = map.getxmouse(mousex);
  int y = map.getymouse(mousey);
  if (mousePressed) {
    if (mouseButton == LEFT) {
      map.data.data[x][y] = 0x1e;
    }
    if (mouseButton == RIGHT) {
      map.data.data[x][y] = 0x00;
    }
  }
}
