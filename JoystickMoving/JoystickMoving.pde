import processing.serial.*;


rectangle rec;
joystick joy;
Serial port;
PVector v1, v2, result;

int speed=5;
int Xval, Yval;
float Speedx, Speedy=0;
float JoyPosX, JoyPosY;

String[] data={"0", "0"};

void setup() {
  size(800, 800);
  frameRate(30);
  fill(10, 100, 150);
  stroke(10, 100, 150);
  rec = new rectangle(100, 100, 200, 100);
  joy = new joystick(width-50, height-50, 200);
  v1= new PVector(0, 0);
  v2= new PVector(0, 0);
  result= new PVector(0, 0);
  port = new Serial(this, "COM3", 9600);
  surface.setResizable(true);
}


void draw() { //draw() will clear using background(r,g,b) method
  Xval= int(data[0]); //values from the serial port ie.) joystick reading
  Yval= int(data[1]);
  background(200);

  JoyPosX= map(Xval, 0, 1023, joy.basex-joy.diameter/4, joy.basex+joy.diameter/4);// I want to map the values from the serial to the joystick
  JoyPosY= map(Yval, 0, 1023, joy.basey-joy.diameter/4, joy.basey+joy.diameter/4);

  joy.trans(JoyPosX, JoyPosY);
  if ((498<=Xval & Xval<=499) & (524<=Yval & Yval<=525)) { //range of varister values that represent idle. Caused my electronic interference.
    Speedx=0;
    Speedy=0; //translation speed set to 0 for rectangle
  } else {
    Speedx=map(joy.posx, joy.basex-joy.diameter/4, joy.basex+joy.diameter/4,  -10, 10);//constrain to make sure there is no overspeed. map will not "clamp" if value is out of range
    Speedy=map(joy.posy, joy.basey-joy.diameter/4, joy.basey+joy.diameter/4,  -10, 10);// map the joystick position to the speed we want to translate rectangle at
  }

  rec.trans(Speedx, Speedy); //translate/move the rectangle from current position 

  println(Xval+":"+Yval);//for diagnosis
}

void serialEvent(Serial myport) {//if theres data in the port do this stuff
  String inString=myport.readStringUntil('\n');// the arduino code sends the input as a string in CSV style ie."x,y\n"
  if (inString!=null) {

    inString= trim(inString); //remove any white space from the beginning and end of the string
    data= split(inString, ',');//split the input string where there is a comma and place each segment into the data array. this will be used in mapping.
  }
}

void keyPressed() {
  if (keyCode==UP) {//reset the shape to the top left corner with the UP arrow key
    background(200);
    rec.posx=0;
    rec.posy=0;
    rec.Re();
  //} else if (keyCode==DOWN) {
  //  background(200);
  //  rec.trans(0, speed);
  //  joy.Re();
  //} else if (keyCode==RIGHT) {//////////////this commented section is to be used for arrow key controls. replaced with joystick control
  //  background(200);
  //  rec.trans(speed, 0);
  //  joy.Re();
  //} else if (keyCode==LEFT) {
  //  background(200);
  //  rec.trans(-speed, 0);
  //  joy.Re();
  }
}



/////////////////////////////////////////////////////////////CLASSES DEFINED//////////////////////////////////////////////////////////
class rectangle { //class name

  float posx; //class attributes
  float posy;
  int lengx;
  int lengy;
  color col;

  //declare class constructor
  rectangle(float x, float y, int leng_x, int leng_y) { 

    posx=x;
    posy=y;//update the objects attributes
    lengx=leng_x;
    lengy=leng_y;
    rect(x, y, leng_x, leng_y); //create the rectangle
  }

  //declare function to check if mouse is inside the object.NOT USED IN PROJECT
  public boolean IsInRect() {
    if (mouseX>posx && mouseX<(posx+lengx)&& mouseY>posy && mouseY<(posy+lengy)) {
      return true;
    } else {
      return false;
    }
  }

  void Re() { //redraw rectangle
    rect(this.posx, this.posy, this.lengx, this.lengy);
  }

  void trans(float x, float y) { //move the rectangle from its current position. x and y are the speeds to move at
    posx=posx+x;
    posy= posy +y;
    Re();
  }

  void ShapeColor(float col1, float col2, float col3) {// could be used to change color of rectangle object. NOT USED IN PROJECT
    fill(col1, col2, col3);
    rect(posx, posy, lengx, lengy);
  }
}

class joystick {
  int basex, basey, posx, posy, diameter;

  joystick(int x, int y, int d) {
    basex=x;
    basey=y;
    posx=x;
    posy=y;
    diameter=d;
    fill(200, 100, 60);
    circle(basex, basey, diameter); //Base of the joystick
    fill(100);
    circle(posx, posy, diameter/2);//Moving part of the joystick
  }

  void Re() { //redraw joystick set (base and "stick")
    fill(200, 100, 60);
    circle(this.basex, this.basey, this.diameter);
    fill(100);
    circle(this.posx, this.posy, this.diameter/2);
  }

  void trans(float x, float y) { //animate the joystick. USED IN A GENERAL CASE. will follow anypoint on the screen...no need to limit the radius the stick and travel.

    float mag=sqrt(sq(x-this.basex)+sq(y-this.basey));

    v1.set(x-this.basex, y-this.basey);

    v1.setMag(mag);
    v1.limit(this.diameter/4);

    this.posx=this.basex+int(v1.x);
    this.posy=this.basey+int(v1.y);
    Re();
  }
}
