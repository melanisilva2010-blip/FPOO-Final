// --- Utilidad de escala proporcional ---
void dibujarEscalado(PImage img, float x, float y, float altoDeseado) {
  // Manejar caso donde la imagen no se haya cargado
  if (img == null || img.height == 0) { 
    println("Error: Imagen nula o sin altura.");
    return;
  }
  float escala = altoDeseado / img.height;
  float ancho = img.width * escala;
  image(img, x, y, ancho, altoDeseado);
}
