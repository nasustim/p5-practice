MonoStick mono;
PImage mon;
PImage shot;
PImage shot_e;
PImage hit;
int sx=0,sy=0;
final int h = 10;
int flag=0;
float x = 0,y = 0;
int score = 0;

void setup()
{
  size(640, 480);
  width = 640;
  height = 480;
  frameRate(60);
  background(255);
  mono = new MonoStick(this);
  mono.debugMode = true;
  
  mon = loadImage("monster.png");
  shot = loadImage("shot.png");
  shot_e = loadImage("shot_e.png");
  hit = loadImage("hit.png");

}

void draw()
{
  background(255);

  mono.update();

  Twelite twe = mono.getTwelite("10f2448");
  if (twe == null)
  {
    return;
  }
  
  if(flag == 0){
    x = random(440);
    y = random(280);
    image(mon,x,y,200,200);
    flag++;
  }else if(flag == 1){
    image(mon,x,y,200,200);
  }else if(flag == 2){
    if((-0<((sx+(width/2))-x))&&(((sx+(width/2))-x)<200)&&
        (-0<((sy+(height/2))-y))&&(((sy+(height/2))-y)<200)){
      image(hit,x,y,200,200);
      score += 300;
      flag = 0;
    }else{    
      image(mon,x,y,200,200);
    }
  }
  
  sx = sx+(twe.getDegreeX()/h);
  sy = sy+(twe.getDegreeY()/h);
  
  sx = (sx<width/-2)?width/-2:((sx>width/2-100)?width/2-100:sx);
  sy = (sy<height/-2)?height/-2:((sy>height/2-100)?height/2-100:sy);
  if(300>twe.getSpeed()){
    image(shot,sx+((width/2)),sy+((height/2)));
  }else{
    image(shot_e,sx+((width/2)),sy+((height/2)));
    flag = 2;
  }
  
  text("SCORE: "+score,10,450);
}