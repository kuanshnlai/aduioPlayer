//real work
class Texter{
  int _x;
  int _y;
  int _time;
  String _msg;
  Texter(int x,int y,int time){
    _x = x;
    _y = y;
    _time = time;
    _msg = " ";
  }
  void showMsg(){
    textSize(30);
    if(_time<=0){
      text(" ",_x,_y);  
    }
    else{
      text(_msg,_x,_y);
    }
  }
  void setMsg(String msg){
    _msg = msg;
  }
  void decTime(){
    _time--;
  }
  void resetTime(int time){
    _time = time;
  }
  
}
class Action{
  int _x;
  int _y;
  Button _btn;
  boolean _disable;
  Button _other[];
  String _mes;
  Texter _texter;
  Action(String s,int x,int y,Button b,boolean disable,Texter texter){
    _x = x;
    _y = y;
    _btn = b;
    _disable = disable;
    _mes = s;
    _texter = texter;

  }
  Action(String s,int x,int y,Button b,boolean disable,Button affectButton[],Texter texter){
    _x = x;
    _y = y;
    _btn = b;
    _disable = disable;
    _mes = s;
    _other = affectButton;
    _texter = texter;

  }
  void exec(){
    _texter.resetTime(300);
    _texter.setMsg(_mes);
    if(_disable){
      _btn.disable();
    }
    if(_other!=null){
      for(int i=0;i<_other.length;i++){
        //println(_other[i]);
         _other[i].enable();  
      }
    }
  }
}

class Button{
  private int _x;
  private int _y;
  private int _w;
  private int _h;
  private PImage _normal_image;
  private PImage _hovered_image;
  private PImage _disabled_image;
  private boolean _clicked; 
  private boolean _hovered;
  private boolean _status;
  Action _action;
  /*----------------------------*/
  Button(int x,int y,int w,int h,boolean status){
    _x = x;
    _y = y;
    _w = w;
    _h = h;
    _clicked = false;
    _hovered = false;
    _status = status;
  }
  Button(int x,int y,int w,int h,boolean status,String normalFN,String hoverFN,String disabledFN){
    _x = x;
    _y = y;
    _w = w;
    _h = h;
    _normal_image = loadImage(normalFN);
    _hovered_image = loadImage(hoverFN);
    _disabled_image = loadImage(disabledFN);
    _clicked = false;
    _hovered = false;
    _status = status;
    
  }
  void addAction(Action action){
    _action = action;  
  }
  void show(){
    if(!_status){
      image(_disabled_image,_x,_y,_w,_h); 
    }
    //else if(_clicked){
    //  image(_disabled_image,_x,_y,_w,_h);  
    //}
    else if(_hovered){
      image(_hovered_image,_x,_y,_w,_h);
    }
    else{
      image(_normal_image,_x,_y,_w,_h);  
    }
  }
  boolean isClick(){
    if(!_status){
      return false;
    }
    if(mouseX <= _x +_w && mouseX >= _x && mouseY <= _y + _h && mouseY >= _y){
      _clicked = true;  
      _action.exec();
    }
    else{
      _clicked = false;
    }
    return _clicked;
  }
  void disable(){
    _status = false;  
  }
  void enable(){
    _status = true;  
  }
  boolean isHovered(){
    if(!_status){
      return false;
    }
    if(mouseX <= _x +_w && mouseX >= _x && mouseY <= _y + _h && mouseY >= _y){
      _hovered = true;  
    }
    else{
      _hovered = false;
    }
    return _hovered;
  }
}
/*
class Bar{
  int x;
  int y;
  int w;
  int h;
  int bx;
  int by;
  int bw;
  int bh;
  
  
}
*/


