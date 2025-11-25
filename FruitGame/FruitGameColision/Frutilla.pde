class Frutilla extends Objeto {
  float radio = 30;

  public Frutilla(PVector pos, PVector velocidad) {
    super(pos, velocidad);
    this.valor = 20;
    this.velocidad.y = 5;
  }

  public void dibujar() {
    imageMode(CENTER);
    if (imgFrutilla != null) {
      image(imgFrutilla, posicion.x, posicion.y, radio, radio);
    } else {
      fill(255, 0, 0);
      circle(posicion.x, posicion.y, radio);
    }
  }

  public void caer(float deltaTime) {
    this.posicion.y += this.velocidad.y;
  }
}
