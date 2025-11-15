class Banana extends Fruta {
  float alto, ancho;
  public Banana(PVector pos, PVector velocidad){
  super(pos, velocidad);
  this.valor = 15;
  this.velocidad.y = 3;
  this.alto = 10; 
  this.ancho = 30;
  }
  
  public void dibujar() {
    fill(#F5EA11);
    noStroke();
    rect(posicion.x, posicion.y, ancho, alto);
  }
   public void caer(float deltaTime) {
  this.posicion.y = this.posicion.y + this.velocidad.y;
  if( height <= posicion.y){
   posicion.y = 0; 
   posicion.x = random(50, width-50);
  }
  }
  
  public void hayColision() {
  }
}
