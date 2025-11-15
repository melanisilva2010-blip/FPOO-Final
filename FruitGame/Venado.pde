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
    this.posicion = new PVector(width/2, 500);
    this.velocidad = new PVector(9, 0);
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
    background(255);
    rectMode(CENTER);
    fill(#956530);
    rect(this.posicion.x, this.posicion.y, this.ancho, this.alto);
    fill(255, 0, 0);
    noStroke();
    /**visualizador de corazones(no definitivo) */
    circle(corazonPos.x, corazonPos.y, heartSize);
    circle(corazonPos.x+50, corazonPos.y, heartSize);
    circle(corazonPos.x+100, corazonPos.y, heartSize);
    textAlign(CENTER);
    fill(0);
    text("Puntuacion: ", 100, 50);
  }
  public void mover() {
    if (izq) this.posicion.x =this.posicion.x - velocidad.x;
    if (der) this.posicion.x =this.posicion.x + velocidad.x;
  }
}
