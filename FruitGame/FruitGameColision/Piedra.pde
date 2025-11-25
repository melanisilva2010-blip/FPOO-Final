class Piedra extends Objeto {
  float radio = 50; // Tamaño visual

  public Piedra(PVector pos, PVector velocidad) {
    super(pos, velocidad);
    this.valor = -10; // Quita vida
    this.velocidad.y = 5; // Cae rápido
  }

  public void dibujar() {
    imageMode(CENTER);
    if (imgPiedra != null) {
      image(imgPiedra, posicion.x, posicion.y, radio, radio);
    } else {
      fill(100);
      circle(posicion.x, posicion.y, radio);
    }
  }

  public void caer(float deltaTime) {
    this.posicion.y += this.velocidad.y;
  }
}
