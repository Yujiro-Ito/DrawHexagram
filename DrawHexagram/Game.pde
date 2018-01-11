class Game{
  //-----constants-------
  public static final int TITLE_SCENE = 0;
  public static final int GAME_SCENE = 1;
  public static final int OVER_SCENE = 2;
  public static final int CLEAR_SCENE = 3;
  
  
  //-----allSceneFields--------
  private int _sceneState;
  private boolean _press;
  
  //-----gameSceneConstants------
  public static final int PLAYER_SIZE = 30;
  public static final int BOSS_SIZE = 120;
  public static final int BULLET_MAX = 20;
  public static final int BULLET_SIZE = 10;
  public static final int HEXA_MAX = 6;
  public static final int HEXA_SIZE = 30;
  public static final int HEXA_RAD = 60;
  public static final int HEXA_RANGE = 220;
  public static final int SHAKE_RANGE = 5;
  public static final int GAME_TIME = 30;
  public static final int OVER_INTERVAL = 60;
  public static final int GAME_PRE_TIME = 3;
  
  //-----gameSceneFields-------
  public Player _player;
  public Boss _boss;
  public Bullet[] _bullets;
  public Hexagram[] _hexagrams;
  private int _suffix;
  private int[] _hexagramRandom;
  private int _hexagramNumber;
  private boolean _rightShake;
  private int _time;
  private float _frameCounter;
  private int _preTime;
  private boolean _startJudge;
  private int _overFrameCounter;
  
  //コンストラクタ
  public Game(){
    _sceneState = TITLE_SCENE;
    _press = false;
    //playMusic_bgm("title.mp3");
  }
  
  //更新処理
  public void update(){
    //状態を判断して、出力するシーンを変更
    switch(_sceneState){
    case TITLE_SCENE:
      this.playTitleScene();
      break;
    case GAME_SCENE:
      this.playGameScene();
      break;
    case OVER_SCENE:
      this.playOverScene();
      break;
    case CLEAR_SCENE:
      this.playClearScene();
      break;
    }
    //マウスカーソルを変更
    noCursor();
    fill(100, 255, 255);
    ellipse(mouseX, mouseY, 15, 15);
  }
  
  //タイトルシーンの更新処理
  public void playTitleScene(){
    background(0);
    
    //textの表示
    textAlign(CENTER);
    fill(0, 255, 0);
    textSize(60);
    text("DRAW HEXAGRAM", width / 2, height / 2);
    textSize(30);
    text("Click go to GameScene", width / 2, height / 2 + 150);
    
    //ゲームシーンに移る処理
    if(mousePressed){
      _press = true;
    } else {
      if(_press){
        _press = false;
        _sceneState = GAME_SCENE;
        this.initializeGameScene();
      }
    }
  }
  
  //ゲームシーンの初期化メソッド
  public void initializeGameScene(){
    //インスタンス処理
    _player = new Player(this, width / 2, 50, PLAYER_SIZE);
    _boss = new Boss(this, width / 2, height / 2, BOSS_SIZE);
    
    //配列の初期化処理
    _bullets = new Bullet[BULLET_MAX];
    
    //変数の初期化
    _suffix = 0;
    instanceHexagram();
    _rightShake = false;
    _time = GAME_TIME;
    _preTime = GAME_PRE_TIME;
    _frameCounter = 0;
    _startJudge = false;
    
    //playMusic_bgm("bgm.mp3");
  }
  
  //ゲームシーンの更新メソッド
  public void playGameScene(){
    background(0);
    //キャラクターの更新処理
    _player.update();
    _boss.update();
    for(int i = 0; i < _bullets.length; i++){
      if(_bullets[i] != null){
        _bullets[i].update();
      }
    }
    for(int i = 0; i < _hexagrams.length; i++){
      _hexagrams[i].update();
    }
    
    //ヘキサグラムが持つランダム番号を表示
    for(int i = 0; i < _hexagrams.length; i++){
      _hexagrams[i].drawNumber();
    }
    
    //ゲームクリア判定
    boolean finish = true;
    for(int i = 0; i < _hexagrams.length; i++){
      if(_hexagrams[i].getHit() == false){
        finish = false;
        break;
      }
    }
    
    //pretimeの処理
    if(_startJudge == false){
      _frameCounter++;
      fill(255);
      textSize(200);
      text(_preTime, width / 2, height / 2);
      if(_frameCounter >= 60){
        _preTime--;
        _frameCounter = 0;
      }
      if(_preTime <= 0){
        _startJudge = true;
      }
    }
    //timeの処理
    if(finish == false && _startJudge){
      fill(255);
      textSize(20);
      text("TIME: " + _time, width - 150, 100);
      _frameCounter++;
    }
    if(_frameCounter >= 60){
      _frameCounter = 0;
      _time--;
    }
    if(_time <= 0){
      _sceneState = OVER_SCENE;
      //stopBgm();
      //playMusic_se("overTwo.mp3");
      _overFrameCounter = 0;
    }
    
    
    if(finish){
      //ボスが消滅したらクリアシーンへ遷移
      if(_boss.disAppear() == true){
        _sceneState = CLEAR_SCENE;
        //playMusic_se("clearTwo.mp3");
        if(_rightShake){
          translate(SHAKE_RANGE, 0);
        }
      } else {
        if(_rightShake){
          translate(SHAKE_RANGE, 0);
        } else {
          translate(-SHAKE_RANGE, 0);
        }
        _rightShake = !_rightShake;
      }
    }
  }
  
  //弾のインスタンス処理
  public void instanceBullet(float x, float y, float speedX, float speedY){
    _bullets[_suffix] = new Bullet(this, x, y, speedX, speedY, BULLET_SIZE);
    _suffix++;
    if(_suffix >= _bullets.length){
      _suffix =  0;
    }
  }
  
  //ヘキサグラムのインスタンス処理
  public void instanceHexagram(){
    //変数、配列の初期化
    _hexagrams = new Hexagram[HEXA_MAX];
    _hexagramRandom = new int[HEXA_MAX];
    _hexagramNumber = 0;
    
    //ヘキサグラムが持つ数値配列の初期化
    for(int i = 0; i < HEXA_MAX; i++){
      _hexagramRandom[i] = i;
    }
    
    //ランダム数値配列をシャッフルする。
    for(int i = 0; i < _hexagramRandom.length; i++){
      int _rand = (int)random(HEXA_MAX);
      int tmp = _hexagramRandom[i];
      _hexagramRandom[i] = _hexagramRandom[_rand];
      _hexagramRandom[_rand] = tmp;
    }
    
    //ヘキサグラムをオブジェクト化
    for(int i = 0; i < _hexagrams.length; i++){
      float dx = cos(radians(i * HEXA_RAD - 90)) * HEXA_RANGE;
      float dy = sin(radians(i * HEXA_RAD - 90)) * HEXA_RANGE;
      _hexagrams[i] = new Hexagram(this, width / 2 + dx, height / 2 + dy, HEXA_SIZE, i, _hexagramRandom[i]);
    }
  }
  
  //ヘキサグラムナンバーを返す（ランダムナンバーと照合させる）
  public int getHexagramNumber(){
    return _hexagramNumber;
  }
  
  //プレイヤーとヘキサグラムが当たったとき、呼ばれる
  public void hitHexagram(){
    _hexagramNumber++;
  }
  
  //スタートしているかのブール値のゲッター
  public boolean getStart(){
    return _startJudge;
  }
  
  //ゲームオーバーに遷移
  public void gameOver(){
    _sceneState = OVER_SCENE;
    //playMusic_se("overTwo.mp3");
    //stopBgm();
    _overFrameCounter = 0;
  }
  
  //オーバーシーンの更新処理
  public void playOverScene(){
    //テキストの表示
    background(0);
    textSize(50);
    textAlign(CENTER);
    fill(255, 0, 0);
    text("GameOver", width / 2, height / 2);
    
    //マウスクリックするとタイトルシーンに遷移する処理
    _overFrameCounter++;
    if(_overFrameCounter >= OVER_INTERVAL){
      if(mousePressed){
        _press = true;
      } else {
        if(_press){
          _press = false;
          _sceneState = TITLE_SCENE;
          this.initializeGameScene();
          //playMusic_bgm("title.mp3");
        }
      }
    }
  }
  
  //クリアシーンの更新処理
  public void playClearScene(){
    //テキストの表示
    background(0);
    textSize(50);
    textAlign(CENTER);
    fill(100, 100, 255);
    text("GameClear", width / 2, height / 2);
    
    //一定の時間経ったあとに、マウスクリックするとタイトルシーンに遷移する処理
    if(mousePressed){
      _press = true;
    } else {
      if(_press){
        _press = false;
        _sceneState = TITLE_SCENE;
        this.initializeGameScene();
        //playMusic_bgm("title.mp3");
      }
    }
  }
}
