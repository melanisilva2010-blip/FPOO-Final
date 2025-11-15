class Sandia extends Fruta {
  float radio = 60; // diámetro
  private PImage sprite;

  public Sandia(PVector pos, PVector velocidad) {
    super(pos, velocidad);
    this.valor = 25;
    this.velocidad.y = random(5, 5);
    sprite = loadImage("Sandia.png");
  }

  public void dibujar() {
    if (sprite != null) {
      imageMode(CENTER);
      image(sprite, posicion.x, posicion.y, radio, radio);
      imageMode(CORNER);
    } else {
      fill(0, 255, 0);
      noStroke();
      circle(posicion.x, posicion.y, radio);
    }
  }

  public void caer(float deltaTime) {
    this.posicion.y = this.posicion.y + this.velocidad.y;
    if ( height <= posicion.y) {
      posicion.y = 0;
      posicion.x = random(50, width-50);
    }
  }

  public void hayColision() {}
}
