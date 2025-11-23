class Fruta {
  PVector posicion;
  PVector velocidad;
  int valor;
  
  Fruta(PVector pos, PVector vel) {
    this.posicion = pos;
    this.velocidad = vel;
  }
  
  // Métodos vacíos para que las hijas los sobrescriban
  void dibujar() {}
  void caer(float dt) {}
  
  // Lógica de colisión básica (Circular)
  boolean hayColision(Venado v) {
    // Distancia entre la fruta y el venado
    float dist = dist(posicion.x, posicion.y, v.getX(), v.getY());
    // Si la distancia es menor a 50 (radio aprox de colisión), choca
    return dist < 50; 
  }
}
