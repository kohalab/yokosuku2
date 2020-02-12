class mob {
  point pos;

  point startpos = new point(0, 0, 0, 0);

  mob() {
    setup();
  }
  mob(int x, int y) {
    startpos.x = x;
    startpos.y = y;
    setup();
  }

  void setup() {
    pos = startpos;
  }
}
