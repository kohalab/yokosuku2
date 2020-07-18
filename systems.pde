PFont system_font;

yokoscript systemscripts;

int block_size;

color ERROR_COLOR = color(255, 0, 0);

PImage blocks;
/*
boolean[] col_list = new boolean[0x10000];
 int[] freedom_list = new int[0];
 boolean[] dead_list = new boolean[0x10000];
 
 boolean[] big_list = new boolean[0x10000];
 boolean[] small_list = new boolean[0x10000];
 
 boolean[] normal_jump_list = new boolean[0x10000];
 
 boolean[] mover_left_list = new boolean[0x10000];
 boolean[] mover_right_list = new boolean[0x10000];
 
 boolean[] jump_left_list = new boolean[0x10000];
 boolean[] jump_right_list = new boolean[0x10000];
 
 boolean[] score01_list = new boolean[0x10000];
 boolean[] score1_list = new boolean[0x10000];
 boolean[] score10_list = new boolean[0x10000];
 boolean[] score100_list = new boolean[0x10000];
 */
HashMap <String, int[]>blockconfig = new HashMap<String, int[]>();

PImage devfont;
PImage text_image;

void sysbegin() {
  println("[sysbegin] sysbegin start");
  fstbegin();
  chabegin();
  println("[sysbegin] sysbegin end");
}

String system_config_path = "config/system.yks";


PImage getdevchar(int index) {
  int textsize = 8;
  return devfont.get((index%16)*textsize, (index/16)*textsize, textsize, textsize);
}
void devtext(String str, int x, int y) {
  int textsize = 8;

  int nx = x;
  int ny = y;
  for (int i = 0; i < str.length(); i++) {
    char now = str.charAt(i);
    if (now == '\n') {
      ny += textsize;
      nx = x;
    } else {
      int p = now&0xff;
      image(devfont.get((p%16)*textsize, (p/16)*textsize, textsize, textsize), nx, ny);
      nx += textsize;
    }
  }
}

void fstbegin() {
  println("[fonbegin] fonbegin start");
  println("[fonbegin] loading \""+system_config_path+"\"");
  systemscripts = new yokoscript(system_config_path);
  systemscripts.read();
  //systemscripts.dump();

  devfont = loadImage("imgs/devfont.png");
  text_image = loadImage(systemscripts.Strings.get("text_img_path"));

  String fontpath = systemscripts.Strings.get("system_font");

  logo_images_path = systemscripts.Strings.get("logo_images");//scene

  WIDTH = int(systemscripts.floats.get("width"));//yokosuku2
  HEIGHT = int(systemscripts.floats.get("height"));//yokosuku2
  SCALE = int(systemscripts.floats.get("scale"));//yokosuku2
  block_size = int(systemscripts.floats.get("block_size"));//yokosuku2
  DEBUG = int(systemscripts.floats.get("debug"))!=0;//yokosuku2
  start_text = systemscripts.Strings.get("start_text");

  mobs_max = (int)(float)systemscripts.floats.get("mob_max");
  mobs = new mob[mobs_max];
  println(start_text);

  blocks = loadImage(systemscripts.Strings.get("blocks"));
  int blocks_len = (blocks.width/block_size)*(blocks.height/block_size);
  for (int i = 0; i < 256; i++) {
    PImage now = getblock(blocks, i);
    now.loadPixels();
    boolean e = true;
    for (int f = 0; f < now.pixels.length; f++) {
      if ((now.pixels[f]>>24) != 0)e = false;
    }
    if (e) {
      int x = (i%16)*block_size;
      int y = (i/16)*block_size;
      char[] str = new char[4];
      String index_hex = hex(i, 2);
      //012
      //0FF
      str[0] = (char)(index_hex.charAt(0)+128);
      str[1] = (char)(index_hex.charAt(1)+128);
      str[2] = (char)('?'+128);
      str[3] = (char)('?'+128);
      //blocks.set(x, y, getblock(blocks, 0x100));
      blocks.set(x+(block_size/2*0), y+(block_size/2*0), getdevchar(str[0]));
      blocks.set(x+(block_size/2*1), y+(block_size/2*0), getdevchar(str[1]));
      blocks.set(x+(block_size/2*0), y+(block_size/2*1), getdevchar(str[2]));
      blocks.set(x+(block_size/2*1), y+(block_size/2*1), getdevchar(str[3]));
    }
  }

  print("[fonbegin] loading \""+fontpath+"\"");
  system_font = loadFont(fontpath);
  if (system_font == null)
    println(" but not found");
  else
    println(" ok");
  //
  println("[fonbegin] fonbegin end");

  String[] blockconfig_in = loadStrings("config/blockconfig.ncl");

  String now_label = "";

  for (int i = 0; i < blockconfig_in.length; i++) {
    //
    blockconfig_in[i] = blockconfig_in[i].replaceAll(" ", "");
    //println(i+":"+type);
    if (blockconfig_in[i].length() >= 3) {
      String m = splitTokens(blockconfig_in[i], ";")[0];
      //println(m);
      if (m.length() == 4) {
        int[] old = blockconfig.get(now_label);
        int len = 0;
        if (old != null) {
          len = old.length;
        }
        int[] newone = new int[len+1];
        for (int c = 0; c < len; c++) {
          newone[c] = old[c];
        }
        int id = unhex(m);
        newone[len] = id;
        blockconfig.put(now_label, newone);
        println("blockconfig "+now_label+" += "+id);
      } else {
        //
        now_label = m;
        now_label = now_label.replaceAll("\\[", "");
        now_label = now_label.replaceAll("\\]", "");
        //
      }
      //
    }
    //
  }
}

boolean check_blockconfig(String name, int id) {
  int[] list = blockconfig.get(name);
  boolean e = false;//なかったとき
  if(name.indexOf("!") != -1){
    e = true;
  }
  if (list != null) {
    for (int i = 0; i < list.length; i++) {
      if (list[i] == id) {
        return !e;//見つかった！！
      }
    }
  }else{
    //println("\""+name+"\"は見つかりません");
  }
  return e;
}


boolean[] keys = new boolean[0xffff];

void keyPressed() {
  if (key < 0xffff)keys[key] = true;
  if (key == 'R')maptest();
  if (nokori == 0) {
    if (key == ' ') {
      restart();
    }
  }
  if (key == 'n') {
    for (int i = 0; i < monster_list.length; i++) {
      mob c = new mob((int)players[0].pos.x, (int)players[0].pos.y);
      c.script(monsters.get(monster_list[i]));
      c.loads();
      new_mobs(c);
      println("new "+monster_list[i]);
    }
    //
  }
  if (key == systemscripts.Strings.get("screenshot_key").charAt(0)) {
    screen_shot();
  }
}
void keyReleased() {
  if (key < 0xffff)keys[key] = false;
}
