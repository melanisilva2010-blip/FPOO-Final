class Escena {
  private PImage fondo;
  private Personaje oso, ciervo;
  private Boton btnSi, btnNo, btnContinuar;
  private Dialogo dialogo;

  public Escena() {
    fondo = loadImage("background game.jpg");
    oso = new Personaje(new PImage[]{
      loadImage("oso_default.png"),
      loadImage("oso_happy.png"),
      loadImage("oso_sad.png"),
      loadImage("oso_surprised.png")
      }, 260, true);

    ciervo = new Personaje(new PImage[]{
      loadImage("deer_default.png"),
      loadImage("deer_happy.png"),
      loadImage("deer_seriusly.png"),
      loadImage("deer_surprised.png")
      }, 300, false);

    btnSi = new Boton(new PVector(120, height - 80), "SI");
    btnNo = new Boton(new PVector(240, height - 80), "NO");
    btnContinuar = new Boton(new PVector(width - 140, height - 80), "Continuar");

    dialogo = new Dialogo();
  }



  void dibujar() {
    image(fondo, 0, 0, width, height);
    dialogo.actualizar();
    oso.mostrar(dialogo.estado, dialogo.paso, dialogo.hablaOso);
    ciervo.mostrar(dialogo.estado, dialogo.paso, !dialogo.hablaOso);
    dialogo.mostrarCuadro();

    if (dialogo.muestraOpciones()) {
      btnSi.mostrar();
      btnNo.mostrar();
    } else {
      btnContinuar.mostrar();
    }
  }

  boolean manejarClick() {
    if (dialogo.muestraOpciones()) {
      if (btnSi.estaPresionado()) {
        if (dialogo.estado == 0) {
          dialogo.estado = 1;
          dialogo.paso = 0;
        } else if (dialogo.estado == 2) {
          dialogo.estado = 3;
          dialogo.paso = 0;
        }
      }
      if (btnNo.estaPresionado()) {
        if (dialogo.estado == 0) {
          dialogo.estado = 2;
          dialogo.paso = 0;
        } else if (dialogo.estado == 2) {
          dialogo.estado = 2;
          dialogo.paso = 0;
        }
      }
    } else {
      if (btnContinuar.estaPresionado()) {
        if ((dialogo.estado == 1 && dialogo.paso == 3) || (dialogo.estado == 3 && dialogo.paso == 5)) {
          return true;
        } else {
          dialogo.paso++;
        }
      }
    }

    return false;
  }
  public void reset() {
    dialogo.reset();
    // si querés, también podés recrear los botones en sus posiciones iniciales
    btnSi = new Boton(new PVector(120, height - 80), "SI");
    btnNo = new Boton(new PVector(240, height - 80), "NO");
    btnContinuar = new Boton(new PVector(width - 140, height - 80), "Continuar");
  }
}
