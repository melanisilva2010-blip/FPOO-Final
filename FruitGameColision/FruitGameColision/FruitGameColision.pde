private Venado venado;
private PImage fondo;
private int estado;
private ArrayList<Fruta> frutas;
private int ultimaFruta = 0;
private int intervaloFruta=9000;
private int maxFrutas = 5;
private float deltaTime = millis();
private float lastTime = millis();
private Escena escena;

public void setup() {
  size(800, 600);
  venado = new Venado();
  escena = new Escena();
  imageMode(CORNER);
  fondo = loadImage("backgroundtest.jpg");
  estado = StateMachine.MENU;
  frutas = new ArrayList<Fruta>();
}
void generarFruta() {
  PVector pos = new PVector();
  PVector vel = new PVector();
  Fruta nueva;

  int tipo = int(random(6)); // 0 a 5: 4 frutas + piedra

  switch(tipo) {
    case 0:
      nueva = new Manzana(pos, vel);
      break;
    case 1:
      nueva = new Banana(pos, vel);
      break;
    case 2:
      nueva = new Frutilla(pos, vel);
      break;
    case 3:
      nueva = new Naranja(pos, vel);
      break;
    case 4:
      nueva = new Sandia(pos, vel);
      break;
    default:
      nueva = new Piedra(pos, vel); // enemigo
      break;
  }

  frutas.add(nueva);
}



public void draw() {
  float currentTime = millis();
  deltaTime = currentTime-lastTime/1000;
  image(fondo, 0, 0, width, height);
  
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
     
      venado.dibujar();
      venado.mover();
     
      fill(0);
      textSize(20);
      text("Pulsa 'q' para pausar", 100, 15);
     
      for (int i = frutas.size() - 1; i >= 0; i--) {
    Fruta f = frutas.get(i);
    f.dibujar();
    f.caer(deltaTime);

    // Aquí va el instanceof
    if (f instanceof Frutilla) {
      Frutilla frutilla = (Frutilla) f;
      if (frutilla.hayColision(venado)) {
        venado.sumarPuntaje(frutilla.valor);
        frutas.remove(i);
      }
    }
    // Podés agregar más tipos:
    else if (f instanceof Piedra) {
      Piedra piedra = (Piedra) f;
      if (piedra.hayColision(venado)) {
        //venado.restarVida(); // si tenés este método
        frutas.remove(i);
      }
    }
  }


     if (millis() - ultimaFruta > intervaloFruta && frutas.size() < maxFrutas) {
  generarFruta();
  ultimaFruta = millis();
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
  if (key == 'z' && estado== StateMachine.CREDITOS) {
    estado = StateMachine.MENU;
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
