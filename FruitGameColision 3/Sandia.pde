class Sandia extends Fruta {
  float radio = 60; // Es más grande

  public Sandia(PVector pos, PVector velocidad) {
    super(pos, velocidad);
    this.valor = 25;
    this.velocidad.y = random(3, 5);
  }

  public void dibujar() {
    imageMode(CENTER);
    if (imgSandia != null) {
      image(imgSandia, posicion.x, posicion.y, radio, radio);
    } else {
      fill(0, 255, 0);
      circle(posicion.x, posicion.y, radio);
    }
  }

  public void caer(float deltaTime) {
    this.posicion.y += this.velocidad.y;
  }
}
