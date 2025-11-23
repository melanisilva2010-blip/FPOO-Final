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
    
    // --- AJUSTE DE DIFICULTAD ---
    
    // TUTORIAL (Muy lento: 4000ms o más)
    if (intervalo >= 4000) { 
      probabilidadPiedra = 5; // 5% Piedras (Casi nada)
    } 
    // NIVEL 1 (Medio: entre 2500ms y 4000ms)
    else if (intervalo >= 2500) {
      probabilidadPiedra = 30; // 30% Piedras (¡Ahora salen más!)
    } 
    // NIVEL 2 (Rápido: menos de 2500ms)
    else {
      probabilidadPiedra = 45; // 45% Piedras (Difícil)
    }
    
    println("Spawner cargado. Intervalo: " + intervalo + "ms | Chance Piedra: " + probabilidadPiedra + "%");
  }

  public void actualizar(float deltaTime, Venado venado) {
    for (int i = frutas.size() - 1; i >= 0; i--) {
      Fruta f = frutas.get(i);

      // --- 1. LÓGICA DE COLISIÓN ---
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
    }

    // --- 3. GENERAR NUEVAS ---
    if (millis() - ultimaFruta > intervaloFruta) {
      generarFruta();
      ultimaFruta = millis();
    }
  }

  private void generarFruta() {
    PVector pos = new PVector(random(50, width - 50), -50); 
    PVector vel = new PVector(0, 0); 
    Fruta nueva;

    float dado = random(100); 

    if (dado < probabilidadPiedra) {
       // PIEDRA
       nueva = new Piedra(pos, vel);
    } 
    else {
       // FRUTA AL AZAR
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
