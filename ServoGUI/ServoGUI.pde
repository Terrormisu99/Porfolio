import processing.serial.*;

Serial port;


PVector vector1, vector2;

float y, angle;
void setup() {
  size(800, 800);
  surface.setTitle("Servo Control GUI");
  surface.setLocation(200,100);
  surface.setResizable(true);
  frameRate(30);
  
  vector2=new PVector(1, 0);
  vector1= new PVector(0, 0);
  port = new Serial(this,"COM3",9600);
}




void draw() {
 
   if (mousePressed){ 
  background(200);
  fill(20, 30, 100);
  arc(width/2, height/2, width, height, PI, 2*PI);
  stroke(100,100,200);
  line(width/2, height/2,width/2,0); //90 degree mark

  y=sqrt(sq(width/2)-sq((mouseX-width/2)))+width/2; //positive half of the circle

  //creates a vector representing the swing arm
  vector1.set(mouseX-width/2, (height-y)-height/2);
  
  //the swing arm that starts at the center of the meter
  stroke(200,10,200);
  line(width/2, height/2, mouseX, height-y);

  //calculate the angle between the swing arm and the base of meter
  angle= PVector.angleBetween(vector1, vector2)*180/PI; 
  
  port.write(byte(angle));
  textSize(32);
  fill(200,10,200);
  //String FormatedAngle= nf(angle,0,2);
  //text(FormatedAngle,50,height/2,width-50,200);
  if (str(angle)!="NaN"){
  text(str(angle),width/2-40,height/2,width-50,height/2);
  } else{
   text("0",width/2-40,height/2,width-50,height/2); 
  }
  text("Press, Hold, and Drag to change servo POSITION",width*0.025,height/2+50,width-50,height/2);
  println(mouseX+" : "+y+" :"+ angle);
   }
  
}
