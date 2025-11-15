// --- Variables globales ---
private Venado venado;
private PImage fondo;
private int estado;
private ArrayList<Fruta> frutas;
private int ultimaFruta = 0;
private int intervaloFruta = 3000; // base en ms
private int maxFrutas = 7;         // sube si quieres más densidad
private float deltaTime = 0;
private float lastTime = 0;

// gestor de aparición y puntaje
SpawnManager spawner;
int puntos = 0; // actualiza cuando recojas frutas

// Acumulador para spawn (evita "pausas" si el juego se atrasa)
float spawnAccumulator = 0.0f;

public void setup() {
  size(700, 600);
  venado = new Venado();
  imageMode(CORNER);
  fondo = loadImage("backgroundtest.jpg");
  estado = StateMachine.MENU;
  frutas = new ArrayList<Fruta>();
  lastTime = millis();

  // inicializar gestor de spawn
  spawner = new SpawnManager();

  // DEBUG opcional: simula distribuciones para ajustar pesos (quitar luego)
  // spawner.debugDistribution(0, 1000);
  // spawner.debugDistribution(200, 1000);
  // spawner.debugDistribution(1000, 1000);
}

void generarFruta() {
  try {
    Fruta nueva = spawner.spawn(puntos);
    frutas.add(nueva);
    println("Spawned: " + nueva.getClass().getSimpleName());
  } catch (Exception e) {
    println("Error al spawnear fruta: " + e);
    e.printStackTrace();
  }
}

public void draw() {
  float currentTime = millis();
  deltaTime = (currentTime - lastTime) / 1000.0; // segundos
  image(fondo, 0, 0, width, height);

  switch (estado) {
    case StateMachine.MENU: {
      textAlign(CENTER);
      fill(0);
      textSize(20);
      text("(pulsa ENTER para comenzar)", 150, 270);
      text("(pulsa c para ver los creditos)", 150, 400);
      break;
    }

    case StateMachine.TUTORIAL: {
      venado.dibujar();
      venado.mover();
      fill(0);
      textSize(20);
      text("Pulsa 'q' para pausar", 100, 15);

      // actualizar/dibujar frutas y eliminar las que salieron de pantalla
      for (int i = frutas.size() - 1; i >= 0; i--) {
        Fruta f = frutas.get(i);
        f.dibujar();
        f.caer(deltaTime);
        if (f.isOffScreen()) {
          frutas.remove(i);
        }
      }

      // intervalo dinámico en segundos (mínimo 0.15s)
      float spawnIntervalSec = max(0.15f, (intervaloFruta - puntos * 40) / 1000.0f);

      // acumular tiempo y generar frutas en bucle si hace falta
      spawnAccumulator += deltaTime;

      // Si estamos al tope de frutas, no permitimos que el acumulador crezca sin control
      if (frutas.size() >= maxFrutas) {
        spawnAccumulator = min(spawnAccumulator, spawnIntervalSec); // evita backlog
      }

      // generar mientras haya tiempo acumulado y espacio
      while (spawnAccumulator >= spawnIntervalSec && frutas.size() < maxFrutas) {
        generarFruta();
        spawnAccumulator -= spawnIntervalSec;
        ultimaFruta = millis();
      }

      break;
    }

    case StateMachine.PAUSA: {
      background(#B3DBDA);
      fill(255);
      textSize(40);
      text("Menu de pausa", width/2, 100);
      text("Pulsa ENTER para volver al juego", width/2, 200);
      text("Pulsa Z para volver al MENU", width/2, 300);
      break;
    }

    case StateMachine.CREDITOS: {
      background(#B3DBDA);
      textSize(20);
      text("Creditos", 50, 100);
      text("pulse z para volver al menu", 130, 50);
      break;
    }
  }

  lastTime = currentTime;
}

public void keyPressed() {
  if (keyCode == ENTER && estado == StateMachine.MENU) {
    // reiniciar partida
    puntos = 0;
    frutas.clear();
    ultimaFruta = millis();
    spawnAccumulator = 0.0f; // reset del acumulador
    estado = StateMachine.TUTORIAL;
  }
  if (keyCode == LEFT || key == 'a') venado.izq = true;
  if (keyCode == RIGHT || key == 'd') venado.der = true;

  if (key == 'q' && estado == StateMachine.TUTORIAL) {
    estado = StateMachine.PAUSA;
  }
  if (keyCode == ENTER && estado == StateMachine.PAUSA) {
    // al reanudar, reseteamos el acumulador para evitar burst
    spawnAccumulator = 0.0f;
    lastTime = millis();
    estado = StateMachine.TUTORIAL;
  }
  if (key == 'z' && estado == StateMachine.PAUSA) {
    estado = StateMachine.MENU;
  }
  if (key == 'c' && estado == StateMachine.MENU) {
    estado = StateMachine.CREDITOS;
  }
  if (key == 'z' && estado == StateMachine.CREDITOS) {
    estado = StateMachine.MENU;
  }
}

public void keyReleased() {
  if (keyCode == LEFT || key == 'a') venado.izq = false;
  if (keyCode == RIGHT || key == 'd') venado.der = false;
}
