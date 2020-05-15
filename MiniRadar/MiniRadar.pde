import processing.serial.*;

String data[]={"0", "0"}; 
PVector v1;
Serial port;

void setup() {
  size(400, 400);

  v1= new PVector(0, 0);
  port = new Serial(this, "COM3", 9600);
  stroke(200, 10, 50);
  surface.setResizable(true);
  background(30);
  for (int diameter=50; diameter<900; diameter+=50) {//distance indicating circles
    noFill();
    stroke(40, 100, 200);
    circle(width/2, height, diameter);
  }
}

void draw() {

  int angle=int(data[0]);
  int mag=int(data[1]);
  println(angle);
  
  if (angle==20 |angle==160) {
    background(30);
    for (int diameter=50; diameter<900; diameter+=50) {//distance indicating circles
      noFill();
      stroke(40, 100, 200);
      circle(width/2, height, diameter);
    }
  }
  
  drawline(angle, mag);
}

void drawline(int angle, int mag) {

  float posx, posy;
  PVector.fromAngle(radians(angle), v1);
  v1.setMag(mag);
  posx=v1.x;
  posy=v1.y;



  line(width/2, height, width/2+posx, height-posy);
}

void serialEvent(Serial myport) {//if theres data in the port do this stuff
  String inString=myport.readStringUntil('\n');// the arduino code sends the input as a string in CSV style ie."x,y\n"
  if (inString!=null) {

    inString= trim(inString); //remove any white space from the beginning and end of the string
    data= split(inString, ',');//split the input string where there is a comma and place each segment into the data array. this will be used in mapping.
  }
}
