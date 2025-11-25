/**Biblioteca que permite el uso de GIF*/
import gifAnimation.* ;

private Venado venado;
private PImage fondo, tuto;
private int estado;
private float deltaTime;
private float lastTime;
private Spawner spawner;
private Escena escena;
private SoundManager soundManager;

// Variables de UI y Niveles
private PImage imgGameOver;
private PImage fondoNiveles;
private LevelManager levelManager;

// Fuentes
private PFont fuentePixel;
private PFont fuenteNormal;

// Variables Fade
float fadeAlpha = 0;
boolean fading = false;
boolean fadeToBlack = true;
int estadoSiguiente = -1;
int destinoDespuesDeWin = -1;
int timerMuerte = 0;

// --- IMÁGENES DE FRUTAS (Declaramos aquí, cargamos abajo) ---
PImage imgBanana, imgFrutilla, imgManzana, imgNaranja, imgSandia, imgPiedra;

public void setup() {
  size(800, 600);

  // --- 2. CARGA DE IMÁGENES (Dentro del setup) ---
  try {
    fondo = loadImage("backgroundMenu.jpg");
    tuto = loadImage("arbolBack.png");
    fondoNiveles = loadImage("niveles.jpg");


    // CARGAMOS LAS FRUTAS AQUÍ
    imgBanana = loadImage("Banana.png");
    imgFrutilla = loadImage("Frutilla.png");
    imgManzana = loadImage("Manzana.png");
    imgNaranja = loadImage("Naranja.png");
    imgSandia = loadImage("Sandia.png");
    imgPiedra = loadImage("Piedra.png");

    // Fuentes
    fuentePixel = createFont("PixelGameFont.ttf", 60);
    fuenteNormal = createFont("SansSerif", 20);
  }
  catch (Exception e) {
    println("Error cargando recursos: " + e.getMessage());
  }

  // --- 3. INICIALIZACIÓN DE OBJETOS ---
  venado = new Venado(this);
  escena = new Escena();
  soundManager = new SoundManager(this);
  
  // Spawner inicial (Tutorial)
  spawner = new Spawner(3000, 10);

  levelManager = new LevelManager();

  imageMode(CORNER);
  estado = StateMachine.MENU;
  lastTime = millis();
}

