yokoscript[] playerscripts = {null, null, null, null};

void chabegin() {
  playerscripts[0] = new yokoscript("config/player0.yks");
  playerscripts[0].read();
  playerscripts[0].dump();
}
