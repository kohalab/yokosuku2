//yokoscript[] playerscripts = {null, null, null, null};

HashMap <String, yokoscript>characters = new HashMap<String, yokoscript>();

String[] monster_list;

void chabegin() {
  println("[chabegin] chabegin start");
  /*
  for (int i = 0; i < player_num; i++) {
   println("[chabegin] loading \""+player_config_paths[i]+"\"");
   playerscripts[i] = new yokoscript(player_config_paths[i]);
   playerscripts[i].read();
   }
   */
  //playerscripts[0].dump();
  monster_list = loadStrings("config/list");
  for (int i = 0; i < monster_list.length; i++) {
    String s = "config/"+monster_list[i]+".yks";
    println("[chabegin] loading \""+s+"\"");
    yokoscript a = new yokoscript(s);
    a.read();
    characters.put(monster_list[i], a);
  }
  println("[chabegin] chabegin end");
}


int mob_index;
void new_mobs(mob in) {
  int a = -1;
  for (int i = 0; i < mobs_max; i++) {
    //
    if (mobs[i] == null || (mobs[i].deaded && mobs[i].script.floats.get("immortal") == null)) {
      a = i;
      break;
    }
    //
  }
  if (a == -1) {
    mobs[mob_index] = in;
  } else {
    mobs[a] = in;
  }
  //println("new mob "+a);
}
