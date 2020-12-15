class scroller {
  float ix, iy;
  float px, py;
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
    px = x;
    py = y;
    x = (ix+(x*4))/5;
    y = (iy+(y*4))/5;
    if (x < 0)x = 0;
    if (y < 0)y = 0;
    //if (x < 0)x = 0;
    int my = h*block_size;
    if (y > my)y = my;
    int mx = w*block_size;
    if (x > mx)x = mx;
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
  background_data data;
  scroller scroll;

  int DISP_WIDTH;
  int DISP_HEIGHT;

  int MAP_WIDTH;
  int MAP_HEIGHT;

  PGraphics g;

  background(int W, int H) {
    data = new background_data();
    resize(W, H);
    scroll = new scroller(0, 0);
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
    map.data.old_data = map.data.all_set(map.data.old_data, 0xffffffff);
    MAP_WIDTH = a;
    MAP_HEIGHT = b;
    scroll.wh(a-DISP_WIDTH-2, b-DISP_HEIGHT-2);
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
          if (
            data.data[X][Y] != data.old_data[x][y] ||
            data.overlay_data[X][Y] != data.old_overlay_data[x][y] ||
            data.background_data[X][Y] != data.old_background_data[x][y] ||
            hazi != 0) {
            g.image(getblock(blocks, 0), x*block_size, y*block_size);
            int bn = (data.background_data[X][Y] & data.index_mask);
            g.image(getblock(blocks, bn), x*block_size, y*block_size);
            int n = (data.data[X][Y] & data.index_mask);
            if (n != 0) {
              g.image(getblock(blocks, n), x*block_size, y*block_size);
            }
            //println(x,y);
            int a = data.overlay_data[X][Y];
            if (a > 0)g.image(getblock(blocks, a), x*block_size, y*block_size);

            data.old_data[x][y] = data.data[X][Y];
            data.old_overlay_data[x][y] = data.overlay_data[X][Y];
            data.old_background_data[x][y] = data.background_data[X][Y];
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
  int bitcount(int a) {
    int o = 0;
    o += (a&(1<<0)) != 0?1:0;
    o += (a&(1<<1)) != 0?1:0;
    o += (a&(1<<2)) != 0?1:0;
    o += (a&(1<<3)) != 0?1:0;
    o += (a&(1<<4)) != 0?1:0;
    o += (a&(1<<5)) != 0?1:0;
    o += (a&(1<<6)) != 0?1:0;
    o += (a&(1<<7)) != 0?1:0;
    return o;
  }
  void proc() {
    for (int x = 0; x < data.width; x++) {
      data.data[x][0] = 0;
      data.data[x][data.height-1] = 0;
    }
    for (int y = 0; y < data.height; y++) {
      data.data[0][y] = 0;
      data.data[data.width-1][y] = 0;
    }
    //
    int scrx = (int)scroll.x/block_size;
    int scry = (int)scroll.y/block_size;
    for (int y = scry-2; y < scry+2+DISP_HEIGHT; y++) {
      for (int x = scrx-2; x < scrx+2+DISP_WIDTH; x++) {
        if (x >= 0 && y >= 0 && x < data.width && y < data.height) {
          data.overlay_data[x][y] = 0;
        }
      }
    }
    int[] freedom_list = blockconfig.get("freedom");
    for (int i = 0; i <  freedom_list.length; i++) {
      //
      int t1 = freedom_list[i];
      for (int y = scry-2; y < scry+2+DISP_HEIGHT; y++) {
        for (int x = scrx-2; x < scrx+2+DISP_WIDTH; x++) {
          //
          if ((t1/32) == (data.get(data.data, x, y)/32)) {
            int n = otonari_san(data.data, x, y, (data.get(data.data, x, y)));
            //println(n);
            int a = naname_san(data.data, x, y, (data.get(data.data, x, y)));
            if (n == 15) {
              if (a == 0) {
                a += 16;
                data.overlay_data[x][y] = 0;
              } else {
                a += 16;
                data.overlay_data[x][y] = (((data.get(data.data, x, y)/32)*32)+a);
              }
            }
            data.data[x][y] = (((data.get(data.data, x, y)/32)*32)+n);
            //
          }
          //
        }
      }
      //
    }
    //
  }
  int otonari_san(int[][] in, int x, int y, int k) {
    int a = data.get(in, x, y-1);
    int b = data.get(in, x+1, y);
    int c = data.get(in, x, y+1);
    int d = data.get(in, x-1, y);
    //
    int o = 0;
    o |= (((k/32) == (a/32))?1:0)<<0;
    o |= (((k/32) == (b/32))?1:0)<<1;
    o |= (((k/32) == (c/32))?1:0)<<2;
    o |= (((k/32) == (d/32))?1:0)<<3;
    //
    return o;
  }
  int naname_san(int[][] in, int x, int y, int k) {
    int a = data.get(in, x-1, y-1);
    int b = data.get(in, x+1, y-1);
    int c = data.get(in, x+1, y+1);
    int d = data.get(in, x-1, y+1);
    //
    int o = 0;
    o |= (((k/32) == (a/32))?0:1)<<0;
    o |= (((k/32) == (b/32))?0:1)<<1;
    o |= (((k/32) == (c/32))?0:1)<<2;
    o |= (((k/32) == (d/32))?0:1)<<3;
    //
    return o;
  }
  PImage get() {
    return g.get(block_size+int(scroll.x%block_size), block_size+int(scroll.y%block_size), DISP_WIDTH *block_size, DISP_HEIGHT *block_size);
  }
  int getxmouse(int x) {
    int a = int((float)(x+scroll.x+block_size)/block_size);

    return a;
  }
  int getymouse(int y) {
    int a = int((float)(y+scroll.y+block_size)/block_size);

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
  devfont = loadImage("imgs/devfont.png");
  title_animations_frames = int(loadStrings(logo_images_path+"info")[0]);
  title_animations = new PImage[title_animations_frames];
  for (int i = 0; i < title_animations_frames; i++) {
    title_animations[i] = loadImage(logo_images_path+i+".png");
  }
  mokubox = loadImage("imgs/mokubox.png");

  PImage icon = loadImage("imgs/icon_maru.png");
  surface.setIcon(icon);
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

int title_fit_x;
int title_fit_y;

void title_start() {
  title_position_x_default = dwidth/2;
  title_position_y_default = dheight/4;
  title_position_x = title_position_x_default;
  title_position_y = title_position_y_default;
  title_r = 0;
  title_rn = 0;
  title_ro = 0;
  title_fit_x = 2;
  title_fit_y = 2;
}


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

  if (round(title_position_x) == round(title_position_x_default)) {
    if (title_fit_x < 1) {
      play_sound("dogon", dwidth/2, -12);
      title_fit_x++;
    }
  } else {
    title_fit_x = 0;
  }
  if (round(title_position_y) == round(title_position_y_default)) {
    if (title_fit_y < 1) {
      play_sound("dogon", dwidth/2, -12);
      title_fit_y++;
    }
  } else {
    title_fit_y = 0;
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
    play_sound("click", dwidth/2, 0);
    status = status_s.edit;
  }
  return a&&mousePressed;
}

/* ############################################### editor ############################################### */

float menu_blocks_scroll = 0;
int menu_blocks_length = 256;
int editor_selected_block = 0;
void draw_menu() {
  noStroke();
  fill(240);
  rect(0, dheight, dwidth, (menu_height/8));
  fill(250);
  rect(0, dheight+(menu_height/8), dwidth, menu_height-(menu_height/8));
  stroke(250);
  line(0, dheight, dwidth, dheight);
  stroke(200);
  line(0, dheight+1, dwidth, dheight+1);
  int w = (block_size*3)*2/2;
  int h = menu_height;
  int n = dwidth/w;

  int scr = Math.round(menu_blocks_scroll*100);
  int x_count = 0;

  menu_blocks_length = 0;
  for (int i = 0; i < 256; i++) {
    if (!check_blockconfig("hidden", i)) {
      menu_blocks_length++;
    }
  }
  int[] exist_block_list = new int[menu_blocks_length];
  int block_index_counter = 0;
  for (int i = 0; i < 256; i++) {
    if (!check_blockconfig("hidden", i)) {
      exist_block_list[block_index_counter] = i;
      block_index_counter++;
    }
  }

  for (int i = 0; i < menu_blocks_length; i++) {
    int index = i+(scr/100);
    //index &= 0xff;
    if (index < menu_blocks_length) {
      PImage img = getblock(blocks, exist_block_list[index]);
      int x = (i*w)-((scr%100)*w/100);
      int y = dheight;

      int dx = x+(w/2)-(img.width*2/2);
      int dy = y+(h/2)-(img.height*2/2);
      int dw = img.width*2;
      int dh = img.height*2;

      if (-block_size < dx && dx < dwidth) {
        if (!check_blockconfig("hidden", exist_block_list[index])) {
          noStroke();
          fill(240);
          rect(dx, dy, dw, dh);
          if (exist_block_list[index] == editor_selected_block) {
            strokeWeight(2);
            stroke(0, 128);
            fill(255);
            rect(dx-4, dy-4, dw+8, dh+8);
            noStroke();
          }
          tint(0, 64);
          image(img, dx+3, dy+3, dw, dh);
          noTint();
          image(img, dx, dy, dw, dh);
          if (col(dx, dy, dw, dh, mouseX, mouseY)) {
            if (mousePressed) {
              editor_selected_block = exist_block_list[index];
            }
            noStroke();
            fill(255, 128);
            rect(dx, dy, dw, dh);
          }
        }
      }
      /*
    noFill();
       stroke(255, 0, 0);
       rect(dx, dy, dw, dh);
       */
    }
  }
  menu_blocks_length = block_index_counter;
  //println("menu_blocks_length:"+menu_blocks_length);
}

float menu_blocks_scroll_naibu;

void proc_menu() {
  int w = (block_size*3)*2/2;
  int n = dwidth/w;
  //mouse_wheel
  float smooth = 2;
  menu_blocks_scroll = (menu_blocks_scroll_naibu + (menu_blocks_scroll*smooth))/(smooth+1);

  menu_blocks_scroll_naibu += mouse_wheel;
  if (menu_blocks_scroll_naibu > (menu_blocks_length-1)-n+1)menu_blocks_scroll_naibu = (menu_blocks_length-1)-n+1;
  if (menu_blocks_scroll_naibu < 0)menu_blocks_scroll_naibu = 0;

  if (mouseY >= dheight) {
    int xs = pmouseX - mouseX;
    if (mousePressed) {
      menu_blocks_scroll_naibu += (float)xs / w;
    }
  }

  menu_blocks_scroll_naibu = (round(menu_blocks_scroll_naibu) + menu_blocks_scroll_naibu * 50) / 51;
}

void editor() {
  //setti
  if (mouseX >= 0 && mouseY >= 0 &&
    mouseX < dwidth && mouseY < dheight) {
    int x = map.getxmouse(mousex);
    int y = map.getymouse(mousey);
    if (mousePressed) {
      int n = editor_selected_block;
      int c = 0;
      if (mouseButton == LEFT) {
        if (map.data.get(map.data.data, x, y) != n) {
          map.data.set(map.data.data, x, y, n);
          c = 1;
        }
      }
      if (mouseButton == RIGHT) {
        n = 0;
        if (map.data.get(map.data.data, x, y) != n) {
          map.data.set(map.data.data, x, y, n);
          c = -1;
        }
      }
      //
      if (c != 0) {
        String t = "";
        if (c > 0)t = "do";
        if (c < 0)t = "po";
        int f = int(random(0, soundscripts.floats.get(t+"_length")));
        stop_sound(t+f);
        play_sound(t+f, mousex, 0);
      }
      //
    }
  }
}

int nokori = 0;


void scroller() {

  float hekinx = 0;
  float hekiny = 0;
  int smp = 0;
  nokori = 0;
  for (int i = 0; i < player_num; i++) {
    int index = find_mobs_by_name(mobs, "player"+i);
    if (index >= 0) {
      if (!mobs[index].deaded) {
        hekinx += mobs[index].pos.x;
        hekiny += mobs[index].pos.y;
        smp++;
        nokori++;
      } else {
        //println("player"+i+" : dead");
      }
    }
  }
  if (smp > 0) {
    hekinx /= smp;
    hekiny /= smp;
  }
  float x = hekinx-(dwidth/2);
  float y = hekiny-(dheight/1.25);
  if (dist(map.scroll.x, map.scroll.y, x, y) < dwidth) {
    map.scroll.to(x, y);
  } else {
    map.scroll.go(x, y);
  }
  map.scroll.proc();
}

void status() {
  if (nokori == 0) {
    rect img = systemscripts.rects.get("img:lost");
    int x = (dwidth/2);
    int y = (dheight/2);
    tint(0);
    image(get(blocks, img), x-(img.w/2), y-(img.h/2));
    noTint();
    fill(0);
    textFont(system_font);
    text(systemscripts.Strings.get("reset_text"), x-(textWidth(systemscripts.Strings.get("reset_text"))/2), y-16+(img.h*2));
  }
}

/* ############################################### debug ############################################### */

void debuger() {
}


/* ########################################## draw_characters ########################################## */

void proc_characters() {
  /*
  for (int i = 0; i < player_num; i++) {
   int index = find_mobs_by_name(mobs, "player"+i);
   mobs[index].map(map);
   mobs[index].proc();
   mobs[index].ctrl(keys);
   }
   */
  for (int i = 0; i < mobs_max; i++) {
    if (mobs[i] != null) {
      mobs[i].mob_num = i;
      mobs[i].map(map);
      mobs[i].proc();
      mobs[i].ctrl(keys);
      /*
      if (mobs[i].deadcount > 30 *15) {
       mobs[i] = null;
       }
       */
    }
  }
}

int mob_used;

void draw_characters() {
  int mb = 0;
  for (int i = 0; i < mobs_max; i++) {
    if (mobs[i] != null) {
      mobs[i].draw();
      if (mobs[i].deaded == false)mb++;
    }
  }
  mob_used = mb;
}

/* ############################################### screen shot ############################################### */

void screen_shot() {
  String path = systemscripts.Strings.get("screenshot_path");
  path += "screenshot - ";
  path += year()+"-";
  path += nf(month(), 2)+"-";
  path += nf(day(), 2)+" - ";
  path += nf(hour(), 2)+"-";
  path += nf(minute(), 2)+"-";
  path += nf(second(), 2)+" ";
  path += nf((millis()%100), 3);
  path += ".png";
  PImage get = get();
  noStroke();
  fill(255, 128);
  rect(0, 0, width, height);

  play_sound("flash"+int(random(0, soundscripts.floats.get("flash_length"))), dwidth/2, 0);

  get.save(path);
}
