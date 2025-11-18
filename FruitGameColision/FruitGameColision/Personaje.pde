class Personaje {
  PImage[] estados;
  float alto;
  boolean ladoDerecho;

  Personaje(PImage[] estados, float alto, boolean ladoDerecho) {
    this.estados = estados;
    this.alto = alto;
    this.ladoDerecho = ladoDerecho;
  }

  void mostrar(int estado, int paso, boolean habla) {
    if (!habla) return;
    PImage img = obtenerImagen(estado, paso);
    float x = ladoDerecho ? width - 40 - (img.width * (alto / img.height)) : 40;
    float y = height - alto - 140;
    dibujarEscalado(img, x, y, alto);
  }

  PImage obtenerImagen(int estado, int paso) {
    if (estado == 2 && paso == 1 && ladoDerecho) return estados[3]; // oso_surprised
    return estados[estado];
  }
  void dibujarEscalado(PImage img, float x, float y, float altoDeseado) {
  float escala = altoDeseado / img.height;
  float ancho = img.width * escala;
  image(img, x, y, ancho, altoDeseado);
}

}
