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

  private PImage get(PImage in, rect rect) {
    return in.get(rect.x, rect.y, rect.w, rect.h);
  }


  public void draw() {
    background(#d6f8ff);
    image(map.g.get(), 0, 24, map.g.width/2, map.g.height/2);

    fill(0);
    textFont(system_font, 16);
    text("frameRate:"+nf(fr, 2, 4), 0, 16);

    cursor(nowCursor);

    text("yoyu:"+nf(yoyu, 2), 0, 24+(map.g.height/2)+8);
    //String str = "";
    //str += mob_used+"/"+mobs_max+"\n";
    //str += "\n\n\n\n";

    int retu_w = (map.g.width/2) / 16;
    int w = 10;
    int h = 21;
    for (int i = 0; i < mobs_max; i++) {
      mob a = mobs[i];

      fill(240, 64);
      stroke(0, 64);
      rect((i%retu_w)*w, (i/retu_w)*h+((map.g.height/2)+48) + 32 - h, w, h);

      PImage nml_img = null;
      if (a == null) {
        //str += "n";
      } else if (a.deaded) {
        //str += ".";
      } else {
        //str += "E";
      }
      if (a != null) {
        rect nml_rect = a.script.rects.get("img:nml");
        PImage img = a.img;
        nml_img = get(img, nml_rect);
      }
      if (i%16 == 15) {
        //str += "\n";
      }
      if (nml_img != null) {
        if (a.deaded) {
          nml_img.filter(GRAY);
        }
        image(nml_img, (i%retu_w)*w, (i/retu_w)*h+((map.g.height/2)+48) + 32 - (nml_img.height*2/3), nml_img.width*2/3, nml_img.height*2/3);
      }
    }
    //fill(0);
    //text(str, 0, (map.g.height/2)+48);

    debuger();
  }
}
