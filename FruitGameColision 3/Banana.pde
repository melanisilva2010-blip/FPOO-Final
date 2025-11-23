class Banana extends Fruta {
  float ancho = 40; // Ajustado para que se vea bien
  float alto = 40;

  public Banana(PVector pos, PVector velocidad) {
    super(pos, velocidad);
    this.valor = 15;
    this.velocidad.y = 3;
  }

  public void dibujar() {
    // Usamos la imagen global cargada en el Main
    imageMode(CENTER);
    if (imgBanana != null) {
      image(imgBanana, posicion.x, posicion.y, ancho, alto);
    } else {
      // Por si falla la imagen, dibuja un cuadro amarillo
      fill(255, 255, 0);
      rect(posicion.x, posicion.y, ancho, alto);
    }
  }

  public void caer(float deltaTime) {
    this.posicion.y += this.velocidad.y;
    // ELIMINÉ EL REINICIO A 0 PARA EVITAR LAG INFINITO
  }
}
