class yokoscript {
  /*
  rect[]   rects = new rect[16];
   String[] rects_name = new String[16];
   
   float[]  floats = new float[16];
   String[] floats_name = new String[16];
   
   String[] Strings = new String[16];
   String[] Strings_name = new String[16];
   */
  /*
   rect getrect(String name) {
   for (int i = 0; i < rects.length; i++) {
   if (rects_name[i] != null) {
   if (rects_name[i].equals(name)) {
   return rects[i];
   }
   }
   }
   return null;
   }
   
   float getfloat(String name) {
   for (int i = 0; i < rects.length; i++) {
   if (floats_name[i] != null) {
   if (floats_name[i].equals(name)) {
   return floats[i];
   }
   }
   }
   return 0.0/0.0;
   }
   
   String getString(String name) {
   for (int i = 0; i < rects.length; i++) {
   if (Strings_name[i] != null) {
   if (Strings_name[i].equals(name)) {
   return Strings[i];
   }
   }
   }
   return null;
   }
   
   void newrect(String name, rect in) {
   boolean e = false;
   for (int i = 0; i < rects.length; i++) {
   if (rects_name[i] != null) {
   if (rects_name[i].equals(name)) {
   rects[i] = in;
   e = true;
   }
   }
   }
   if (e == false) {
   int n = 0;
   for (int i = 0; i < rects.length; i++) {
   if (rects_name[i] == null) {
   n = i;
   break;
   }
   }
   rects[n] = in;
   rects_name[n] = name;
   }
   }
   
   void newfloat(String name, float in) {
   boolean e = false;
   for (int i = 0; i < rects.length; i++) {
   if (floats_name[i] != null) {
   if (floats_name[i].equals(name)) {
   floats[i] = in;
   e = true;
   }
   }
   }
   if (e == false) {
   int n = 0;
   for (int i = 0; i < rects.length; i++) {
   if (floats_name[i] == null) {
   n = i;
   break;
   }
   }
   floats[n] = in;
   floats_name[n] = name;
   }
   }
   
   void newString(String name, String in) {
   boolean e = false;
   for (int i = 0; i < rects.length; i++) {
   if (Strings_name[i] != null) {
   if (Strings_name[i].equals(name)) {
   Strings[i] = in;
   e = true;
   }
   }
   }
   if (e == false) {
   int n = 0;
   for (int i = 0; i < rects.length; i++) {
   if (Strings_name[i] == null) {
   n = i;
   break;
   }
   }
   Strings[n] = in;
   Strings_name[n] = name;
   }
   }
   
   */

  HashMap <String, rect>rects = new HashMap<String, rect>();
  HashMap <String, Float>floats = new HashMap<String, Float>();
  HashMap <String, String>Strings = new HashMap<String, String>();

  String[] str;

  yokoscript() {
  }
  yokoscript(String path) {
    str = loadStrings(path); //load
    if (str == null) { //error
      println("[yokoscript] Loading error. \""+path+"\" Has Not Found");
    }
  }
  //
  /*
  String[] getfunc(String[] ina, String name) {
   String[] in = {};
   for (int i = 0; i < ina.length; i++) {
   if (trim(ina[i]).length() > 1) {
   in = append(in, ina[i]);
   }
   }
   String[] out = {};
   //
   int stt = -1;
   int spc = 0;
   for (int i = 0; i < in.length; i++) {
   if (trim(in[i]).equals(name)) {
   //
   stt = i;
   A:
   for (int f = 0; f < in[i].length(); f++) {// space count
   if (in[i].charAt(f) != ' ') {
   spc = f;
   break A;
   }
   }
   //
   }
   }
   //println("あ", spc, stt);
   for (int i = 0; i < in.length; i++) {
   if (in[i].length() > spc) {
   in[i] = in[i].substring(spc, in[i].length());
   }
   }
   
   int ms = 1000;
   
   for (int i = 0; i < in.length; i++) {
   if (trim(in[i]).length() > 0) {
   if (in[i].charAt(0) == ' ') {
   int r = 0;
   B:
   for (int f = 0; f < in[i].length(); f++) {
   //
   r = f;
   if (in[i].charAt(f) != ' ') {
   r = f;
   break B;
   }
   //
   }
   //println("け"+r);
   if (ms > r) {
   ms = r;
   }
   }
   }
   }
   
   //println("も"+ms);
   
   for (int i = 0; i < in.length; i++) {
   if (in[i].charAt(0) == ' ') {
   if (in[i].length() > ms) {
   in[i] = in[i].substring(ms, in[i].length());
   }
   out = append(out, in[i]);
   }
   }
   //
   return out;
   }
   */
  /*
  String[] getinfunc(String[] in) {
   String[] out = {};
   for (int i = 0; i < in.length; i++) {
   if (in[i].charAt(0) != ' ') {
   out = append(out, in[i]);
   }
   }
   return out;
   }
   */

  void read() {
    if (str != null) {
      read(str);
    }
  }
  void read(String[] in) {
    for (int i = 0; i < in.length; i++) {
      in[i] = trim(in[i]);
      if (in[i].contains("#")) {
        in[i] = splitTokens(in[i], "#")[0];
      }
      in[i] = in[i].replaceAll("\"", "");
      //
      if (in[i].contains("<")) {
        //
        String[] a = splitTokens(in[i], "<");
        if (a.length >= 2) {
          //
          for (int f = 0; f < a.length; f++) {
            a[f] = trim(a[f]);
          }
          //newfloat
          char type = a[1].charAt(a[1].length()-1);
          String n = a[1].substring(0, a[1].length()-1);

          String name = a[0];

          if (type == 'r') {
            int x = 0, y = 0, w = 0, h = 0;
            boolean e = false;
            String ns = "";
            for (int f = 0; f < n.length(); f++) {
              if (n.charAt(f) == ')') {
                e = false;
              }
              if (e)ns += n.charAt(f);
              if (n.charAt(f) == '(') {
                e = true;
              }
            }
            String[] s = splitTokens(ns, ",");
            x = int(trim(s[0]));
            y = int(trim(s[1]));
            w = int(trim(s[2]));
            h = int(trim(s[3]));
            rects.put(name, new rect(x, y, w, h));
          }
          if (type == 'f') {
            floats.put(name, float(n));
          }
          //println(type);
          if (type == 's') {
            n = n.replaceAll("\\$s"," ");
            Strings.put(name, n);
          }
          //
        }
        //
      }
      //
    }
  }
  void dump() {
    for (HashMap.Entry<String, rect> entry : rects.entrySet()) {
      rect r = entry.getValue();
      println("[yokoscript] rect   Name:\""+entry.getKey()+"\""+" Num:"+r.x+","+r.y+","+r.w+","+r.h+";");
    }
    for (HashMap.Entry<String, Float> entry : floats.entrySet()) {
      float r = entry.getValue();
      println("[yokoscript] Float   Name:\""+entry.getKey()+"\""+" Num:"+r+";");
    }
    for (HashMap.Entry<String, String> entry : Strings.entrySet()) {
      String r = entry.getValue();
      println("[yokoscript] String   Name:\""+entry.getKey()+"\""+" Num:"+r+";");
    }
  }
}
