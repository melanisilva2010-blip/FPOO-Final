// --- VARIABLES ORIGINALES ---
private Venado venado;
private PImage fondo, tuto;
private int estado;
private float deltaTime = millis();
private float lastTime = millis();
private Spawner spawner;
private Escena escena;

// --- VARIABLES AGREGADAS (Niveles, Game Over, Transición) ---
private PImage imgGameOver;
private PImage fondoNiveles;
private LevelManager levelManager;

// Variables para el Fade (sin clase externa para no invadir)
float fadeAlpha = 0;
boolean fading = false;
boolean fadeToBlack = true;
int estadoSiguiente = -1;

public void setup() {
  size(800, 600);
  venado = new Venado();
  escena = new Escena();
  imageMode(CORNER);
  
  // Carga de imágenes con protección
  try {
    fondo = loadImage("backgroundtest.jpg");
    tuto = loadImage("arbolBack.png");
    fondoNiveles = loadImage("niveles.jpg");      // Tu imagen de niveles
    imgGameOver = loadImage("gameover_img.jpg");  // Tu imagen de Game Over
  } catch (Exception e) {
    println("Error cargando imágenes.");
  }
  
  spawner = new Spawner(3000, 5);
  levelManager = new LevelManager(); // Inicializamos el manager
  estado = StateMachine.MENU;
}

public void draw() {
  float currentTime = millis();
  deltaTime = (currentTime - lastTime) / 1000; // Corregí la división para que sea float
  lastTime = currentTime; // Actualizamos lastTime correctamente
  
  // Dibujo del fondo base (para limpiar)
  if (estado != StateMachine.TUTORIAL && estado != StateMachine.MENU_NIVELES) {
     if(fondo != null) image(fondo, 0, 0, width, height);
     else background(200);
  }

  /** uso de la maquina de estado */
  switch(estado) {
  case StateMachine.MENU:
    {
      textAlign(CENTER);
      fill(0);
      textSize(20);
      // TUS POSICIONES ORIGINALES
      text("(pulsa ENTER para comenzar)", 150, 270);
      text("(pulsa c para ver los creditos)", 150, 400);
      break;
    }
  case StateMachine.CINEMATICA:
    {
      escena.dibujar();
      break;
    }
  case StateMachine.TUTORIAL:
    {
      imageMode(CORNER); 
      if(tuto != null) image(tuto, 0, 0, width, height); 
      
      venado.dibujar();
      venado.mover();

      fill(0);
      textSize(20);
      // TU POSICIÓN ORIGINAL
      text("Pulsa 'q' para pausar", 100, 15);
      
      spawner.actualizar(deltaTime, venado);
      
      // --- LÓGICA DE TRANSICIÓN AGREGADA ---
      // Si es Tutorial y llegamos a 150 puntos -> Transición al menú de niveles
      if (levelManager.nivelActual == 0 && venado.getPuntaje() >= 150) {
         if (!fading) {
            iniciarTransicion(StateMachine.MENU_NIVELES);
         }
      }
      
      if (venado.getVida() <= 0) {
        estado = StateMachine.GAMEOVER;
      }

      break;
    }

  case StateMachine.PAUSA:
    {
      background(#B3DBDA);
      fill(255);
      textSize(40);
      // TUS POSICIONES ORIGINALES
      text("Menu de pausa", width/2, 100);
      text("Pulsa ENTER para volver al juego", width/2, 200);
      text("Pulsa Z para volver al MENU", width/2, 300);
      break;
    }
  case StateMachine.CREDITOS:
    {
      background(#B3DBDA);
      textSize(20);
      // TUS POSICIONES ORIGINALES
      text("Creditos", 50, 100);
      text("pulse z para volver al menu", 130, 50);
      break; // Faltaba el break aquí en tu código original
    }
    
  // --- CASO MODIFICADO: GAME OVER CON IMAGEN ---
  case StateMachine.GAMEOVER:
    {
      if (imgGameOver != null) image(imgGameOver, 0, 0, width, height);
      else background(255, 0, 0); // Fondo rojo si no carga la imagen
      
      fill(255);
      textAlign(CENTER);
      // TUS TEXTOS Y POSICIONES ORIGINALES
      text("Oh no! Te has quedado sin vidas :(", width/2, height/2);
      text("Pulsa R para reiniciar", 450, 350);
      break;
    }
    
  // --- CASO NUEVO: MENÚ DE NIVELES ---
  case StateMachine.MENU_NIVELES:
    {
       if (fondoNiveles != null) image(fondoNiveles, 0, 0, width, height);
       else background(50, 0, 100);
       
       // No agregué texto extra para no ensuciar tu imagen "niveles.jpg"
       break;
    }
  }
  
  // --- LÓGICA DEL FADE (DIBUJADO AL FINAL) ---
  if (fading) {
    rectMode(CORNER); // Aseguramos que cubra desde la esquina
    noStroke();
    fill(0, fadeAlpha);
    rect(0, 0, width, height); // Cubre TODA la pantalla
    
    if (fadeToBlack) {
      fadeAlpha += 5; // Velocidad de oscurecimiento
      if (fadeAlpha >= 255) {
        fadeAlpha = 255;
        estado = estadoSiguiente; // Cambio de estado oculto
        fadeToBlack = false;      // Comenzar a aclarar
      }
    } else {
      fadeAlpha -= 5; // Velocidad de aclarado
      if (fadeAlpha <= 0) {
        fadeAlpha = 0;
        fading = false; // Fin de la transición
      }
    }
  }
}

// Función auxiliar para iniciar el fade
void iniciarTransicion(int proximo) {
  fading = true;
  fadeToBlack = true;
  estadoSiguiente = proximo;
  fadeAlpha = 0;
}

public void keyPressed() {
  
  if (keyCode == ENTER && estado == StateMachine.MENU) {
    estado = StateMachine.CINEMATICA;
  }
  if (keyCode == LEFT || key == 'a') venado.izq = true;
  if (keyCode == RIGHT || key == 'd') venado.der = true;

  if (key == 'q' && estado == StateMachine.TUTORIAL) {
    estado = StateMachine.PAUSA;
  }
  if (keyCode == ENTER && estado == StateMachine.PAUSA) {
    estado = StateMachine.TUTORIAL;
  }
  if (key == 'z' && estado == StateMachine.PAUSA) {
    estado = StateMachine.MENU;
  }
  if (key == 'c' && estado == StateMachine.MENU) {
    estado = StateMachine.CREDITOS;
  }
  // Cierre de créditos (faltaba en tu lógica original dentro del if)
  if (key == 'z' && estado == StateMachine.CREDITOS) {
      estado = StateMachine.MENU;
  }
  
  if (key == 'r' && estado == StateMachine.GAMEOVER) {
    venado.reset();
    spawner.reset();
    if(escena != null) escena.reset();
    estado = StateMachine.TUTORIAL;
    levelManager.nivelActual = 0; // Reinicia al tutorial
  }
  
  // --- NUEVO: CONTROL MENÚ DE NIVELES ---
  if (estado == StateMachine.MENU_NIVELES) {
    if (key == '1') levelManager.cargarNivel(1);
    if (key == '2') levelManager.cargarNivel(2);
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
