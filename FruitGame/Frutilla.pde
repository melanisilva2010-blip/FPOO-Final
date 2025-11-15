class Frutilla extends Fruta {
  float radio = 35; // en tu código original se usa como diámetro
  private PImage sprite;

  public Frutilla(PVector pos, PVector velocidad){
    super(pos, velocidad);
    this.valor = 20;
    this.velocidad.y = 5;
    sprite = loadImage("Frutilla.png");
  }

  public void dibujar() {
    if (sprite != null) {
      imageMode(CENTER);
      image(sprite, posicion.x, posicion.y, radio, radio);
      imageMode(CORNER);
    } else {
      fill(255, 0, 0);
      noStroke();
      circle(posicion.x, posicion.y, radio);
    }
  }

  public void caer(float deltaTime) {
    this.posicion.y = this.posicion.y + this.velocidad.y;
    if( height <= posicion.y){
      posicion.y = 0; 
      posicion.x = random(50, width-50);
    }
  }

  public void hayColision() {}
}
