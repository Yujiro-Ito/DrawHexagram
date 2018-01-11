class Hexagram extends BaseCharacter{
  //-----Constants------
  public static final int HEX_MAX = 6;
  public static final int LINE_WEIGHT = 10;
  public static final int TEXT_SIZE = 30;
  
  //----Fields----
  private float _size;
  private int _num;
  private int _rand;
  private boolean _hit;
  private int _partner;
  private color _myColor;
  
  //コンストラクタ
  public Hexagram(Game game, float x, float y, float size, int num, int rand){
    //変数の初期化
    super(game, x, y);
    _size = size;
    _num = num;
    _rand = rand;
    _hit = false;
    _partner = num - 2;
    if(_partner < 0){
      _partner = HEX_MAX + _partner;
    }
    _myColor = color(0);
  }
  
  //更新処理
  public void update(){
    //自分とプレイヤーのあたり判定処理
    float dist = sqrt(sq(_theGame._player._position.x - _position.x) + sq(_theGame._player._position.y - _position.y));
    if(dist <= (_theGame._player.getSize() + _size) / 2 && _rand == _theGame.getHexagramNumber()){
      _hit = true;
      _theGame.hitHexagram();
      playMusic_se("hitTwo.mp3");
    }
    
    //自分のプレイヤーとのあたり判定がtrueだったら色を変える
    if(_hit){
      _myColor = color(255, 0, 255);
    } else {
      _myColor = color(255, 0, 255, 50);
    }
    
    
    this.draw();
  }
  
  //描画処理
  public void draw(){
    //パートナーとなる点のオブジェクトのプレイヤーとのあたり判定を取得して、trueだったらラインを引く
    if(_theGame._hexagrams[_partner].getHit()){
      stroke(255, 0, 255);
      strokeWeight(LINE_WEIGHT);
      line(_theGame._hexagrams[_partner]._position.x, _theGame._hexagrams[_partner]._position.y, _position.x, _position.y);
    }
    
    //四角を表示
    noStroke();
    rectMode(CENTER);
    fill(_myColor);
    rect(_position.x, _position.y, _size, _size);
  }
  
  //あたり判定のブール値のゲッター
  public boolean getHit(){
    return _hit;
  }
  
  //自分の持っているランダムナンバーを表示するメソッド
  public void drawNumber(){
    fill(255);
    textSize(TEXT_SIZE);
    text(_rand + 1, _position.x, _position.y);
  }
}
