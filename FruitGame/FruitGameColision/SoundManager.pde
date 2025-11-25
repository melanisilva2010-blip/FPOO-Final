import processing.sound.* ;

class SoundManager {
  private SoundFile backSoundGame;
  private SoundFile backMenu;

  public SoundManager(PApplet app) {
    backSoundGame = new SoundFile(app, "pixelParadise.mp3");
    backMenu = new SoundFile(app, "pixelLove.mp3");
  }

  public void playGame() {
    if (!backSoundGame.isPlaying()) {
      stopAll();
      backSoundGame.loop(); // 👈 loop en lugar de play
    }
  }

  public void playMenu() {
    if (!backMenu.isPlaying()) {
      stopAll();
      backMenu.loop(); // 👈 loop en lugar de play
    }
  }

  void stopAll() {
    if (backMenu.isPlaying()) backMenu.stop();
    if (backSoundGame.isPlaying()) backSoundGame.stop();
  }
}
