import gifAnimation.*;

// --- VARIABLES GLOBALES ---
private Venado venado;
private PImage fondo, tuto;
private int estado;
private float deltaTime;
private float lastTime;
private Spawner spawner;
private Escena escena;

// --- VARIABLES DE UI Y NIVELES ---
private PImage imgGameOver;
private PImage fondoNiveles;
private LevelManager levelManager;

// --- FUENTES ---
private PFont fuentePixel;  // Para YOU WIN y GAME OVER
private PFont fuenteNormal; // Para lo demás

// --- VARIABLES FADE Y LOGICA ---
float fadeAlpha = 0;
boolean fading = false;
boolean fadeToBlack = true;
int estadoSiguiente = -1;
int destinoDespuesDeWin = -1;

// --- VARIABLE PARA TIEMPO DE MUERTE ---
int timerMuerte = 0;

public void setup() {
  size(800, 600);
  
  venado = new Venado(this);
  escena = new Escena();
  
  // Spawner inicial (Tutorial) - Intervalo 2000, 10 frutas
 
  spawner = new Spawner(4000, 10);
  
  levelManager = new LevelManager();
  
  imageMode(CORNER);
  
  try {
    fondo = loadImage("backgroundtest.jpg");
    tuto = loadImage("arbolBack.png");
    fondoNiveles = loadImage("niveles.jpg");     
    imgGameOver = loadImage("gameover_img.jpg"); 
    
    fuentePixel = createFont("PixelGameFont.ttf", 60); 
    fuenteNormal = createFont("SansSerif", 20); 
    
  } catch (Exception e) {
    println("Error cargando recursos: " + e.getMessage());
    fuentePixel = createFont("Arial", 60);
    fuenteNormal = createFont("Arial", 20);
  }

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
    
    case StateMachine.MENU: {
      if(fondo != null) image(fondo, 0, 0, width, height);
      textAlign(CENTER);
      fill(0);
      textSize(20);
      text("(pulsa ENTER para comenzar)", 150, 270); 
      text("(pulsa C para ver los creditos)", 150, 400);
      break;
    }
    
    case StateMachine.CINEMATICA: {
      escena.dibujar();
      break;
    }
    
    case StateMachine.TUTORIAL: {
      imageMode(CORNER); 
      if(tuto != null) image(tuto, 0, 0, width, height);
      
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
      }
      else if (levelManager.nivelActual == 1 && venado.getPuntaje() >= 300) {
         prepararVictoria(StateMachine.MENU_NIVELES);
      }
      else if (levelManager.nivelActual == 2 && venado.getPuntaje() >= 500) {
         prepararVictoria(StateMachine.MENU);
      }

      // --- DERROTA ---
      if (venado.getVida() <= 0) {
        estado = StateMachine.MURIENDO;
        timerMuerte = millis(); 
      }
      break;
    }
    
    // --- ESTADO INTERMEDIO: ANIMACIÓN DE MUERTE (4 SEGUNDOS) ---
    case StateMachine.MURIENDO: {
      imageMode(CORNER);
      if(tuto != null) image(tuto, 0, 0, width, height);
      
      spawner.dibujarCongelado(); 
      venado.dibujar(); // El venado sabe que tiene que mostrar el GIF de muerte
      
      // Espera 4 segundos y pasa a la pantalla de Game Over definitiva
      if (millis() - timerMuerte > 4000) {
         estado = StateMachine.GAMEOVER;
      }
      break;
    }
    
    case StateMachine.MENU_NIVELES: {
       if (fondoNiveles != null) image(fondoNiveles, 0, 0, width, height);
       else background(50, 0, 100);
       break;
    }

    case StateMachine.PAUSA: {
      background(#B3DBDA);
      fill(255);
      textAlign(CENTER);
      textSize(40);
      text("Menu de pausa", width/2, 100);
      text("Pulsa ENTER para volver al juego", width/2, 200);
      text("Pulsa Z para volver al MENU", width/2, 300);
      break;
    }
    
    case StateMachine.CREDITOS: {
      background(#B3DBDA);
      textSize(20);
      textAlign(LEFT);
      text("Creditos", 50, 100);
      text("pulse z para volver al menu", 130, 50);
      break;
    }
    
    // --- GAME OVER (ESTILO "YOU WIN") ---
    case StateMachine.GAMEOVER: {
      // 1. Dibujar el juego congelado de fondo
      if(tuto != null) image(tuto, 0, 0, width, height);
      spawner.dibujarCongelado(); 
      venado.dibujar(); // Mostrará la imagen final de muerte (deer-death 1.png)
      
      // 2. Capa oscura semitransparente
      rectMode(CORNER);
      noStroke();
      fill(0, 150); // Negro con transparencia
      rect(0, 0, width, height);
      
      // 3. Texto con Fuente Pixel
      textFont(fuentePixel); 
      textAlign(CENTER);
      
      fill(255, 0, 0); // Rojo para Game Over
      textSize(80);
      text("GAME OVER", width/2, height/2);
      
      // Texto parpadeante
      textSize(30);
      fill(255);
      if (frameCount % 60 < 30) {
         text("PRESS 'R' TO RESTART", width/2, height/2 + 60);
      }
      break;
    }
    
    // --- YOU WIN (ESTILO ORIGINAL) ---
    case StateMachine.YOU_WIN: {
      if(tuto != null) image(tuto, 0, 0, width, height);
      venado.dibujar(); 
      spawner.dibujarCongelado(); 
      
      rectMode(CORNER);
      noStroke();
      fill(0, 150);
      rect(0, 0, width, height);
      
      textFont(fuentePixel); 
      textAlign(CENTER);
      
      fill(255, 215, 0); // Dorado
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
  }
  else if (estado == StateMachine.TUTORIAL) {
    if (key == 'q') estado = StateMachine.PAUSA;
  }
  else if (estado == StateMachine.PAUSA) {
    if (keyCode == ENTER) estado = StateMachine.TUTORIAL;
    if (key == 'z') estado = StateMachine.MENU;
  }
  else if (estado == StateMachine.CREDITOS) {
    if (key == 'z') estado = StateMachine.MENU;
  }
  else if (estado == StateMachine.MENU_NIVELES) {
    if (key == '1') levelManager.cargarNivel(1);
    if (key == '2') levelManager.cargarNivel(2);
  }
  
  else if (estado == StateMachine.YOU_WIN) {
     if (keyCode == ENTER) {
        iniciarTransicion(destinoDespuesDeWin);
     }
  }
  
  // En keyPressed -> GAMEOVER
  else if (estado == StateMachine.GAMEOVER) {
    if (key == 'r' || key == 'R') {
      venado.reset();
      
      int nivel = levelManager.nivelActual;
      // Actualizamos los tiempos aquí también
      if (nivel == 0) spawner = new Spawner(4000, 10); 
      else if (nivel == 1) spawner = new Spawner(2500, 20); 
      else spawner = new Spawner(1500, 30); 
      
      spawner.reset();
      if(escena != null) escena.reset(); 
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
