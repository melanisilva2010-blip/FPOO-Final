class Venado {
  private PVector posicion;
  private PVector velocidad;
  private PVector corazonPos;
  private boolean izq, der;
  private int alto, ancho;
  private int vida;
  private int puntaje;
  private int heartSize;
 
  /** constructor del personaje principal y una guia de la ubicacion de sus corazones */
  public Venado() {
    this.posicion = new PVector(400, 500);
    this.velocidad = new PVector(7, 0);
    this.izq = false;
    this.der = false;
    this.alto = 100;
    this.ancho = 40;
    this.vida = 3;
    this.corazonPos = new PVector(550, 50);
    this.heartSize = 40;
    this.puntaje=0;

  }

  public void dibujar() {
    fill(165, 42, 42);
    rectMode(CENTER);
    rect(this.posicion.x, this.posicion.y, this.ancho, this.alto);
    fill(255, 0, 0);
    noStroke();
    /**visualizador de corazones(no definitivo) */
    for (int i = 0; i < vida; i++) {
      circle(corazonPos.x + i * 50, corazonPos.y, heartSize);
    }
    textAlign(CENTER);
    fill(0);
    text("Puntuacion: " + puntaje, 100, 50);
  }
  public void mover() {
    if (izq) this.posicion.x =this.posicion.x - velocidad.x;
    if (der) this.posicion.x =this.posicion.x + velocidad.x;
  }
  public void sumarPuntaje(int valor) {
    this.puntaje += valor;
  }

  public int getX() {
    return (int)(posicion.x);
  }

  public int getY() {
    return (int)(posicion.y);
  }

  public int getPuntaje() {
    return puntaje;
  }
  public void restarVida() {
    if (vida>0) {
      vida--;
    }
  }
  public int getVida() {
    return vida;
  }
  public void reset() {
    this.posicion = new PVector(width/2, 500);
    this.vida = 3;
    this.puntaje = 0;
  }
}
