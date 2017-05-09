MonoStick mono;   //センサのインスタンス
PImage mon;       //怪獣の画像
PImage shot;      //照準の画像
PImage shot_v;    //発射した時の照準の画像
PImage bang;      //怪獣に当たった時の画像
int sx=0,sy=0;    //照準の画像の左上の座標
final int h = 10; //照準の移動量の係数
int flag=0;       //ゲームの一連の流れの状態変数
float x = 0,y = 0;//怪獣の画像の左上の座標
int score = 0;    //点数

void setup(){
  size(640, 480);                    //ウィンドウサイズ 640x480
//  width = 640;                       //ウィンドウの幅
//  height = 480;                      //ウィンドウの高さ
  frameRate(60);                     //フレームレート
  background(255);                   //背景色 #ffffff
  mono = new MonoStick(this);        //MonoStickのインスタンス生成
  mono.debugMode = false;             //デバッグモード 本番はfalseにしておく
  
  /*イメージのロード*/
  mon = loadImage("monster.png");
  shot = loadImage("shot.png");
  shot_v = loadImage("shot_e.png");
  bang = loadImage("hit.png");
}

void draw(){
  background(255);

  mono.update();

  Twelite twe = mono.getTwelite("10f2448");
  if (twe == null){
    return;
  }
  
  if(flag == 0){              //最初に入る
    x = random(440);
    y = random(280);
    image(mon,x,y,200,200);
    flag++;                   //ウィンドウ幅に収まる乱数で怪獣の位置を決定、状態変数をインクリメント
  }else if(flag == 1){
    image(mon,x,y,200,200);   //状態変数==1 怪獣を表示し続ける
  }else if(flag == 2){        //状態変数==2 発射が入力された時に2になる
    /*照準の画像(100x100)が怪獣の画像(200x200)の範囲内に入っていれば*/
    if((-0<((sx+(width/2))-x))&&(((sx+(width/2))-x)<200)&&
        (-0<((sy+(height/2))-y))&&(((sy+(height/2))-y)<200)){
      image(bang,x,y,200,200);    //怪獣が消える(消える間際に衝撃のような絵が出る)
      score += 300;               //スコアを加点
      flag = 0;                   //状態変数を0に
    }else{    
      image(mon,x,y,200,200);
    }
  }
  
  /*センサのXY軸の傾きで照準を移動する*/
  sx = sx+(twe.getDegreeX()/h);
  sy = sy+(twe.getDegreeY()/h);
  
  /*照準がウィンドウからはみ出さないようにする処理*/
  sx = (sx<width/-2)?width/-2:((sx>width/2-100)?width/2-100:sx);
  sy = (sy<height/-2)?height/-2:((sy>height/2-100)?height/2-100:sy);
  
  /*加速度センサの速度が200以上だったら状態変数を2に
       (次のループで怪獣に当たっているかの判定に入る)*/
  if(200>twe.getSpeed()){
    image(shot,sx+((width/2)),sy+((height/2)));
  }else{
    image(shot_v,sx+((width/2)),sy+((height/2)));
    flag = 2;
  }
  
  /*その時点でのスコアを表示*/
  text("SCORE: "+score,10,450);
  fill(0,0,0);
}