class Fruta {
  protected PVector posicion;
  protected PVector velocidad;
  protected int valor;

  public Fruta(PVector pos, PVector velocidad) {
    this.posicion = pos;
    this.velocidad = velocidad;
    this.posicion.x = random(50, 600);
    this.posicion.y = 0;
    this.velocidad.y = 4;
  }

  void dibujar(){}
  void caer(float deltaTime){}
  void hayColision(){}

  // Indica si la fruta ya salió de la pantalla (margen)
  public boolean isOffScreen() {
    return posicion.y > height + 120; // margen para que desaparezca "completamente"
  }
}
