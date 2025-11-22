class LevelManager {
  int nivelActual = 0; 

  void cargarNivel(int nivel) {
    nivelActual = nivel;
    
    switch(nivel) {
      case 1: spawner = new Spawner(2000, 5); break; // Fácil
      case 2: spawner = new Spawner(1500, 8); break; // Medio
      case 3: spawner = new Spawner(800, 15); break; // Difícil
    }
    
    venado.reset();
    // Usamos la función global del Main
    iniciarTransicion(StateMachine.TUTORIAL);
  }
}
