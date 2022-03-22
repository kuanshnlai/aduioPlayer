/*
作業四: MP3播放器
學號: 40670115H
姓名: 賴冠勳
*/
import ddf.minim.*;

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
    fill(#ffffff);
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
  AudioPlayer _player;
  Action(String s,int x,int y,Button b,boolean disable,Texter texter,AudioPlayer player){
    _x = x;
    _y = y;
    _btn = b;
    _disable = disable;
    _mes = s;
    _texter = texter;
    _player = player;
  }
  Action(String s,int x,int y,Button b,boolean disable,Button affectButton[],Texter texter,AudioPlayer player){
    _x = x;
    _y = y;
    _btn = b;
    _disable = disable;
    _mes = s;
    _other = affectButton;
    _texter = texter;
    _player = player;
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
    switch(_btn._id){
      case "PLAY":
        println(1);
        _player.play();
        break;
      case "PAUSE":
        println(2);
        _player.pause();
        break;
      case "STOP":
        println(3);
        _player.pause();
        _player.cue(0);
        break;
      case "FORWARD":
        println(4);
        if(_player.position()+10000>=_player.length()){
          _player.cue(_player.length());
        }
        else{
          _player.cue(_player.position()+10000);
        }
        break;
      case "REWIND":
        _player.cue(_player.position()-10000);
        println(5);  
        break;
      case "VOLUME":
        _player.unmute(); 
        
        break;
      case "MUTE":
        _player.mute();
        println(6);
        break;
      case "VOLUME+":
        println(7);
        
        println(_player.getGain());
        _player.setGain(_player.getGain()+1.0);
        
        break;
      case "VOLUME-":
        _player.setGain(_player.getGain()-1.0);
        println(8);
        break;
      case "LOOP":
        println(9);
        _player.loop();
        break;
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
  String _id;
  /*----------------------------*/
  Button(String id,int x,int y,int w,int h,boolean status){
    _x = x;
    _y = y;
    _w = w;
    _h = h;
    _clicked = false;
    _hovered = false;
    _status = status;
    _id  = id;
  }
  Button(String id,int x,int y,int w,int h,boolean status,String normalFN,String hoverFN,String disabledFN){
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
    _id  = id;
  }
  void addAction(Action action){
    _action = action;  
  }
  void show(){
    if(!_status){
      image(_disabled_image,_x,_y,_w,_h); 
    }
    else if(_hovered){
      image(_hovered_image,_x,_y,_w,_h);
    }
    else{
      image(_normal_image,_x,_y,_w,_h);  
    }
  }
  void hide(color c){
    noStroke();
    fill(c);
    rect(_x,_y,_w,_h);
    
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

class Bar{
  int _x;
  int _y;
  int _w;
  int _h;
  AudioPlayer _player;
  boolean _choosen = false;
  boolean _changed = false;
  int _bx;
  int _by;
  int _bw;
  int _bh;
  Bar(int x,int y,int h,AudioPlayer player){
    _x = x;
    _y = y;
    _w = width;
    _h = h;
    _player = player;
    _bx = 0;
    _by = y-5;
    _bw = 5;
    _bh = h+10;
  }
  void show(){
    fill(#0000ff);
    rect(_x,_y,_bx-_x,_h);
    fill(#ffffff);
    rect(_bx,_y,_w,_h);
    fill(#f0f0f0);
    rect(_bx,_by,_bw,_bh);
  }
  void update(){
    if(_changed){
       float value = map(_bx,0,_w,0,_player.length());
       _player.cue(int(value));
       _changed = false;
    }
    float value = map(_player.position(),0,_player.length(),0,_w);
    _bx = (int)value;
  }
  void isDragging(){
    if(_choosen){
      if(mouseX>width){
         _bx = width; 
      }
       else if(mouseX<0){
       _bx = 0;  
      }
      else{    
       _bx = mouseX;
      }
      _changed = true;
    }
  }
  void isClick(){
     if(mouseX>=_x&&mouseX<=_x+_w&&mouseY<=_y+_h&&mouseY>=_y-_h){
       _bx = mouseX;
       float value = map(_bx,0,_w,0,_player.length());
       _player.cue(int(value));
     }
     if(mouseX>=_bx&&mouseX<=_bx+_bw&&mouseY<=_by+_bh&&mouseY>=_by-_bh){
       _choosen = true;
     }
     else{
       _choosen = false;
     }

  }
}



Button play;
Button pause;
Button stop;
Button loop;
Button forward;
Button rewind;
Button volume;
Button volumeUp;
Button volumeDown;
Button mute;
Texter texter;
ArrayList<Button> buttonList = new ArrayList<Button>();
Minim minim;
AudioPlayer player;
Bar bar;
PFont TCFont;
void setup(){
 size(1024,800);
 TCFont = createFont("NotoSansTC-Black.otf",32);
 textFont(TCFont);
 minim = new Minim(this);
 player = minim.loadFile("music1.mp3");
 bar = new Bar(0,700,10,player);
 texter = new Texter(50,50,300);
 play = new Button("PLAY",500,750,32,32,true,"play_normal.png","play_hovered.png","play_disabled.png");
 pause = new Button("PAUSE",540,750,32,32,true,"pause_normal.png","pause_hovered.png","pause_disabled.png");
 stop = new Button("STOP",580,750,32,32,true,"stop_normal.png","stop_hovered.png","stop_disabled.png");
 forward = new Button("FORWARD",620,750,32,32,true,"forward_normal.png","forward_hovered.png","forward_disabled.png");
 rewind = new Button("REWIND",460,750,32,32,true,"rewind_normal.png","rewind_hovered.png","rewind_disabled.png");
 volume = new Button("VOLUME",420,750,32,32,true,"volume_normal.png","volume_hovered.png","mute_normal.png");
 volumeUp = new Button("VOLUME+",380,750,32,32,true,"volume_up_normal.png","volume_up_hovered.png","volume_up_normal.png");
 volumeDown = new Button("VOLUME-",340,750,32,32,true,"volume_down_normal.png","volume_down_hovered.png","volume_down_normal.png");
 mute = new Button("MUTE",420,750,32,32,true,"mute_normal.png","mute_hovered.png","mute_normal.png");
 loop = new Button("LOOP",300,750,32,32,true,"loop_normal.png","loop_hovered.png","loop_normal.png");
 Button temp[] = {pause,stop};
 Button temp1[] = {play};
 Button temp2[] = {play,pause};
 play.addAction(new Action("PLAY",50,50,play,true,temp,texter,player));
 pause.addAction(new Action("Pause",50,50,pause,true,temp1,texter,player));
 stop.addAction(new Action("stop",50,50,stop,false,temp2,texter,player));
 forward.addAction(new Action("forward",50,50,forward,false,texter,player));
 volume.addAction(new Action("volume",50,50,volume,false,texter,player));
 volumeUp.addAction(new Action("volume+",50,50,volumeUp,false,texter,player));
 volumeDown.addAction(new Action("volume-",50,50,volumeDown,false,texter,player));
 loop.addAction(new Action("loop",50,50,loop,false,temp,texter,player));
 rewind.addAction(new Action("rewind",50,50,rewind,false,texter,player));
 mute.addAction(new Action("mute",50,50,mute,false,texter,player));
 buttonList.add(play);
 buttonList.add(pause);
 buttonList.add(stop);
 buttonList.add(forward);
 buttonList.add(rewind);
 buttonList.add(loop);
 buttonList.add(volume);
 buttonList.add(volumeUp);
 buttonList.add(volumeDown);
 buttonList.add(mute);
}

void draw(){
  background(#a0a0a0);
  fill(#ffffff);
  text("40670115H 賴冠勳 播放器",600,30);
  bar.show();
  for(Button b: buttonList){
    b.show();
    b.isHovered();
  }
  for(int i = 0; i < player.bufferSize() - 1; i++)
  { 
    
    float x1 = map( i, 0, player.bufferSize(), 0, width );
    float x2 = map( i+1, 0, player.bufferSize(), 0, width );
    stroke(#000000);
    line( x1, 250 + player.left.get(i)*50, x2, 50 + player.left.get(i+1)*50 );
    line( x1, 650 + player.right.get(i)*50, x2, 150 + player.right.get(i+1)*50 );
  }
  if(player.isPlaying()){
    play.disable();  
  }
  else{
    play.enable();  
  }
  if(player.isMuted()){
    mute.disable();
    mute.hide(g.backgroundColor);
    volume.enable();
    volume.show();
  }
  else{
    volume.disable();
    volume.hide(g.backgroundColor);
    mute.enable();
    mute.show();
  }
  texter.showMsg();
  texter.decTime();
  bar.update();
}
void mousePressed(){
  for(Button b: buttonList){
    b.isClick();
  }
  bar.isClick();
}
void mouseDragged(){
  bar.isDragging();

}
/*
//control processing bar
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

*/
