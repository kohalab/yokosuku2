class background_data {
  int[][] tmp_data;
  int[][] old_data;
  int[][] data;

  int[][] old_overlay_data;
  int[][] overlay_data;

  int[][] old_background_data;
  int[][] background_data;

  int width, height;
  int dwidth, dheight;

  /*
  
   ** data **
   
   31       24 23       16 15        8 7         0
   |         | |         | |         | |         |
   [.... ...M] [.... VHBV] [IIII IIII] [IIII IIII]
   
   I = BlockIndex or MobIndex [15:0]
   V = Hidden (0=Visible 1=Hidden)
   B = Breaked (0=NonBreaked 1=Breaked)
   H = Horizontal Flip(0=nonFlip 1=Flip)
   V = Vertical Flip(0=nonFlip 1=Flip)
   M = IsMob (0=No 1=Yes)
   */

  final int index_mask = 0xffff;
  final int hidden_mask = (1 << 16);
  final int breaked_mask = (1 << 17);
  final int horizontal_flip_mask = (1 << 18);
  final int vertical_flip_mask = (1 << 19);
  final int is_mob_mask = (1 << 24);

  void begin(int w, int h, int dw, int dh) {
    old_data = new int[w][h];
    data = new int[w][h];

    old_overlay_data = new int[w][h];
    overlay_data = new int[w][h];

    tmp_data = new int[w][h];

    old_background_data = new int[w][h];
    background_data = new int[w][h];

    width  = w;
    height = h;
    dwidth = dw;
    dheight = dh;
  }

  byte[] save() {
    int l = 0;
    l += width*height*(32/8);//data
    byte[] out = new byte[l];
    int i = 0;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < height; x++) {
        out[i] = (byte)(data[x][y]>>24);
        i++;
        out[i] = (byte)(data[x][y]>>16);
        i++;
        out[i] = (byte)(data[x][y]>>8);
        i++;
        out[i] = (byte)(data[x][y]>>0);
        i++;
      }
    }
    return out;
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
  void set(int[][] in, int x, int y, int d, int mask) {
    if (x >= 0 && y >= 0 && x < in.length && y < in[0].length) {
      data[x][y] &= ~mask;
      data[x][y] |= d;
    }
  }
  void set(int[][] in, int x, int y, int d) {
    if (x >= 0 && y >= 0 && x < in.length && y < in[0].length) {
      data[x][y] = d;
    }
  }
  int get(int[][] in, int x, int y) {
    if (x >= 0 && y >= 0 && x < in.length && y < in[0].length) {
      return data[x][y];
    } else {
      return -1;
    }
  }
}
