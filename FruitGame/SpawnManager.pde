class SpawnManager {
  // Pesos base (ajusta a gusto)
  float baseManzana  = 25;
  float baseBanana   = 20;
  float baseFrutilla = 20;
  float baseNaranja  = 20;
  float baseSandia   = 5;   // rara por defecto
  float basePiedra   = 15;  // aumentada para asegurar aparición

  // Parámetros de escalado por puntaje
  float sandiaClampMin = 0.05f;    // mínimo 5% del peso base
  float sandiaScaleDiv = 1200.0f;  // mayor = reducción más lenta
  float piedraIncreasePerScore = 0.002f; // piedra aumenta muy levemente con score

  // Probabilidad mínima absoluta (evita que un tipo llegue a 0)
  float minProbFraction = 0.01f; // 1% mínimo del total

  // Crear fruta según pesos dinámicos
  Fruta spawn(int score) {
    PVector pos = new PVector();
    PVector vel = new PVector();

    float wManzana  = baseManzana;
    float wBanana   = baseBanana;
    float wFrutilla = baseFrutilla;
    float wNaranja  = baseNaranja;

    // sandía: menos probable con más puntaje
    float sandiaMultiplier = 1.0f - (score / sandiaScaleDiv);
    if (sandiaMultiplier < sandiaClampMin) sandiaMultiplier = sandiaClampMin;
    float wSandia = baseSandia * sandiaMultiplier;

    // piedra: un poco más probable con más puntaje
    float wPiedra = basePiedra + (score * piedraIncreasePerScore);

    // tope para piedra (evita dominancia)
    wPiedra = min(wPiedra, basePiedra * 3.0f); // tope 3x base

    // evitar negativos
    wManzana  = max(0, wManzana);
    wBanana   = max(0, wBanana);
    wFrutilla = max(0, wFrutilla);
    wNaranja  = max(0, wNaranja);
    wSandia   = max(0, wSandia);
    wPiedra   = max(0, wPiedra);

    // asegurar probabilidad mínima por tipo
    float total = wManzana + wBanana + wFrutilla + wNaranja + wSandia + wPiedra;
    float minAbs = total * minProbFraction;
    if (wManzana < minAbs)  wManzana = minAbs;
    if (wBanana < minAbs)   wBanana  = minAbs;
    if (wFrutilla < minAbs) wFrutilla = minAbs;
    if (wNaranja < minAbs)  wNaranja = minAbs;
    if (wSandia < minAbs)   wSandia  = minAbs;
    if (wPiedra < minAbs)   wPiedra  = minAbs;

    // recalcular total y log para depuración
    total = wManzana + wBanana + wFrutilla + wNaranja + wSandia + wPiedra;
    println("Weights -> M:" + wManzana + " B:" + wBanana + " F:" + wFrutilla + " N:" + wNaranja + " S:" + wSandia + " P:" + wPiedra + " total:" + total);

    float r = random(total);
    // println("r = " + r); // opcional

    if (r < wManzana)  return new Manzana(pos, vel);
    r -= wManzana;
    if (r < wBanana)   return new Banana(pos, vel);
    r -= wBanana;
    if (r < wFrutilla) return new Frutilla(pos, vel);
    r -= wFrutilla;
    if (r < wNaranja)  return new Naranja(pos, vel);
    r -= wNaranja;
    if (r < wSandia)   return new Sandia(pos, vel);
    return new Piedra(pos, vel);
  }

  // Debug: simula n spawns y muestra frecuencias
  void debugDistribution(int score, int n) {
    HashMap<String, Integer> counts = new HashMap<String, Integer>();
    counts.put("Manzana", 0);
    counts.put("Banana", 0);
    counts.put("Frutilla", 0);
    counts.put("Naranja", 0);
    counts.put("Sandia", 0);
    counts.put("Piedra", 0);
    for (int i = 0; i < n; i++) {
      Fruta f = spawn(score);
      String name = f.getClass().getSimpleName();
      counts.put(name, counts.get(name) + 1);
    }
    println("Spawn debug (score=" + score + ", n=" + n + "):");
    for (String k : counts.keySet()) {
      println(k + ": " + counts.get(k) + " (" + nf(100.0f * counts.get(k) / n, 0, 2) + "%)");
    }
  }
}
