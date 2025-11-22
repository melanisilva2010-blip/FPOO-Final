class LevelManager {
  int nivelActual = 0; 
  void cargarNivel(int nivel) {
    nivelActual = nivel;
    switch(nivel) {
      case 1: spawner = new Spawner(2000, 5); break; 
      case 2: spawner = new Spawner(1000, 10); break; 
    }
    venado.reset();
    iniciarTransicion(StateMachine.TUTORIAL);
  }
}
