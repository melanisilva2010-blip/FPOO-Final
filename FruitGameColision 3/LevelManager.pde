class LevelManager {
  int nivelActual = 0; 
  void cargarNivel(int nivel) {
    nivelActual = nivel;
    switch(nivel) {
      case 1: 
        // NIVEL 1: 2500ms (2.5 segundos) -> Más lento que antes
        spawner = new Spawner(2500, 20); 
        break; 
        
      case 2: 
        // NIVEL 2: 1500ms (1.5 segundos) -> Rápido, pero no imposible
        spawner = new Spawner(1500, 30); 
        break; 
    }
    venado.reset();
    iniciarTransicion(StateMachine.TUTORIAL);
  }
}
