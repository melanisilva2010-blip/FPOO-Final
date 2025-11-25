class Naranja extends Objeto {
  float radio = 40;

  public Naranja(PVector pos, PVector velocidad) {
    super(pos, velocidad);
    this.valor = 10;
    this.velocidad.y = 3;
  }

  public void dibujar() {
    imageMode(CENTER);
    if (imgNaranja != null) {
      image(imgNaranja, posicion.x, posicion.y, radio, radio);
    } else {
      fill(255, 165, 0);
      circle(posicion.x, posicion.y, radio);
    }
  }

  public void caer(float deltaTime) {
    this.posicion.y += this.velocidad.y;
  }
}
