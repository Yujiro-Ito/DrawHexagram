class Player extends BaseCharacter{
  //-----Constants------
  public static final int POS_MAX = 10;
  public static final float PLAYER_SPEED = 3;
  public static final float HIT_RANGE = 2;
  
  //-----Fields------
  private float _size;
  private PVector[] _memoryPosition; 
  private int _suffix;
  private boolean _press;
  private float _speedX, _speedY;
  
  
  public Player(Game game, float x, float y, float size){
    //変数の初期化
    super(game, y, x);
    _size = size;
    _press = false;
    _speedX = 0;
    _speedY = 0;
    
    //配列の準備
    _suffix = 0;
    _memoryPosition = new PVector[POS_MAX];
    for(int i = 0; i < _memoryPosition.length; i++){
      _memoryPosition[i] = null;
    }
    
    
    float range = sqrt(sq(y - height / 2));
    float dx = cos(radians(45)) * range / 2;
    float dy = sin(radians(45)) * range / 2;
    _memoryPosition[0] = new PVector(dx, dy);
    _suffix++;
    _memoryPosition[1] = new PVector(x, y);
    _suffix++;
  }
  
  public void update(){
    //添え字が配列の最大値より小さい場合
    if(_suffix < POS_MAX){
      //プレイヤーの位置、又は前の点の位置からマウスの位置までラインを引く
      color lineColor = color(0, 255, 0, 100);
      if(_suffix == 0){
        this.drawLine(mouseX, mouseY, _position.x, _position.y, lineColor);
      } else {
        PVector pos = _memoryPosition[_suffix - 1];
        this.drawLine(mouseX, mouseY, pos.x, pos.y, lineColor);
      }
      
      //マウス判定
      if(mousePressed && _theGame.getStart()){
        if(_press == false){
          _press = true;
        }
      } else {
        if(_press){
          _memoryPosition[_suffix] = new PVector(mouseX, mouseY);
          _suffix++;
          _press = false;
        }
      }
    }
    
    //線路上を走る
    if(_memoryPosition[0] != null){
      PVector target = _memoryPosition[0];
      float rad = atan2(target.y - _position.y, target.x - _position.x);
      
      _speedX = cos(rad) * PLAYER_SPEED;
      _speedY = sin(rad) * PLAYER_SPEED;
    } else {
      _speedX = 0;
      _speedY = 0;
    }
    
    //あたり判定を行って、次の標的座標を変える
    if(_memoryPosition[0] != null){
      PVector target = _memoryPosition[0];
      float dist = sqrt(sq(target.x - _position.x) + sq(target.y - _position.y));
      if(dist <= HIT_RANGE){
        adjustArray();
      }
    }
    
    //配列の中の数値を見て線を引く
    color beforeLineColor = color(0, 255, 0);
    for(int i = 0; i < _memoryPosition.length; i++){
      if(i == 0 && _memoryPosition[i] != null){
        PVector pos = _memoryPosition[0];
        drawLine(_position.x, _position.y, pos.x, pos.y, beforeLineColor); 
      } else if(_memoryPosition[i] != null && _memoryPosition[i - 1] != null){
        PVector beforePos = _memoryPosition[i - 1];
        PVector nextPos = _memoryPosition[i];
        drawLine(beforePos.x, beforePos.y, nextPos.x, nextPos.y, beforeLineColor);
      }
    }
    
    _position.x += _speedX;
    _position.y += _speedY;
    this.draw();
  }
  
  //線を描くメソッド
  private void drawLine(float bx, float by, float nx, float ny, color col){
    stroke(col);
    strokeWeight(5);
    line(bx, by, nx, ny);
    stroke(0);
    strokeWeight(1);
  }
  
  //自分自身を描画する
  public void draw(){
    noStroke();
    fill(255, 0, 0);
    ellipse(_position.x, _position.y, _size, _size);
  }
  
  //配列の中身を調節する
  public void adjustArray(){
    for(int i = 0; i < _memoryPosition.length - 1; i++){
      _memoryPosition[i] = _memoryPosition[i + 1];
    }
    _memoryPosition[_memoryPosition.length - 1] = null;
    _suffix -= 1;
  }
  
  //サイズのゲッター
  public float getSize(){
    return _size;
  }
}
