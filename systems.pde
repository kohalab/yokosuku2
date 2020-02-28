PFont system_font;

int block_size;

color ERROR_COLOR = color(255,0,0);

PImage blocks;

void sysbegin() {
  println("[sysbegin] sysbegin start");
  fstbegin();
  chabegin();
  println("[sysbegin] sysbegin end");
}

String system_config_path = "config/system.yks";
yokoscript systemscripts;

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
}

boolean[] keys = new boolean[0xffff];

void keyPressed(){
  if(key < 0xffff)keys[key] = true;
}
void keyReleased(){
  if(key < 0xffff)keys[key] = false;
}
