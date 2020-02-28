yokoscript[] playerscripts = {null, null, null, null};

String[] player_config_paths = {
  "config/player0.yks", 
  "config/player1.yks", 
  "config/player2.yks", 
  "config/player3.yks", 
};

HashMap <String, yokoscript>monsters = new HashMap<String, yokoscript>();

String[] monster_list;

void chabegin() {
  println("[chabegin] chabegin start");
  for (int i = 0; i < player_num; i++) {
    println("[chabegin] loading \""+player_config_paths[i]+"\"");
    playerscripts[i] = new yokoscript(player_config_paths[i]);
    playerscripts[0].read();
  }
  //playerscripts[0].dump();
  monster_list = loadStrings("config/list");
  for (int i = 0; i < monster_list.length; i++) {
    String s = "config/"+monster_list[i]+".yks";
    println("[chabegin] loading \""+s+"\"");
    yokoscript a = new yokoscript(s);
    a.read();
    monsters.put(monster_list[i], a);
  }
  println("[chabegin] chabegin end");
}
