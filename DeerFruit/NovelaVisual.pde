// --- VARIABLES GLOBALES ---
PImage fondo;
int estado = 0; // 0=intro, 1=aceptó, 2=rechazó, 3=acepta tras insistencia
int paso = 0;   // índice de línea dentro del estado
String lineaActual = "";
boolean hablaOso = true; // quién habla en la línea actual

// --- OBJETOS MODULARIZADOS ---
Personaje oso;
Personaje ciervo;
Boton btnSi, btnNo, btnContinuar;


void setup() {
  size(800, 600);
  fondo = loadImage("background game.jpg");

  // 1. Crear los personajes
  // (Prefijo, x, y, altoDeseado)
  float altoOso = 260;
  float altoDeer = 300;
  float yPersonajes = height - altoDeer - 140; // Alineados aprox.
  
  oso = new Personaje("oso", width - 300, yPersonajes, altoOso); // Posición X ajustada
  ciervo = new Personaje("deer", 40, yPersonajes, altoDeer);

  // 2. Crear los botones
  // (Etiqueta, x, y)
  btnSi = new Boton("SI", 120, height - 80);
  btnNo = new Boton("NO", 240, height - 80);
  btnContinuar = new Boton("Continuar", width - 140, height - 80);

  textSize(18);
}

void draw() {
  // 1. Dibujar fondo
  image(fondo, 0, 0, width, height);

  // 2. Actualizar la lógica del diálogo (qué decir, quién habla)
  actualizarLinea();

  // 3. Dibujar personajes (basado en el estado)
  if (!hablaOso) {
    // Habla ciervo (izquierda)
    ciervo.dibujar( getEmocionCiervo() );
  } else {
    // Habla oso (derecha)
    oso.dibujar( getEmocionOso() );
  }

  // 4. Dibujar UI (caja de texto y botones)
  mostrarCuadroDialogo();

  if (muestraOpciones()) {
    btnSi.dibujar();
    btnNo.dibujar();
  } else {
    btnContinuar.dibujar();
  }
}

void mousePressed() {
  if (muestraOpciones()) {
    if (btnSi.estaSobre()) {
      if (estado == 0) { // eligió SI en la intro
        estado = 1;
        paso = 0;
      } else if (estado == 2) { // eligió SI tras insistencia
        estado = 3;
        paso = 0;
      }
    }
    if (btnNo.estaSobre()) {
      if (estado == 0) { // eligió NO en la intro
        estado = 2;
        paso = 0;
      } else if (estado == 2) { // bucle si sigue eligiendo NO
        estado = 2;
        paso = 0;
      }
    }
  } else {
    // Avanzar entre líneas dentro del estado
    if (btnContinuar.estaSobre()) {
      paso++;
    }
  }
}
