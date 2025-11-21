private Venado venado;
private PImage fondo, tuto;
private int estado;
private float deltaTime = millis();
private float lastTime = millis();
private Spawner spawner;
private Escena escena;

public void setup() {
  size(800, 600);
  venado = new Venado();
  escena = new Escena();
  imageMode(CORNER);
  fondo = loadImage("backgroundtest.jpg");
  spawner = new Spawner(3000, 5);
  estado = StateMachine.MENU;
  tuto = loadImage("arbolBack.png");
}

public void draw() {
  float currentTime = millis();
  deltaTime = (currentTime-lastTime)/1000;
  image(fondo, 0, 0, width, height);
  /**uso de la maquina de estado*/
  switch(estado) {
  case StateMachine.MENU:
    {
      textAlign(CENTER);
      fill(0);
      textSize(20);
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
  image(tuto, 0, 0, width, height); 
      venado.dibujar();
      venado.mover();

      fill(0);
      textSize(20);
      text("Pulsa 'q' para pausar", 100, 15);
      spawner.actualizar(deltaTime, venado);
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
      text("Menu de pausa", width/2, 100);
      text("Pulsa ENTER para volver al juego", width/2, 200);
      text("Pulsa Z para volver al MENU", width/2, 300);
      break;
    }
  case StateMachine.CREDITOS:
    {
      background(#B3DBDA);
      textSize(20);
      text("Creditos", 50, 100);
      text("pulse z para volver al menu", 130, 50);
    }
  case StateMachine.GAMEOVER:
    {
      background(255, 0, 0);
      fill(255);
      textAlign(CENTER);
      text("Oh no! Te has quedado sin vidas :(", width/2, height/2);
      text("Pulsa R para reiniciar", 450, 350);
    }
  }
}

public void keyPressed() {
  if (keyCode == ENTER && estado == StateMachine.MENU) {
    estado = StateMachine.CINEMATICA;
  }
  if (keyCode == LEFT||key=='a') venado.izq = true;
  if (keyCode == RIGHT||key=='d') venado.der = true;

  /**if(key == 'f' && estado == StateMachine.CINEMATICA){
   estado = StateMachine.TUTORIAL;
   }*/
  if (key == 'q'&& estado == StateMachine.TUTORIAL) {
    estado = StateMachine.PAUSA;
  }
  if (keyCode == ENTER && estado == StateMachine.PAUSA) {
    estado = StateMachine.TUTORIAL;
  }
  if (key =='z' && estado == StateMachine.PAUSA) {
    estado = StateMachine.MENU;
  }
  if (key == 'c' && estado == StateMachine.MENU) {
    estado = StateMachine.CREDITOS;
  }
  if (key == 'r' && estado == StateMachine.GAMEOVER) {
    venado.reset();
    spawner.reset();
    escena.reset();   // 👈 reinicia diálogo y botones
    estado = StateMachine.TUTORIAL;
  }
}

public void keyReleased() {
  if (keyCode == LEFT||key=='a') venado.izq = false;
  if (keyCode == RIGHT||key=='d') venado.der = false;
}
public void mousePressed() {
  if (estado == StateMachine.CINEMATICA) {
    boolean avanzar = escena.manejarClick();
    if (avanzar) {
      estado = StateMachine.TUTORIAL;
    }
  }
}
