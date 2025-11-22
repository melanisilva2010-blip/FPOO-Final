class Boton {
  PVector pos;
  String label;
  float w = 100, h = 40;

  Boton(PVector pos, String label) {
    this.pos = pos;
    this.label = label;
  }

  void mostrar() {
    boolean hover = mouseX > pos.x && mouseX < pos.x + w && mouseY > pos.y && mouseY < pos.y + h;
    fill(hover ? color(255, 230, 160) : color(255, 210, 120));
    stroke(60);
    rect(pos.x, pos.y, w, h, 8);
    fill(0);
    textAlign(CENTER, CENTER);
    text(label, pos.x + w/2, pos.y + h/2);
  }

  boolean estaPresionado() {
    return mouseX > pos.x && mouseX < pos.x + w && mouseY > pos.y && mouseY < pos.y + h;
  }
}
