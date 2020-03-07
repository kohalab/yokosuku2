PFont system_font;

yokoscript systemscripts;

int block_size;

color ERROR_COLOR = color(255, 0, 0);

PImage blocks;

boolean[] col_list = new boolean[0x10000];
int[] freedom_list = new int[0];
boolean[] dead_list = new boolean[0x10000];

void sysbegin() {
  println("[sysbegin] sysbegin start");
  fstbegin();
  chabegin();
  println("[sysbegin] sysbegin end");
}

String system_config_path = "config/system.yks";

void fstbegin() {
  println("[fonbegin] fonbegin start");
  println("[fonbegin] loading \""+system_config_path+"\"");
  systemscripts = new yokoscript(system_config_path);
  systemscripts.read();
  //systemscripts.dump();
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

  print("[fonbegin] loading \""+fontpath+"\"");
  system_font = loadFont(fontpath);
  if (system_font == null)
    println(" but not found");
  else
    println(" ok");
  //
  println("[fonbegin] fonbegin end");

  String[] blockconfig = loadStrings("config/blockconfig.ncl");
  freedom_list = new int[0];
  for (int i = 0; i < col_list.length; i++) {
    col_list[i] = true;
    dead_list[i] = false;
  }
  int type = -1;
  for (int i = 0; i < blockconfig.length; i++) {
    //
    blockconfig[i] = blockconfig[i].replaceAll(" ", "");
    if (blockconfig[i].length() >= 3) {
      String m = splitTokens(blockconfig[i], ";")[0];
      //println(m);
      if (m.length() <= 4) {
        //
        switch(type) {
        case 0:
          col_list[unhex(m)] = false;
          break;
        case 1:
          freedom_list = append(freedom_list, unhex(m));
          break;
        case 2:
          dead_list[unhex(m)] = true;
        default:
          break;
        }
        //
      } else {
        //
        if (m.equals("[nocol]"))type = 0;
        if (m.equals("[freedom]"))type = 1;
        if (m.equals("[dead]"))type = 2;
        //
      }
      //
    }
    //
  }
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