public void draw() {
  float currentTime = millis();
  deltaTime = (currentTime - lastTime) / 1000.0;
  lastTime = currentTime;

  background(0);

  // Configuración por defecto
  imageMode(CORNER);
  textFont(fuenteNormal);
  textAlign(LEFT);

  switch(estado) {

  case StateMachine.MENU:
    {
      soundManager.playMenu();
      if (fondo != null) image(fondo, 0, 0, width, height);
      textAlign(CENTER);
      fill(0);
      textSize(20);
      break;
    }

  case StateMachine.CINEMATICA:
    {
      soundManager.playGame();
      escena.dibujar();
      break;
    }

  case StateMachine.TUTORIAL:
    {
      soundManager.playGame();
      imageMode(CORNER);
      if (tuto != null) image(tuto, 0, 0, width, height);

      venado.dibujar();
      venado.mover();

      fill(0);
      textSize(20);
      textAlign(LEFT);
      text("Pulsa 'q' para pausar", 100, 15);

      spawner.actualizar(deltaTime, venado);

      // --- VICTORIA ---
      if (levelManager.nivelActual == 0 && venado.getPuntaje() >= 150) {
        prepararVictoria(StateMachine.MENU_NIVELES);
      } else if (levelManager.nivelActual == 1 && venado.getPuntaje() >= 300) {
        prepararVictoria(StateMachine.MENU_NIVELES);
      } else if (levelManager.nivelActual == 2 && venado.getPuntaje() >= 500) {
        prepararVictoria(StateMachine.MENU);
      }

      // --- DERROTA ---
      if (venado.getVida() <= 0) {
        estado = StateMachine.MURIENDO;
        timerMuerte = millis();
      }
      break;
    }

    // --- ESTADO INTERMEDIO: MUERTE ---
  case StateMachine.MURIENDO:
    {
      imageMode(CORNER);
      if (tuto != null) image(tuto, 0, 0, width, height);

      spawner.dibujarCongelado();
      venado.dibujar();

      if (millis() - timerMuerte > 4000) {
        estado = StateMachine.GAMEOVER;
      }
      break;
    }

  case StateMachine.MENU_NIVELES:
    {
      soundManager.backMenu.isPlaying();
      if (fondoNiveles != null) image(fondoNiveles, 0, 0, width, height);
      else background(50, 0, 100);
      break;
    }

  case StateMachine.PAUSA:
    {
      soundManager.backMenu.isPlaying();
      background(#B3DBDA);
      fill(255);
      textAlign(CENTER);
      textSize(40);
      text("Menu de pausa", width/2, 100);
      text("Pulsa ENTER para volver al juego", width/2, 200);
      text("Pulsa Z para volver al MENU", width/2, 300);
      break;
    }

  case StateMachine.CREDITOS:
    {
      soundManager.backMenu.isPlaying();
      background(#B3DBDA);
      textSize(20);
      textAlign(LEFT);
      text("Creditos", 50, 100);
      text("pulse z para volver al menu", 130, 50);
      break;
    }

    // --- GAME OVER ---
  case StateMachine.GAMEOVER:
    {
      if (tuto != null) image(tuto, 0, 0, width, height);
      spawner.dibujarCongelado();
      venado.dibujar();

      rectMode(CORNER);
      noStroke();
      fill(0, 150);
      rect(0, 0, width, height);

      textFont(fuentePixel);
      textAlign(CENTER);

      fill(255, 0, 0);
      textSize(80);
      text("GAME OVER", width/2, height/2);

      textSize(30);
      fill(255);
      if (frameCount % 60 < 30) {
        text("PRESS 'R' TO RESTART", width/2, height/2 + 60);
      }
      break;
    }

    // --- YOU WIN ---
  case StateMachine.YOU_WIN:
    {
      if (tuto != null) image(tuto, 0, 0, width, height);
      venado.dibujar();
      spawner.dibujarCongelado();

      rectMode(CORNER);
      noStroke();
      fill(0, 150);
      rect(0, 0, width, height);

      textFont(fuentePixel);
      textAlign(CENTER);

      fill(255, 215, 0);
      textSize(80);
      text("YOU WIN!", width/2, height/2);

      textSize(30);
      fill(255);
      if (frameCount % 40 < 20) {
        text("PRESS ENTER", width/2, height/2 + 60);
      }
      break;
    }
  }

  // --- FADE ---
  if (fading) {
    rectMode(CORNER);
    noStroke();
    fill(0, fadeAlpha);
    rect(0, 0, width, height);

    if (fadeToBlack) {
      fadeAlpha += 15;
      if (fadeAlpha >= 255) {
        fadeAlpha = 255;
        estado = estadoSiguiente;
        fadeToBlack = false;
      }
    } else {
      fadeAlpha -= 15;
      if (fadeAlpha <= 0) {
        fadeAlpha = 0;
        fading = false;
      }
    }
  }
}

void prepararVictoria(int siguienteDestino) {
  if (estado != StateMachine.YOU_WIN && !fading) {
    destinoDespuesDeWin = siguienteDestino;
    estado = StateMachine.YOU_WIN;
  }
}

void iniciarTransicion(int proximo) {
  fading = true;
  fadeToBlack = true;
  estadoSiguiente = proximo;
  fadeAlpha = 0;
}

// --- CONTROLES ---

public void keyPressed() {
  if (keyCode == LEFT || key == 'a') venado.izq = true;
  if (keyCode == RIGHT || key == 'd') venado.der = true;

  if (estado == StateMachine.MENU) {
    if (keyCode == ENTER) estado = StateMachine.CINEMATICA;
    if (key == 'c') estado = StateMachine.CREDITOS;
  } else if (estado == StateMachine.TUTORIAL) {
    if (key == 'q') estado = StateMachine.PAUSA;
  } else if (estado == StateMachine.PAUSA) {
    if (keyCode == ENTER) estado = StateMachine.TUTORIAL;
    if (key == 'z') estado = StateMachine.MENU;
  } else if (estado == StateMachine.CREDITOS) {
    if (key == 'z') estado = StateMachine.MENU;
  } else if (estado == StateMachine.MENU_NIVELES) {
    if (key == '1') levelManager.cargarNivel(1);
    if (key == '2') levelManager.cargarNivel(2);
  } else if (estado == StateMachine.YOU_WIN) {
    if (keyCode == ENTER) {
      iniciarTransicion(destinoDespuesDeWin);
    }
  } else if (estado == StateMachine.GAMEOVER) {
    if (key == 'r' || key == 'R') {
      venado.reset();

      int nivel = levelManager.nivelActual;
      if (nivel == 0) spawner = new Spawner(3000, 10);
      else if (nivel == 1) spawner = new Spawner(2500, 20);
      else spawner = new Spawner(1500, 30);

      spawner.reset();
      if (escena != null) escena.reset();
      estado = StateMachine.TUTORIAL;
      imageMode(CORNER);
    }
  }
}

public void keyReleased() {
  if (keyCode == LEFT || key == 'a') venado.izq = false;
  if (keyCode == RIGHT || key == 'd') venado.der = false;
}

public void mousePressed() {
  if (estado == StateMachine.CINEMATICA) {
    boolean avanzar = escena.manejarClick();
    if (avanzar) {
      estado = StateMachine.TUTORIAL;
      levelManager.nivelActual = 0;
    }
  }
}
