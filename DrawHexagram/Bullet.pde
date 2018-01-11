class Bullet extends BaseCharacter{
  //-----Constatns-------
  
  
  //-----Fields-------
  private float _size;
  private float _speedX, _speedY;
  
  //コンストラクタ
  public Bullet(Game game, float x, float y, float speedX, float speedY, float size){
    //変数の初期化
    super(game, x, y);
    _size = size;
    _speedX = speedX;
    _speedY = speedY;
  }
  
  //更新処理
  public void update(){
    //当たり判定
    float dist = sqrt(sq(_theGame._player._position.x - _position.x) + sq(_theGame._player._position.y - _position.y));
    if(dist <= (_size + _theGame._player.getSize()) / 2){
      _theGame.gameOver();
    }
    
    //加速処理
    _position.x += _speedX;
    _position.y += _speedY;
    this.draw();
  }
  
  //描画処理
  public void draw(){
    noStroke();
    //自分自身の描画
    fill(255, 255, 100);
    ellipse(_position.x, _position.y, _size, _size);
  }
}
