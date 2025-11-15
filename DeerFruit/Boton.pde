class Boton {
  
  float x, y, w, h;
  String etiqueta;
  
  Boton(String etiqueta, float x, float y) {
    this.etiqueta = etiqueta;
    this.x = x;
    this.y = y;
    this.w = 100; // Ancho fijo
    this.h = 40;  // Alto fijo
  }
  
  // Dibuja el botón (antes 'mostrarBoton')
  void dibujar() {
    boolean hover = estaSobre(); // Comprueba internamente

    fill(hover ? color(255, 230, 160) : color(255, 210, 120));  
    stroke(60);
    rect(x, y, w, h, 8);

    fill(0);
    textAlign(CENTER, CENTER);
    text(etiqueta, x + w/2, y + h/2);
  }
  
  // Comprueba la colisión (antes 'mouseEnBoton')
  boolean estaSobre() {
    return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  }
}
