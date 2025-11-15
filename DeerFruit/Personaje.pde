class Personaje {
  
  // Sprites del personaje
  PImage imgDefault, imgHappy, imgSad, imgSurprised, imgSeriously;
  
  // Posición y tamaño
  float x, y, alto;

  Personaje(String prefijo, float x, float y, float alto) {
    this.x = x;
    this.y = y;
    this.alto = alto;
    
    // Carga sus propias imágenes basado en el prefijo (ej: "oso" o "deer")
    imgDefault = loadImage(prefijo + "_default.png");
    imgHappy = loadImage(prefijo + "_happy.png");
    imgSurprised = loadImage(prefijo + "_surprised.png");
    
    // Manejar casos especiales
    if (prefijo.equals("oso")) {
      imgSad = loadImage("oso_sad.png");
    } else if (prefijo.equals("deer")) {
      // Tu archivo se llamaba "seriusly", lo cargamos así
      imgSeriously = loadImage("deer_seriusly.png"); 
    }
  }

  // Dibuja el sprite correcto en su posición
  void dibujar(String emocion) {
    PImage imgParaMostrar = imgDefault; // Por defecto
    
    if (emocion.equals("happy")) {
      imgParaMostrar = imgHappy;
    } else if (emocion.equals("sad") && imgSad != null) {
      imgParaMostrar = imgSad;
    } else if (emocion.equals("surprised")) {
      imgParaMostrar = imgSurprised;
    } else if (emocion.equals("seriously") && imgSeriously != null) {
      imgParaMostrar = imgSeriously;
    }
    
    // Usar la función de utilidad para escalar
    dibujarEscalado(imgParaMostrar, x, y, alto);
  }
}
