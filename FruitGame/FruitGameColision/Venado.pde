import gifAnimation.* ;

class Venado {
  private PApplet parent;
  private PVector posicion;
  private PVector velocidad;
  private PVector corazonPos;
  // Hacemos públicas estas variables o usamos setters,
  // pero como tu Main accede a .izq y .der directamente, las dejamos así.
  public boolean izq, der;
  private int alto, ancho;
  private int vida;
  private int puntaje;
  private int heartSize;

  private boolean mirandoIzquierda;

  // Imágenes
  private Gif animCaminar;
  private Gif animMuerte;
  private PImage imgMuerteFinal;

  // Control de muerte
  private boolean muriendo = false;
  private int tiempoInicioMuerte = 0;
  private int duracionMuerte = 1500;

  public Venado(PApplet parent) {
    this.posicion = new PVector(400, 500);
    this.velocidad = new PVector(7, 0);
    this.izq = false;
    this.der = false;
    this.parent = parent;

    this.alto = 200;
    this.ancho = 150;

    this.vida = 3;
    this.corazonPos = new PVector(550, 50);
    this.heartSize = 40;
    this.puntaje = 0;
    this.mirandoIzquierda = true;

    try {
      animCaminar = new Gif(parent, "deer-walk.gif");
      animCaminar.loop();  // Configuramos para que pueda repetirse...
      animCaminar.jump(0); // ...pero lo ponemos en el cuadro 0...
      animCaminar.pause(); // ...y lo pausamos al inicio.

      animMuerte = new Gif(parent, "deer-death.gif");
      animMuerte.play();
      animMuerte.ignoreRepeat();

      imgMuerteFinal = loadImage("deer-death 1.png");
    }
    catch (Exception e) {
      println("Error cargando GIFs: " + e.getMessage());
      animCaminar = null;
    }
  }

  public void dibujar() {
    imageMode(CENTER);

    if (vida > 0) {
      // --- 1. ESTÁ VIVO ---
      if (animCaminar != null) {

        // --- NUEVA LÓGICA DE ANIMACIÓN ---
        // Si se está moviendo (izquierda O derecha son true)
        if (izq || der) {
          animCaminar.play(); // ¡Camina!
        } else {
          animCaminar.pause(); // ¡Quieto!
          animCaminar.jump(0); // Volver a la pose de "parado" (cuadro 0)
        }
        // ---------------------------------

        pushMatrix();
        translate(posicion.x, posicion.y);

        if (!mirandoIzquierda) {
          scale(-1, 1);
        }

        parent.image(animCaminar, 0, 0, this.ancho, this.alto);

        popMatrix();
      } else {
        // Fallback
        rectMode(CENTER);
        fill(165, 42, 42);
        rect(this.posicion.x, this.posicion.y, this.ancho, this.alto);
      }

      dibujarInterfaz();
    } else {
      // --- 2. ESTÁ MUERTO ---
      if (!muriendo) {
        muriendo = true;
        tiempoInicioMuerte = millis();
        if (animMuerte != null) {
          animMuerte.jump(0);
          animMuerte.play();
        }
      }

      pushMatrix();
      translate(posicion.x, posicion.y);

      if (!mirandoIzquierda) scale(-1, 1);

      if (millis() - tiempoInicioMuerte < duracionMuerte) {
        if (animMuerte != null) image(animMuerte, 0, 0, this.ancho, this.alto);
      } else {
        if (imgMuerteFinal != null) image(imgMuerteFinal, 0, 0, this.ancho, this.alto);
      }
      popMatrix();
    }
  }

  void dibujarInterfaz() {
    fill(255, 0, 0);
    noStroke();
    for (int i = 0; i < vida; i++) {
      circle(corazonPos.x + i * 50, corazonPos.y, heartSize);
    }
    textAlign(LEFT);
    fill(0);
    text("Puntaje: " + puntaje, 100, 35);
  }

  public void mover() {
    if (vida > 0) {
      if (izq) {
        this.posicion.x -= velocidad.x;
        mirandoIzquierda = true;
      }
      if (der) {
        this.posicion.x += velocidad.x;
        mirandoIzquierda = false;
      }

      if (posicion.x < ancho/2) posicion.x = ancho/2;
      if (posicion.x > width - ancho/2) posicion.x = width - ancho/2;
    }
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
  public int getVida() {
    return vida;
  }

  public void restarVida() {
    if (vida > 0) vida--;
  }

  public void reset() {
    this.posicion = new PVector(width/2, 500);
    this.vida = 3;
    this.puntaje = 0;
    this.muriendo = false;
    this.mirandoIzquierda = true;

    // Al reiniciar, nos aseguramos de que empiece quieto
    if (animCaminar != null) {
      animCaminar.jump(0);
      animCaminar.pause();
    }
  }
}