Button play;
Button pause;
Button stop;
Button replay;
Button forward;
Button rewind;
Button volume;
Button volumeUp;
Button volumeDown;
Texter texter;
ArrayList<Button> buttonList = new ArrayList<Button>();
void setup(){
 size(1024,800);
 texter = new Texter(50,50,300);
 play = new Button(500,750,32,32,true,"play_normal.png","play_hovered.png","play_disabled.png");
 pause = new Button(540,750,32,32,true,"pause_normal.png","pause_hovered.png","pause_disabled.png");
 stop = new Button(580,750,32,32,true,"stop_normal.png","stop_hovered.png","stop_disabled.png");
 forward = new Button(620,750,32,32,true,"forward_normal.png","forward_hovered.png","forward_disabled.png");
 rewind = new Button(460,750,32,32,true,"rewind_normal.png","rewind_hovered.png","rewind_disabled.png");
 volume = new Button(420,750,32,32,true,"volume_normal.png","volume_hovered.png","volume_normal.png");
 volumeUp = new Button(380,750,32,32,true,"volume_up_normal.png","volume_up_hovered.png","volume_up_normal.png");
 volumeDown = new Button(340,750,32,32,true,"volume_down_normal.png","volume_down_hovered.png","volume_down_normal.png");
 replay = new Button(300,750,32,32,true,"replay_normal.png","replay_hovered.png","replay_normal.png");
 Button temp[] = {pause,stop};
 Button temp1[] = {play};
 Button temp2[] = {play,pause};
 play.addAction(new Action("PLAY",50,50,play,true,temp,texter));
 pause.addAction(new Action("Pause",50,50,pause,true,temp1,texter));
 stop.addAction(new Action("stop",50,50,stop,false,temp2,texter));
 forward.addAction(new Action("forward",50,50,forward,false,texter));
 volume.addAction(new Action("volume",50,50,volume,false,texter));
 volumeUp.addAction(new Action("volume+",50,50,volumeUp,false,texter));
 volumeDown.addAction(new Action("volume-",50,50,volumeDown,false,texter));
 replay.addAction(new Action("replay",50,50,replay,false,texter));
 rewind.addAction(new Action("rewind",50,50,rewind,false,texter));
 buttonList.add(play);
 buttonList.add(pause);
 buttonList.add(stop);
 buttonList.add(forward);
 buttonList.add(rewind);
 buttonList.add(replay);
 buttonList.add(volume);
 buttonList.add(volumeUp);
 buttonList.add(volumeDown);
}

void draw(){
  background(#a0a0a0);
  texter.showMsg();
  texter.decTime();
  for(Button b: buttonList){
    b.show();
    b.isHovered();
  }
}
void mousePressed(){
  for(Button b: buttonList){
    b.isClick();
  }
  
}
/*
//control processing bar

void setup(){
   size(600,300);  
}
boolean choose = false;
int posx = 0;
void draw(){
    background(#c0c0c0);
    fill(#0000ff);
    //line(0,275,posx,275);
    rect(0,270,posx,10);
    fill(#c0c0c0);
    rect(posx,270,width-posx,10);
    fill(#ffffff);
    circle(posx,275,20);
    //line(posx,275,width,275);
}
void mousePressed(){
  if(mouseX>=posx-10&&mouseX<=posx+10&&mouseY<=275+10&&mouseY>=275-10){
     choose = true; 
  }
  else{
     choose =false; 
  }
  if(mouseX>=0&&mouseX<=width&&mouseY<=270+10&&mouseY>=270){
    posx = mouseX;
  }
}
void mouseDragged(){
  if(choose){
    if(mouseX>width){
       posx = width; 
    }
    else if(mouseX<0){
       posx = 0;  
    }
    else{    
       posx = mouseX;
    }
  }

}

//volumn controller
void setup(){
  size(600,300);  
}
boolean showControlBar = false;
int posy = 0;
void draw(){
  background(#c0c0c0);
  rect(450,260,30,30); 
  if(showControlBar){
    rect(460,200,10,60);
    rect(455,200+posy,20,5);
  }
}
void mousePressed(){
  if(mouseX <= 450+30 && mouseX>=450 && mouseY<=260+30&& mouseY>=260){
    showControlBar = true;
  }
  else if(showControlBar && mouseX <= 455){
    
  }
  else{
    showControlBar = false;  
  }
}
*/
