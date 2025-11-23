class Manzana extends Fruta {
  float radio = 45;

  public Manzana(PVector pos, PVector velocidad) {
    super(pos, velocidad);
    this.valor = 5;
    this.velocidad.y = 4;
  }

  public void dibujar() {
    imageMode(CENTER);
    if (imgManzana != null) {
      image(imgManzana, posicion.x, posicion.y, radio, radio);
    } else {
      fill(200, 0, 0);
      circle(posicion.x, posicion.y, radio);
    }
  }

  public void caer(float deltaTime) {
    this.posicion.y += this.velocidad.y;
  }
}
