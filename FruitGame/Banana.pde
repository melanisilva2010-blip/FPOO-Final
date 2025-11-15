class Banana extends Fruta {
  float alto, ancho;
  private PImage sprite;

  public Banana(PVector pos, PVector velocidad){
    super(pos, velocidad);
    this.valor = 15;
    this.velocidad.y = 6;
    this.alto = 40; 
    this.ancho = 40;
    sprite = loadImage("Banana.png");
  }

  public void dibujar() {
    if (sprite != null) {
      imageMode(CENTER);
      image(sprite, posicion.x, posicion.y, ancho, alto);
      imageMode(CORNER);
    } else {
      fill(#F5EA11);
      noStroke();
      rect(posicion.x, posicion.y, ancho, alto);
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
