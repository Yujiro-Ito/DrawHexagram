class Boss extends BaseCharacter{
  
  //----Constatns------
  public static final float ADD_SIZE = 0.12;
  public static final float BULLET_INTERVAL = 10;
  public static final float BULLET_SPEED = 0.07;
  public static final float ADD_SIZE_MAX = 10;
  public static final int BULLET_NUM = 3;
  public static final float MINUS_ALPHA = 1;
  
  
  //----Fields-------
  private float _size;
  private float _originSize;
  private float _rad;
  private float _dx, _dy;
  private float _bulletNum;
  private int _bulletFrame;
  private float _alpha;
  private boolean _finish;
  private boolean _explosion;
 
 //コンストラクタ
  public Boss(Game game, float x, float y, float size){
    //変数の初期化
    super(game, x, y);
    _size = size;
    _originSize = size;
    _rad = 0;
    _bulletNum = BULLET_NUM;
    _bulletFrame = 0;
    _dx = 0;
    _dy = 0;
    _alpha = 255;
    _finish = false;
    _explosion = false;
  }
  
  //更新処理
  public void update(){
    //プレイヤーと自分の角度計算
    _rad = atan2(_theGame._player._position.y - _position.y, _theGame._player._position.x - _position.x);
    _dx = cos(_rad) * _size;
    _dy = sin(_rad) * _size;
    
    //ゲームの終了判定がfalseだったら処理をする
    if(_finish == false){
      if(_theGame.getStart()){
        _size += ADD_SIZE;
        if(_size - _originSize >= ADD_SIZE_MAX){
          _bulletNum = BULLET_NUM;
          _size = _originSize;
        }
      }
      
      //球をうつ
      this.gunShot();
    }
    
    this.draw();
  }
  
  //描画処理
  public void draw(){
    noStroke();
    //バレルの表示
    fill(100, 100, 255, _alpha);
    translate(width / 2, height / 2);
    rotate(_rad - radians(90));
    rectMode(CENTER);
    rect(0, _size / 2, 20, 100);
    rotate(-_rad + radians(90));
    translate(-width / 2, -height / 2);
    
    //ボスの描画
    fill(0, 0, 255, _alpha);
    ellipse(width / 2, height / 2, _size, _size);
  }
  
  //弾を撃つ処理
  public void gunShot(){
    //弾の残段数を調べて、それ以上だったら弾を撃つ
    if(_bulletNum > 0){
      _bulletFrame++;
      if(_bulletFrame >= BULLET_INTERVAL){
        _bulletFrame = 0;
        _theGame.instanceBullet(width / 2 + _dx, height / 2 + _dy, _dx * BULLET_SPEED, _dy * BULLET_SPEED);
        _bulletNum--;
      }
    } else {
      _bulletFrame = 0;
    }
    
  }
  
  //消滅処理
  public boolean disAppear(){
    //消滅処理
    _finish = true;
    boolean _result = false;
    _alpha -= MINUS_ALPHA;
    println(_alpha);
    if(_alpha <= 0){
      _result = true;
    }
    
    //se再生
    if(_explosion == false){
      playMusic_se("exprosion.mp3");
      _explosion = true;
      //stopBgm();
    }
    
    return _result;
  }
}
