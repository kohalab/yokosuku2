import ddf.minim.*; 

int popnum = 5;
int pownum = 5;

HashMap <String, AudioSample>sounds = new HashMap<String, AudioSample>();

Minim minim;
AudioOutput out;
//AudioSample sound_pow;

yokoscript soundscripts;

void soundbegin() {
  println("[soundbegin] start");
  minim = new Minim(this);
  int buffer_size = 512;
  out = minim.getLineOut(Minim.STEREO, buffer_size, 48000, 16);
  String path = systemscripts.Strings.get("sound_path");
  String type = systemscripts.Strings.get("sound_type");
  soundscripts = new yokoscript(path+"cfg.yks");
  soundscripts.read();
  String[] list = loadStrings(path+"list");
  int master_gain = -9;
  for (int i = 0; i < list.length; i++) {
    AudioSample a = minim.loadSample(path+list[i]+type, buffer_size);
    a.setGain(master_gain);
    sounds.put(list[i], a);
  }
  println("[soundbegin] end");
}

void play_sound(String name, int x) {
  sounds.get(name).trigger();
  sounds.get(name).setPan((float)(x-(dwidth/2))/(dwidth/2));
}

void stop_sound(String name) {
  sounds.get(name).stop();
}
