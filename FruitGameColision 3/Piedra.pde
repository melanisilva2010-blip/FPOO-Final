class Piedra extends Fruta {
  float radio = 50;

  public Piedra(PVector pos, PVector velocidad) {
    super(pos, velocidad);
    this.valor = -10;
    this.velocidad.y = 5;
  }

  public void dibujar() {
    fill(180);
    noStroke();
    circle(posicion.x, posicion.y, radio);
  }
  public void caer(float deltaTime) {
    this.posicion.y = this.posicion.y + this.velocidad.y;
    if ( height <= posicion.y) {
      posicion.y = 0;
      posicion.x = random(50, width-50);
    }
  }

  public void hayColision() {
  }
}
