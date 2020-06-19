
circ cir;
PVector speed;

float gravity=0.5;
float speedY, speedX;
float Mag;

void setup() {
  size(800, 800);
  cir= new circ(100, 100, 100);
  speed= new PVector(3, 4);
}


void draw() {


  background(20, 10, 200);
  println( str(speed.x)+" : "+ str(speed.y));
  line(0, height-cir.radius, width, height-cir.radius);
  line(0, cir.radius, width, cir.radius);
  Mag=speed.mag();


  cir.move(speed.x, speed.y);
  if (mouseX>=cir.posx-cir.radius && mouseX<=cir.posx+cir.radius) {
    if (mouseY<=(sqrt(sq(cir.radius)-sq(mouseX-cir.posx))+cir.posy) && mouseY>=(sqrt(sq(cir.radius-8)-sq(mouseX-cir.posx))+cir.posy) ) {
      speed.x=mouseX-cir.posx;
      speed.y=(sqrt(sq(cir.radius)-sq(mouseX-cir.posx))+cir.posy)-cir.posy;
      speed.rotate(PI);
      speed.setMag(Mag);
      //println("hdkfhuadghoaeuhgoheugkeg");
    }
  }
  
  if (mouseX>=cir.posx-cir.radius && mouseX<=cir.posx+cir.radius) {
    if (mouseY>=(-sqrt(sq(cir.radius)-sq(mouseX-cir.posx))+cir.posy) && mouseY<=(-sqrt(sq(cir.radius-8)-sq(mouseX-cir.posx))+cir.posy) ) {
      speed.x=mouseX-cir.posx;
      speed.y=(-sqrt(sq(cir.radius)-sq(mouseX-cir.posx))+cir.posy)-cir.posy;
      speed.rotate(PI);
      speed.setMag(Mag);
      //println("hdkfhuadghoaeuhgoheugkeg");
    }
  }

  line(cir.posx, cir.posy, cir.posx+speed.x, cir.posy+speed.y);

  if (cir.posy+cir.radius>=height) { //if it hits the bottom, change direction
    speed.y= -1*speed.y;
    // fill(random(0,255),random(0,255),random(0,255));
  }
  if (cir.posy-cir.radius<=0) {//if it hits the top, change direction
    speed.y= -1*speed.y;
    //fill(random(0,255),random(0,255),random(0,255));
  }

  if (cir.posx-cir.radius<=0) {//if it hits left side, change x direction
    speed.x*=-1;
    // fill(random(0,255),random(0,255),random(0,255));
  }
  if (cir.posx+cir.radius>=width) {//if it hits right side, change x direction
    speed.x*=-1;
    //fill(random(0,255),random(0,255),random(0,255));
  }
}

void mousePressed() {//allows the user to change the drop height of the ball

  cir.posx=mouseX;
  cir.posy=mouseY;
  speed.y=2;
  speed.x=2;
}

void mouseMoved() {
}


class circ { //class name

  float posx; //class attributes
  float posy;
  float radius;
  color col;
  // boolean UpOrDown=false; //up =true, down=false

  //declare class constructor
  circ(float x, float y, float radius_in) { 
    posx=x;
    posy=y;//update the objects attributes
    radius=radius_in; //2 times becasue the circle function uses diameter
    circle(posx, posy, radius*2); //create the rectangle
  }

  //declare function to check if mouse is inside the object
  boolean IsInCircle() {
    if (mouseX>this.posx-this.radius && mouseX<(this.posx+this.radius)&& mouseY>(-sqrt(sq(this.radius)-sq(mouseX-this.posx))+this.posy) && mouseY<(sqrt(sq(this.radius)-sq(mouseX-this.posx))+this.posy)) {
      return true;
    } else {
      return false;
    }
  }

  void Redraw() {
    circle(this.posx, this.posy, this.radius*2);
    line(this.posx-this.radius, this.posy, this.posx+this.radius, this.posy);
    line(this.posx, this.posy-this.radius, this.posx, this.posy+this.radius);
  }

  void move(float x, float y) {

    //if (this.posy-this.radius<=0) {
    //  this.UpOrDown= false;
    //}
    //if (this.posy+this.radius>=height) {
    //  this.UpOrDown= true;
    //}

    this.posx=this.posx+x;
    this.posy=this.posy+y;
    //if ( cir.posy+cir.radius<=height) {// only apply "gavity" when it is within the limits of the window
    //   speed.y=speed.y+gravity;
    //}
    this.Redraw();
  }
}
