class Dialogo {
  int estado = 0;
  int paso = 0;
  String lineaActual = "";
  boolean hablaOso = true;

  void actualizar() {
    if (estado == 0) {
      if (paso == 0) {
        lineaActual = "Oso: Hola, Ciervo, te quería pedir tu ayuda.";
        hablaOso = true;
      } else if (paso == 1) {
        lineaActual = "Ciervo: ¿Sí? ¿Qué pasa, Oso?";
        hablaOso = false;
      } else if (paso == 2) {
        lineaActual = "Oso: No recolecté suficiente comida para invernar... ¿me ayudas a recolectar algunas?";
        hablaOso = true;
      } else if (paso == 3) {
        lineaActual = "Oso: ¿Me podrías ayudar?";
        hablaOso = true;
      } else {
        paso = 3;
      }
    } else if (estado == 1) {
      // Aceptó
      if (paso == 0) {
        lineaActual = "Ciervo: ¡Sí, por supuesto que lo haré!";
        hablaOso = false;
      } else if (paso == 1) {
        lineaActual = "Oso: ¡Muchas gracias! Ahora te daré una pequeña guía.";
        hablaOso = true;
      } else if (paso == 2) {
        lineaActual = "Oso: Recoge frutas y evita las piedras.";
        hablaOso = true;
      } else if (paso == 3) {
        lineaActual = "Oso: ¡Buena suerte!";
        hablaOso = true;
      } else {
        paso = 3; // fin del bloque
      }
    } else if (estado == 2) {
      // Rechazó
      if (paso == 0) {
        lineaActual = "Ciervo: Lo siento, no.";
        hablaOso = false;
      } else if (paso == 1) {
        lineaActual = "Oso: ...";
        hablaOso = true;
      } else if (paso == 2) {
        lineaActual = "Oso: ¡POR FAVOR!";
        hablaOso = true;
      } else {
        paso = 2;
      } // mantener, aparecen opciones SI/NO (bucle si NO)
    } else if (estado == 3) {
      // Acepta tras insistencia
      if (paso == 0) {
        lineaActual = "Ciervo: ¡DE ACUERDO, DE ACUERDO!";
        hablaOso = false;
      } else if (paso == 1) {
        lineaActual = "Ciervo: Lo haré, no llores, por favor.";
        hablaOso = false;
      } else if (paso == 2) {
        lineaActual = "Oso: ...";
        hablaOso = true;
      } else if (paso == 3) {
        lineaActual = "Oso: Gracias, ahora te daré una pequeña guía.";
        hablaOso = true;
      } else if (paso == 4) {
        lineaActual = "Oso: Recoge frutas y evita las piedras.";
        hablaOso = true;
      } else if (paso == 5) {
        lineaActual = "Oso: ¡Buena suerte!";
        hablaOso = true;
      } else {
        paso = 5; // fin del bloque
      }
    }
  }

  // lógica igual que en tu función actualizarLinea()
  // actualiza lineaActual y hablaOso según estado y paso


  void mostrarCuadro() {
    float boxX = 20, boxY = height - 130, boxW = width - 40, boxH = 110;
    noStroke();
    fill(0, 150);
    rect(boxX, boxY, boxW, boxH);
    fill(255);
    textAlign(LEFT, TOP);
    text(lineaActual, boxX + 16, boxY + 14, boxW - 32, boxH - 28);
    textAlign(CENTER, CENTER);
  }

  boolean muestraOpciones() {
    return (estado == 0 && paso >= 3) || (estado == 2 && paso >= 2);
  }
  void reset() {
    estado = 0;
    paso = 0;
    lineaActual = "";
    hablaOso = true;
    mostrarCuadro();
  }
}
