abstract class BaseCharacter{
  protected Game _theGame;
  protected PVector _position;
  
  //コンストラクタ
  public BaseCharacter(Game game, float x, float y){
    _theGame = game;
    _position = new PVector(x, y);
  }
  
  //更新処理の抽象メソッド
  public abstract void update();
  
  //描画処理の抽象メソッド
  public abstract void draw();
}
