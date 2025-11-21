class Fruta {
  protected PVector posicion;
  protected PVector velocidad;
  protected int valor;

  public Fruta(PVector pos, PVector velocidad) {
    this.posicion = pos;
    this.velocidad = velocidad;
    this.posicion.x = random(50, 550);
    this.posicion.y = 0;
    this.velocidad.y = 3;
  }

  void dibujar() {
  }
  void caer(float deltaTime) {
  }
  public boolean hayColision(Venado v) {
    float distancia = dist(posicion.x, posicion.y, v.getX(), v.getY());
    return distancia < 50; // ajustable según tamaño
  }
}
