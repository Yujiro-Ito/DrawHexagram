import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim _minim;
AudioPlayer _bgm;
AudioPlayer _se;
Game _theGame;

void setup(){
  size(700, 700);
  noCursor();
  _minim = new Minim(this);
  _theGame = new Game();
}

void draw(){
  _theGame.update();
}

//bgmを再生するメソッド
void playMusic_bgm(String name){
  //_minim.stop();
  if(_bgm != null) _bgm.close();
  _bgm = _minim.loadFile(name);
  _bgm.loop();
}

//bgmをストップするメソッド
void stopBgm(){
  _bgm.close();
}

//seを再生するメソッド
void playMusic_se(String name){
  //_minim.stop();
  if(_se != null) _se.close();
  _se = _minim.loadFile(name);
  _se.play();
}
