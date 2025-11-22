class Spawner {
  private ArrayList<Fruta> frutas;
  private int ultimaFruta;
  private int intervaloFruta;
  private int maxFrutas;
  
  // Variable que decide qué tan seguido salen las piedras (0 a 100)
  private float probabilidadPiedra; 

  public Spawner(int intervalo, int max) {
    frutas = new ArrayList<Fruta>();
    ultimaFruta = millis();
    intervaloFruta = intervalo; 
    maxFrutas = max;
    
    // --- CONFIGURACIÓN AUTOMÁTICA DE DIFICULTAD ---
    // Detectamos en qué nivel estamos basándonos en la velocidad (intervalo)
    
    if (intervalo >= 3000) { 
      // TUTORIAL (Lento): Solo 10% de chance de piedras. Casi puras frutas.
      probabilidadPiedra = 10; 
    } 
    else if (intervalo >= 1500) {
      // NIVEL 1 (Medio): 30% de chance de piedras.
      probabilidadPiedra = 30; 
    } 
    else {
      // NIVEL 2 (Rápido): 45% de chance de piedras. ¡Más difícil!
      probabilidadPiedra = 45; 
    }
  }

  public void actualizar(float deltaTime, Venado venado) {
    for (int i = frutas.size() - 1; i >= 0; i--) {
      Fruta f = frutas.get(i);

      // 1) Lógica de Colisión (Sin cambios)
      if (f instanceof Piedra) {
        if (f.hayColision(venado)) {
          venado.restarVida();
          frutas.remove(i);
          continue; 
        }
      } else {
        if (f.hayColision(venado)) {
          venado.sumarPuntaje(f.valor);
          frutas.remove(i);
          continue; 
        }
      }
      
      // (Eliminé la línea de f.pos que daba error)
      
      // 2) Dibujar y Caer
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
    // Posición aleatoria
    PVector pos = new PVector(random(50, width - 50), -50); 
    PVector vel = new PVector(0, 0); 
    Fruta nueva;

    // --- SISTEMA DE PROBABILIDAD ---
    float dado = random(100); // Tiramos un dado del 0 al 100

    // 1. ¿Sale Piedra? (Depende del nivel)
    if (dado < probabilidadPiedra) {
       nueva = new Piedra(pos, vel);
    } 
    // 2. Si no es piedra, ¿Qué fruta sale?
    else {
       // Elegimos aleatoriamente entre las 5 frutas disponibles
       // Esto mantiene la variedad de frutas intacta
       int tipoFruta = int(random(5)); 
       
       switch(tipoFruta) {
         case 0: nueva = new Manzana(pos, vel); break;
         case 1: nueva = new Banana(pos, vel); break;
         case 2: nueva = new Frutilla(pos, vel); break;
         case 3: nueva = new Naranja(pos, vel); break;
         default: nueva = new Sandia(pos, vel); break;
       }
    }

    frutas.add(nueva);
  }

  public void reset() {
    frutas.clear();
    ultimaFruta = millis();
  }
}
