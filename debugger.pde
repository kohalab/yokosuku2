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
    text("frameRate:"+nf(frameRate, 2, 4), 0, 16);

    cursor(nowCursor);
    
    text("yoyu:"+nf(yoyu, 2), 0, 24+(map.g.height/2)+8);

    debuger();
  }
}
