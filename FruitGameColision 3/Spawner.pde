class Spawner {
  private ArrayList<Fruta> frutas;
  private int ultimaFruta;
  private int intervaloFruta;
  private int maxFrutas;
  
  // Variable de probabilidad (0 a 100)
  private float probabilidadPiedra; 

  public Spawner(int intervalo, int max) {
    frutas = new ArrayList<Fruta>();
    ultimaFruta = millis();
    intervaloFruta = intervalo; 
    maxFrutas = max;
    
    // --- AJUSTE DE DIFICULTAD EQUILIBRADO ---
    
    // TUTORIAL (Intervalo lento, 3000ms o más)
    if (intervalo >= 3000) { 
      probabilidadPiedra = 5; // 5% Piedras (Muy pocas)
    } 
    // NIVEL 1 / MEDIO (Intervalo entre 1500 y 3000)
    else if (intervalo >= 1500) {
      probabilidadPiedra = 20; // 20% Piedras (1 de cada 5 objetos)
    } 
    // NIVEL 2 / RÁPIDO (Intervalo menor a 1500)
    else {
      probabilidadPiedra = 35; // 35% Piedras (Salen más, pero siguen ganando las frutas)
    }
    
    // Mensaje en consola para verificar que cargó bien
    println("Spawner cargado. Intervalo: " + intervalo + " | Probabilidad Piedra: " + probabilidadPiedra + "%");
  }

  public void actualizar(float deltaTime, Venado venado) {
    for (int i = frutas.size() - 1; i >= 0; i--) {
      Fruta f = frutas.get(i);

      // --- 1. LÓGICA DE COLISIÓN (Sin cambios) ---
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
      
      // --- 2. DIBUJAR Y MOVER ---
      f.dibujar();
      f.caer(deltaTime);
      
      // (Aquí borré la línea "if (f.pos.y > ...)" para que no te de error nunca más)
    }

    // --- 3. GENERAR NUEVAS ---
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

    // --- DECISIÓN: ¿PIEDRA O FRUTA? ---
    float dado = random(100); 

    if (dado < probabilidadPiedra) {
       // Sale PIEDRA
       nueva = new Piedra(pos, vel);
    } 
    else {
       // Sale FRUTA (Elegimos una al azar para mantener variedad)
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
  public void dibujarCongelado() {
  for (Fruta f : frutas) {
    f.dibujar(); 
  }
}
  
}
