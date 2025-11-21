class Spawner {
  private ArrayList<Fruta> frutas;
  private int ultimaFruta;
  private int intervaloFruta;
  private int maxFrutas;

  public Spawner(int intervalo, int max) {
    frutas = new ArrayList<Fruta>();
    ultimaFruta = millis();
    intervaloFruta = intervalo;
    intervaloFruta = 2000;
    maxFrutas = max;
  }

  public void actualizar(float deltaTime, Venado venado) {
    for (int i = frutas.size() - 1; i >= 0; i--) {
      Fruta f = frutas.get(i);

      // 1) Colisiones y remoción SEGURA
      if (f instanceof Piedra) {
        if (f.hayColision(venado)) {
          venado.restarVida();
          frutas.remove(i);
          continue; // salir al siguiente índice
        }
      } else {
        if (f.hayColision(venado)) {
          venado.sumarPuntaje(f.valor);
          frutas.remove(i);
          continue; // salir al siguiente índice
        }
      }

      // 2) Si no hubo colisión, recién dibujamos/actualizamos
      f.dibujar();
      f.caer(deltaTime);
    }

    // 3) Generar nuevas frutas
    if (millis() - ultimaFruta > intervaloFruta && frutas.size() < maxFrutas) {
      generarFruta();
      ultimaFruta = millis();
    }
  }


  private void generarFruta() {
    PVector pos = new PVector(random(50, width - 50), 0);
    PVector vel = new PVector(0, 0);
    Fruta nueva;

    int tipo = int(random(6));
    switch(tipo) {
    case 0:
      nueva = new Manzana(pos, vel);
      break;
    case 1:
      nueva = new Banana(pos, vel);
      break;
    case 2:
      nueva = new Frutilla(pos, vel);
      break;
    case 3:
      nueva = new Naranja(pos, vel);
      break;
    case 4:
      nueva = new Sandia(pos, vel);
      break;
    default:
      nueva = new Piedra(pos, vel);
      break;
    }

    frutas.add(nueva);
  }
  public void reset() {
    frutas.clear();
    ultimaFruta = millis();
  }
}
