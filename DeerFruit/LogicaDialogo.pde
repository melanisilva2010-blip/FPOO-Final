// --- Lógica de diálogo por estado/paso ---
void actualizarLinea() {
  // Cada estado tiene líneas secuenciales; sólo una visible por vez
  if (estado == 0) {
    // Intro con cuatro líneas
    if (paso == 0) { lineaActual = "Oso: Hola, Ciervo, te quería pedir tu ayuda."; hablaOso = true; }
    else if (paso == 1) { lineaActual = "Ciervo: ¿Sí? ¿Qué pasa, Oso?"; hablaOso = false; }
    else if (paso == 2) { lineaActual = "Oso: No recolecté suficiente comida para invernar... ¿me ayudas a recolectar algunas?"; hablaOso = true; }
    else if (paso == 3) { lineaActual = "Oso: ¿Me podrías ayudar?"; hablaOso = true; }
    else { paso = 3; } // mantener en la última línea hasta elegir (aparecen opciones)
  }
  else if (estado == 1) {
    // Aceptó
    if (paso == 0) { lineaActual = "Ciervo: ¡Sí, por supuesto que lo haré!"; hablaOso = false; }
    else if (paso == 1) { lineaActual = "Oso: ¡Muchas gracias! Ahora te daré una pequeña guía."; hablaOso = true; }
    else { paso = 1; } // fin del bloque: acá iniciaría el tutorial
  }
  else if (estado == 2) {
    // Rechazó
    if (paso == 0) { lineaActual = "Ciervo: Lo siento, no."; hablaOso = false; }
    else if (paso == 1) { lineaActual = "Oso: ..."; hablaOso = true; }
    else if (paso == 2) { lineaActual = "Oso: ¡POR FAVOR!"; hablaOso = true; }
    else { paso = 2; } // mantener, aparecen opciones SI/NO (bucle si NO)
  }
  else if (estado == 3) {
    // Acepta tras insistencia
    if (paso == 0) { lineaActual = "Ciervo: ¡DE ACUERDO, DE ACUERDO!"; hablaOso = false; }
    else if (paso == 1) { lineaActual = "Ciervo: Lo haré, no llores, por favor."; hablaOso = false; }
    else if (paso == 2) { lineaActual = "Oso: ..."; hablaOso = true; }
    else if (paso == 3) { lineaActual = "Oso: Gracias, ahora te daré una pequeña guía."; hablaOso = true; }
    else { paso = 3; } // fin del bloque: acá iniciaría el tutorial
  }
}

// --- Helpers de imágenes según estado ---
// *** NOTA EL CAMBIO: Ahora devuelven un String de emoción ***

String getEmocionOso() {
  if (estado == 0) return "default";
  if (estado == 1) return "happy";
  if (estado == 2) {
    if (paso == 1) return "surprised";
    return "sad";
  }
  if (estado == 3) return "happy";
  return "default";
}

String getEmocionCiervo() {
  if (estado == 0) return "default";
  if (estado == 1) return "happy";
  if (estado == 2) return "seriously"; // Tu nombre de archivo original
  if (estado == 3) return "surprised";
  return "default";
}

// --- Lógica de UI (movida aquí) ---
void mostrarCuadroDialogo() {
  // Cuadro en la parte inferior
  float boxX = 20;
  float boxY = height - 130;
  float boxW = width - 40;
  float boxH = 110;

  noStroke();
  fill(0, 150);
  rect(boxX, boxY, boxW, boxH);

  fill(255);
  textAlign(LEFT, TOP);
  text(lineaActual, boxX + 16, boxY + 14, boxW - 32, boxH - 28);
}

boolean muestraOpciones() {
  // En intro (estado 0) y rechazo (estado 2), cuando se llega a la última línea del bloque, mostrar SI/NO
  if (estado == 0 && paso >= 3) return true;
  if (estado == 2 && paso >= 2) return true;
  return false;
}
