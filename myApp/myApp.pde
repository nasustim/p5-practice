//一軸傾き 3D表示

MonoStick mono;

void setup()
{
    size(640, 480);
    frameRate(60);
    background(255);
    mono = new MonoStick(this);
    mono.debugMode = true;
    
    for(int i=10;i>=0;i++){
      fill(0);
      textSize(36);
      text(str(i)+"秒前",100,100);
      delay(1000);
      background(255);
    }
}

void draw()
{
    background(255);
    
    mono.update();

    //Twelite twe = mono.getTwelite("10f249c");
    Twelite twe = mono.getTwelite("10f2448");
    if (twe == null)
    {
        return;
    }
    
    int spd = twe.getSpeed();
    
    
}