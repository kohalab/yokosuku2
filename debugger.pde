class debug_window extends PApplet {

  public debug_window() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void start() {
  }

  public void settings() {
    size(map.g.width/2, 600);
  }
  public void setup() { 
    surface.setTitle("yokosuku2 debug");
  }

  public void draw() {
    background(#55bbff);
    image(map.g.get(), 0, 24, map.g.width/2, map.g.height/2);

    fill(255);
    textFont(system_font);
    text("frameRate:"+nf(fr, 2, 4), 0, 16);

    cursor(nowCursor);

    text("yoyu:"+nf(yoyu, 2), 0, 24+(map.g.height/2)+8);
    String str = "";
    str += mob_used+"/"+mobs_max+"\n";
    str += "\n\n\n\n";
    for (int i = 0; i < mobs_max; i++) {
      mob a = mobs[i];
      if (a == null) {
        str += "n";
      } else if (a.deaded) {
        str += ".";
      } else {
        str += "E";
      }
      if (i%32 == 31) {
        str += "\n";
      }
    }
    fill(255);
    text(str, 0, (map.g.height/2)+48);

    debuger();
  }
}
